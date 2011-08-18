class AddContentToSlideshows < ActiveRecord::Migration
  def self.up
    add_column :slides, :caption, :text
  end

  def self.down
    remove_column :slides, :caption
  end
end
