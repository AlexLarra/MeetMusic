class RemoveReprodFromSongs < ActiveRecord::Migration
  def change
    remove_column :songs, :reprod, :integer
  end
end
