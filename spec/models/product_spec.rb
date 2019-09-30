require "rails_helper"

RSpec.shared_examples "when empty" do |field|
  it do
    product.save
    expect(product.errors[field].first).to eql I18n.t("errors.messages.blank")
  end
end

RSpec.shared_examples "When too long" do |field, count|
  it do
    product.save
    expect(product.errors[field].first).to eql I18n.t "errors.messages.too_long",
      count: count
  end
end

RSpec.describe Product, type: :model do
  let(:product) {FactoryBot.create :product}
  subject {product}
  before{product.save}

  it "should be valid" do
    expect(product).to be_valid
  end

  describe "#name" do
    it{is_expected.to validate_presence_of :name}
    it{is_expected.to validate_length_of(:name).
      is_at_most(Settings.validates.maximum_name)}

    context "When the name is empty" do
      before{product.name = nil}
      it_behaves_like "when empty", :name
    end

    context "When the name is too long" do
      before{product.name = "a"*200}
      it_behaves_like "When too long", :name, Settings.validates.maximum_name
    end
  end

  describe "#price" do
    it{is_expected.to validate_presence_of :price}
    it{is_expected.to validate_numericality_of(:price)}

    context "When the price is empty" do
      before{product.price = nil}
      it_behaves_like "when empty", :price
    end

    it "is invalid price" do
      product.price = "abc300"
      is_expected.not_to be_valid
    end

    it "is valid price" do
      product.price = 300000
      is_expected.to be_valid
    end
  end

  describe "#quantity" do
    it{is_expected.to validate_presence_of :quantity}
    it{is_expected.to validate_numericality_of(:quantity)}

    context "When the quantity is empty" do
      before{product.quantity = nil}
      it_behaves_like "when empty", :quantity
    end

    it "is invalid quantity" do
      product.quantity = "abc300"
      is_expected.not_to be_valid
    end

    it "is valid quantity" do
      product.quantity = 300
      is_expected.to be_valid
    end
  end

  describe "#picture" do
    it "With png file it should be valid" do
      path_to_jpg_file = Rails.root + "spec/files/image.jpg"
      File.open(path_to_jpg_file) {|f| product.picture.store!(f)}
      expect(product).to be_valid
    end

    it "With txt file it should be invalid" do
      path_to_txt_file = Rails.root + "spec/files/text.txt"
      File.open(path_to_txt_file) {|f| product.picture.store!(f)}
      expect(product).to_not be_valid
    end
  end

  describe "#status" do
    it{is_expected.to validate_presence_of :status}

    context "When the status is empty" do
      before{product.status = nil}
      it_behaves_like "when empty", :status
    end

    it "is valid status" do
      product.status = 0
      is_expected.to be_valid
    end
  end

  describe "associations" do
    it "belongs to category" do
      is_expected.to belong_to(:category)
    end

    it "belongs to product_type" do
      is_expected.to belong_to(:product_type)
    end

    it "should have many order_details" do
      is_expected.to have_many(:order_details).dependent :destroy
    end

    it "should have many ratings" do
      is_expected.to have_many(:ratings).dependent :destroy
    end

    it "should have many orders" do
      is_expected.to have_many(:orders).through :order_details
    end
  end
end
