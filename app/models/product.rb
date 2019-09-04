class Product < ApplicationRecord
  belongs_to :category
  belongs_to :product_type
  has_many :order_details, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :orders, through: :order_details
  delegate :name, to: :category, prefix: :category
  delegate :name, to: :product_type, prefix: :product_type
  enum status: {hide: 0, display: 1}
  VALID_IMG_REGEX = /.(jpg|png)\Z/i
  validates :name, presence: true,
    length: {maximum: Settings.validates.maximum_name}
  validates :price, presence: true
  validates :quantity, presence: true
  validates :category_id, presence: true
  validates :product_type_id, presence: true
  validate  :picture_size
  validates :picture, allow_blank: true,
    format: {with: VALID_IMG_REGEX, message: I18n.t("admin.products.img_erorr")}
  scope :sort_desc, ->{order created_at: :desc}
  scope :by_ids, ->(ids){where id: ids}
  scope :get_price, ->(id){where(id: id).pluck(:price).first}
  scope :by_name_price, (lambda do |name_product, price|
    where "name LIKE (?) OR price <= (?)", "%#{name_product}%", price
  end)
  scope :by_category, ->(id){where category_id: id}
  scope :by_price, ->(min, max){where "price BETWEEN (?) AND (?)", min, max}
  scope :by_cate_ids, (lambda do |cate_ids|
    where "category_id IN (?)", cate_ids if cate_ids.present?
  end)
  scope :by_type_ids, (lambda do |type_ids|
    where "product_type_id IN (?)", type_ids if type_ids.present?
  end)
  scope :by_cate_type, (lambda do |cate_ids, type_ids|
    if cate_ids.present? && type_ids.present?
      by_cate_ids(cate_ids).or by_type_ids(type_ids)
    end
  end)
  mount_uploader :picture, PictureUploader

  private

  def picture_size
    return unless picture.size > Settings.validates.img_product_size.megabytes
    errors.add(:picture, I18n.t("admin.products.img_size"))
  end
end
