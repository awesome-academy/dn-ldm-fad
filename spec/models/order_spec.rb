require "rails_helper"

RSpec.shared_examples "when empty" do |field|
  it do
    order.save
    expect(order.errors[field].first).to eql I18n.t("errors.messages.blank")
  end
end

RSpec.shared_examples "When too long" do |field, count|
  it do
    order.save
    expect(order.errors[field].first).to eql I18n.t "errors.messages.too_long",
      count: count
  end
end

RSpec.describe Order, type: :model do
  let(:order) {FactoryBot.create :order}
  subject {order}
  before{order.save}

  it "should be valid" do
    expect(order).to be_valid
  end

  describe "#customer" do
    it{is_expected.to validate_presence_of :customer}
    it{is_expected.to validate_length_of(:customer).
      is_at_most(Settings.validates.maximum_name)}

    context "When the customer is empty" do
      before{order.customer = nil}
      it_behaves_like "when empty", :customer
    end

    context "When the customer is too long" do
      before{order.customer = "a"*200}
      it_behaves_like "When too long", :customer,
        Settings.validates.maximum_name
    end
  end

  describe "#phone" do
    it{is_expected.to validate_presence_of :customer}
    it{is_expected.to validate_numericality_of(:phone)}
    it{is_expected.to validate_length_of(:phone).
      is_equal_to(Settings.validates.maximum_phone)}

    context "When the phone is empty" do
      before{order.phone = nil}
      it_behaves_like "when empty", :phone
    end

    it "is invalid phone" do
      order.phone = 12345678910
      is_expected.not_to be_valid
    end

    it "is valid phone" do
      order.phone = 1234567891
      is_expected.to be_valid
    end
  end

   describe "#address" do
    it{is_expected.to validate_presence_of :customer}
    it{is_expected.to validate_length_of(:address).
      is_at_most Settings.validates.maximum_address}

    context "When the address is empty" do
      before{order.address = nil}
      it_behaves_like "when empty", :address
    end

    context "when the address is too long" do
      before{order.address = "a"*300}
      it_behaves_like "When too long", :address,
        Settings.validates.maximum_address
    end
  end

  describe "#status" do
    it{is_expected.to validate_presence_of :status}

    context "When the status is empty" do
      before{order.status = nil}
      it_behaves_like "when empty", :status
    end

    it "is valid status" do
      order.status = 0
      is_expected.to be_valid
    end
  end

  describe "associations" do
    it "belongs to user" do
      is_expected.to belong_to(:user)
    end

    it "should have many order_details" do
      is_expected.to have_many(:order_details).dependent :destroy
    end

    it "should have one payment" do
      is_expected.to have_one(:payment).dependent :destroy
    end

    it "should have many products" do
      is_expected.to have_many(:products).through :order_details
    end
  end
end
