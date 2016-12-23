class Song < ActiveRecord::Base
  belongs_to :user

  has_attached_file :audio
  validates_attachment_presence :audio
  validates_attachment_content_type :audio, content_type: ['audio/mp3','audio/mpeg']

  def self.random
    ids = connection.select_all("SELECT id FROM songs")
    find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end

  def self.song_adjust(song)  #llegan los dos parámetros
    TagLib::FileRef.open(song.audio.path) do |fileref|
      unless fileref.null?
        tag = fileref.tag
        #song.name = tag.title   #=> "Wake Up"
        #song.artist = tag.artist  #=> "Arcade Fire"
        #song.album = tag.album   #=> "Funeral"
        #tag.year    #=> 2004
        #tag.track   #=> 7
        #tag.genre   #=> "Indie Rock"
        #tag.comment #=> nil

        properties = fileref.audio_properties

        segundostotales = properties.length
        minutos = segundostotales / 60
        segundos = segundostotales-(minutos*60)
        if segundos>10
          song.duration = minutos.to_s + ":" + segundos.to_s  #=> 335 (song length in seconds)
        else
          song.duration = minutos.to_s + ":0" + segundos.to_s
        end
      end
    end
  end
end
