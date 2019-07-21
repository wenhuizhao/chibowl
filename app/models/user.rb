class User < ApplicationRecord
  has_many :chefs
  has_many :orders
  geocoded_by :address
  has_attached_file :avatar, 
    styles: { large: "600x600>", medium: "300x300>", thumb: "100x100>" }, 
    default_url: "/images/:style/missing_avatar.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]
  after_initialize :set_default_role, if: :new_record?
  after_validation :geocode

  enum role: [:user, :chef, :admin]

  def address
    [street, city, state, country].compact.join(', ')
  end

  def set_default_role
    self.role ||= :user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end     

  
end
