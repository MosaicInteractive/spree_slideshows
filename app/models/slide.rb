class Slide < ActiveRecord::Base

  validates_presence_of :name
  validates_presence_of :url

  has_attached_file :img,
                    :styles => {
                       :thumb => "100x100#"
                    },    :url => "/assets/products/:id/:style_:basename.:extension",
    :path => ":rails_root/public/assets/products/:id/:style_:basename.:extension",
    :storage => Rails.env == 'production' ? 's3' : 'filesystem',
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :bucket => ENV['S3_BUCKET']

  scope :included, where(:enabled => true, :included => true)
  scope :not_included, where(:enabled => true, :included => false)
  scope :order_by_pos, order(:position)
  scope :in_group, lambda { |group| where("groups LIKE ? OR groups IS NULL OR groups = ?", "%#{group}%", "") }

end
