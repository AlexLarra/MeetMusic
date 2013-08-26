class AddAttachmentAudioToSongs < ActiveRecord::Migration
  def self.up
    change_table :songs do |t|
      t.has_attached_file :audio
    end
  end

  def self.down
    drop_attached_file :songs, :audio
  end
end
