require "rails_helper"

RSpec.describe OrderDetail, type: :model do
  describe "associations" do
    it "belongs to order" do
      is_expected.to belong_to(:order)
    end

    it "belongs to product" do
      is_expected.to belong_to(:product)
    end
  end
end
