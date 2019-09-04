require "rails_helper"

RSpec.describe PaymentBanking, type: :model do
  describe "associations" do
    it "belongs to payment" do
      is_expected.to belong_to(:payment)
    end

    it "belongs to banking" do
      is_expected.to belong_to(:banking)
    end
  end
end
