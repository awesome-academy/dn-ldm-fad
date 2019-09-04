require "rails_helper"

RSpec.describe Banking, type: :model do
  describe "associations" do
    it "should have many payment_bankings" do
      is_expected.to have_many(:payment_bankings).dependent :destroy
    end

    it "should have many payment_bankings" do
      is_expected.to have_many(:payments).through :payment_bankings
    end
  end
end
