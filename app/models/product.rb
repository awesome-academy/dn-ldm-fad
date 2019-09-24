class Product < ApplicationRecord
  belongs_to :category
  belongs_to :product_type
  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :orders, through: :order_details
  delegate :name, to: :category, prefix: :category
  delegate :name, to: :product_type, prefix: :product_type
  enum status: {hide: 0, display: 1}
  validates :name, presence: true,
    length: {maximum: Settings.validates.maximum_name}
  validates :price, presence: true
  validates :quantity, presence: true
  validates :category_id, presence: true
  validates :product_type_id, presence: true
  validate  :picture_size
  scope :sort_desc, ->{order created_at: :desc}
  scope :by_ids, ->(ids){where id: ids}
  scope :get_price, ->(id){where(id: id).pluck(:price).first}
  scope :by_name_price, (lambda do |name_product, price|
    where "name LIKE (?) OR price <= (?)", "%#{name_product}%", price
  end)
  scope :by_category, ->(id){where category_id: id}
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return unless picture.size > Settings.validates.img_product_size.megabytes
    errors.add(:picture, I18n.t("admin.products.img_size"))
  end
end
