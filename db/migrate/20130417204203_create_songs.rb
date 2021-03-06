class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.string :album
      t.string :artist
      t.string :duration
      t.integer :reprod
      t.references :user

      t.timestamps
    end
    add_index :songs, :user_id
  end
end
