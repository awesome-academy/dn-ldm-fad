require "rails_helper"

RSpec.describe ProductType, type: :model do
  describe "associations" do
    it "should have many products" do
      is_expected.to have_many(:products).dependent :destroy
    end
  end
end
