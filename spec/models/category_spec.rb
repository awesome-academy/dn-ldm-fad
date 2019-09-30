require "rails_helper"

RSpec.shared_examples "when empty" do |field|
  it do
    category.save
    expect(category.errors[field].first).to eql I18n.t("errors.messages.blank")
  end
end

RSpec.shared_examples "When too long" do |field, count|
  it do
    category.save
    expect(category.errors[field].first).to eql I18n.t "errors.messages.too_long",
      count: count
  end
end

RSpec.describe Category, type: :model do
  let(:category) {FactoryBot.create :category}
  subject {category}
  before{category.save}

  it "should be valid" do
    expect(category).to be_valid
  end

  describe "#name" do
    it do
     is_expected.to validate_presence_of(:name)
                .with_message("không thể để trắng")
    end
    it do
      is_expected.to validate_length_of(:name)
                 .is_at_most(Settings.validates.maximum_name_cate)
                 .with_message("quá dài (tối đa 255 ký tự)")
    end
    it{is_expected.to validate_uniqueness_of(:name).case_insensitive}
    context "when the name is empty" do
      before{category.name = nil}
      it_behaves_like "when empty", :name
    end

    context "when the name is too long" do
      before{category.name = "a"*256}
      it_behaves_like "When too long", :name,
        Settings.validates.maximum_name_cate
    end
  end

  describe "associations" do
    it "should have many products" do
      is_expected.to have_many(:products).dependent :destroy
    end
  end
end
