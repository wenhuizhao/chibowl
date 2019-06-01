class Photo < ApplicationRecord
  belongs_to :owner, polymorphic: true
  has_attached_file :image, styles: { small: "64x64", med: "250x250", large: "600x600" }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  after_post_process :save_image_dimensions

  def global_owner
    self.owner.to_global_id if self.owner.present?
  end

  def global_owner=(owner)
    self.owner = GlobalID::Locator.locate(owner)
  end
  
  def save_image_dimensions
    geo = Paperclip::Geometry.from_file(image.queued_for_write[:original])
    self.width = geo.width
    self.height = geo.height
  end
end
