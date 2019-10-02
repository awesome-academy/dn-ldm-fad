class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable,
  #:recoverable
  devise :database_authenticatable, :registerable, :rememberable, :validatable

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
end
