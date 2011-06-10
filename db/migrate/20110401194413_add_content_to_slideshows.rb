class AddContentToSlideshows < ActiveRecord::Migration
  def self.up
    add_column :slides, :content, :text
  end

  def self.down
    remove_column :slides, :content
  end
end
