class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_one :rating, dependent: :destroy
  enum sex: {male: 0, female: 1}
  enum role: {user: 0, admin: 1}
  validates :name, presence: true,
    length: {maximum: Settings.validates.maximum_name}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.validates.maximum_email},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.validates.minimum_password}, allow_nil: true
  before_save :downcase_email
  has_secure_password
  mount_uploader :picture, PictureUploader

  private

  def downcase_email
    email.downcase!
  end
end
