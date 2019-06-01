class Chef < ApplicationRecord
  belongs_to :user
  has_many :photos, as: :owner
  geocoded_by :address
  after_validation :geocode
#  reverse_geocoded_by :latitude, :longitude
#  after_validation :reverse_geocode
  scope :featured, -> { where(featured: true)}

  def address
    [street, city, state, country].compact.join(', ')
  end

end
