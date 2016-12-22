class SongsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :signed_in?

  def index
    @songs = current_user.songs.order(sort_column + ' ' + sort_direction)
    load_prev_current_next(@songs, @songs.first)
  end

  def show
    @song = current_user.songs.find(params[:id])
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

    if @song.update(song_params)
      redirect_to @song, notice: 'Song was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @song = current_user.songs.find(params[:id])
    @song.destroy

    redirect_to songs_url
  end

  def song_download
    @song = current_user.songs.find(params[:id])
    file_path = @song.audio_file_name

    if !file_path.nil?
      send_file @song.audio.path#(:original, false) , :x_sendfile => true
    else
      redirect_to user_url
    end
  end

  def recientes
    @songs = current_user.songs.reverse
    load_prev_current_next(@songs, @songs.first)

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @songs }
    end
  end

  def all_songs_download
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
    @songs = current_user.songs.order(sort_column + ' ' + sort_direction)
    @song = current_user.songs.find(params[:id])
    load_prev_current_next(@songs, @song)
  end

  private

  def song_params
    params.require(:song).permit(:name, :artist, :album, :audio)
  end

  def load_prev_current_next(songs, current)
    return nil if songs.empty?
    current_index = songs.rindex(current)
    @p_song = songs.at(current_index - 1)
    @c_song = current
    @n_song = songs.at(current_index + 1)
    @r_song = Song.random
  end

  def signed_in?
    raise 'Unauthorized!!!!' unless current_user
  end

  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    params[:direction] || "asc"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end

  def sort_column
    Song.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
end
