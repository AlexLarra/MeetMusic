class SongsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :signed_in?

  def index
    @songs = current_user.songs.order(created_at: :desc)
  end

  def new
    @song = Song.new
  end

  def edit
    @song = current_user.songs.find(params[:id])
  end

  def create
    @song = current_user.songs.new(song_params)
    @song.name = @song.audio_file_name

    if @song.save
      redirect_to songs_path, notice: "#{@song.name} was successfully created."
    else
      render :new
    end

    # NOTE: check this shit
    song = @song
    Song.song_adjust(song)
    @song.update_attribute(:duration, song.duration)
  end

  def update
    @song = current_user.songs.find(params[:id])
    @song.update(song_params)
  end

  def destroy
    @song = current_user.songs.find(params[:id])
    @song.destroy

    redirect_to songs_url
  end

  def download
    @song = current_user.songs.find(params[:id])
    file_path = @song.audio_file_name

    if !file_path.nil?
      send_file @song.audio.path#(:original, false) , :x_sendfile => true
    else
      redirect_to user_url
    end
  end

  def download_all
    lista_canciones = current_user.songs
    if lista_canciones.present?
      file_name = "canciones.zip"
      t = Tempfile.new("my-temp-filename-#{Time.now}")
      Zip::ZipOutputStream.open(t.path) do |z|
        lista_canciones.each do |sg|
          title = sg.audio_file_name
          z.put_next_entry(title)
          z.print IO.read(sg.audio.path)
        end
      end
      send_file t.path, :type => 'application/zip',:disposition => 'attachment', :filename => file_name
      t.close   #el send_file debe hacerse desde el controlador y no desde el modelo
    end
  end

  def play
    @song = current_user.songs.find(params[:id])
  end

  private

  def song_params
    params.require(:song).permit(:name, :artist, :album, :audio)
  end

  def signed_in?
    raise 'Unauthorized!!!!' unless current_user
  end
end
