class AddHasMovedToPieces < ActiveRecord::Migration
  def self.up
    add_column :pieces, :has_moved, :boolean
  end
  def self.down
    remove_column :pieces, :has_moved
  end
end
