class SongsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :signed_in?
  
  # GET /songs
  # GET /songs.json
  def index
    @songs = current_user.songs.order(sort_column + ' ' + sort_direction)
    @p_song, @c_song, @n_song = load_prev_current_next(@songs, @songs.first)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @song = current_user.songs.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @song }
    end
  end

  # GET /songs/new
  # GET /songs/new.json
  def new
    @song = Song.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @song }
    end
  end

  # GET /songs/1/edit
  def edit
    @song = current_user.songs.find(params[:id])
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = current_user.songs.new(params[:song])
    @song.name = @song.audio_file_name

    respond_to do |format|
      if @song.save
        format.html { redirect_to songs_path, notice: "#{@song.name} was successfully created." }
      else
        format.html { render action: "new" }
      end
    end

    # NOTE: check this shit
    song = @song
    Song.song_adjust(song)
    @song.update_attribute(:duration, song.duration)
    
  end

  # PUT /songs/1
  # PUT /songs/1.json
  def update
    @song = current_user.songs.find(params[:id])

    respond_to do |format|
      if @song.update_attributes(params[:song])
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song = current_user.songs.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to songs_url }
      format.json { head :no_content }
    end
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
    @normal = current_user.songs
    @songs = @normal.reverse
    
    respond_to do |format|
      format.html # index.html.erb
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
    @p_song, @c_song, @n_song = load_prev_current_next(@songs, @song)
  end
  
  
  private
  def load_prev_current_next(songs, current)
    return nil if songs.empty?
    current_index = songs.rindex(current)
    [
      songs.at(current_index - 1), 
      current, 
      songs.at(current_index + 1)
    ]
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
