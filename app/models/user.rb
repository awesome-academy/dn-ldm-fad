class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy
  enum sex: {male: 0, female: 1}
  enum role: {user: 0, admin: 1}
  validates :name, presence: true,
    length: {maximum: Settings.validates.maximum_name}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.validates.maximum_email},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, allow_nil: true,
    length: {minimum: Settings.validates.minimum_password}
  validates :phone, numericality: {only_integer: true},
    length: {is: Settings.validates.maximum_phone}
  validates :address, length: {maximum: Settings.validates.maximum_address}
  before_save :downcase_email
  has_secure_password
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
end
