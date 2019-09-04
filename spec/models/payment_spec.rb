require "rails_helper"

RSpec.describe Payment, type: :model do
  describe "#type_payment" do
    it{is_expected.to validate_presence_of :type_payment}
  end

  describe "associations" do
    it "belongs to order" do
      is_expected.to belong_to(:order)
    end

    it "should have many payment_bankings" do
      is_expected.to have_many(:payment_bankings).dependent :destroy
    end

    it "should have many payments" do
      is_expected.to have_many(:payments).through :payment_bankings
    end
  end
end
