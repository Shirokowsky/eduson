class Photo < ActiveRecord::Base
  validates :title, :image, presence: true

  has_attached_file :image, url: "/system/:class/:hash/:style.:extension", hash_secret: "longSecretString", styles: {:thumb=>"200x200>", :full=>"800x800>", :prew=>"600x600>"}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
