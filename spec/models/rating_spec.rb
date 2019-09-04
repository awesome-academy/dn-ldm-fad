require "rails_helper"

RSpec.describe Rating, type: :model do
  describe "associations" do
    it "belongs to user" do
      is_expected.to belong_to(:user)
    end

    it "belongs to product" do
      is_expected.to belong_to(:product)
    end
  end
end
