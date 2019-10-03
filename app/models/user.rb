class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable, :omniauthable,
    omniauth_providers: [:facebook, :google_oauth2]

  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy
  enum sex: {male: 0, female: 1}
  enum role: {user: 0, admin: 1}
  validates :name, presence: true,
    length: {maximum: Settings.validates.maximum_name}
  validates :phone, length: {maximum: Settings.validates.maximum_phone}
  validates :address, length: {maximum: Settings.validates.maximum_address}
  before_save :downcase_email
  mount_uploader :picture, PictureUploader
  scope :sort_desc, ->{order created_at: :desc}
  scope :by_name_email_phone, (lambda do |key_search|
    where "name LIKE (?) OR email LIKE (?) OR phone LIKE (?)",
      "%#{key_search}%", "%#{key_search}%", "%#{key_search}%"
  end)
  private

  def downcase_email
    email.downcase!
  end

  class << self
    def from_omniauth auth
      result = User.where(email: auth.info.email).first
      return result if result
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        user.picture = auth.info.image_url
        user.uid = auth.uid
        user.provider = auth.provider
        user.skip_confirmation!
      end
    end
  end
end
