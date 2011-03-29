class Slide < ActiveRecord::Base

  validates_presence_of :name
  validates_presence_of :url

  has_attached_file :img,
                    :styles => {
                       :thumb => "100x100#"
                    },
                    :url => "/assets/slides/:id/:style_:basename.:extension",
                    :path => ":rails_root/public/assets/slides/:id/:style_:basename.:extension"

  scope :included, where(:enabled => true, :included => true)
  scope :not_included, where(:enabled => true, :included => false)
  scope :order_by_pos, order(:position)
  scope :in_group, lambda { |group| where("groups LIKE ? OR groups IS NULL OR groups = ?", "%#{group}%", "") }

end
