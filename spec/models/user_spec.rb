require "rails_helper"

RSpec.shared_examples "when empty" do |field|
  it do
    user.save
    expect(user.errors[field].first).to eql I18n.t("errors.messages.blank")
  end
end

RSpec.shared_examples "When too long" do |field, count|
  it do
    user.save
    expect(user.errors[field].first).to eql I18n.t "errors.messages.too_long",
      count: count
  end
end

RSpec.describe User, type: :model do
  let(:user) {FactoryBot.create :user}
  subject {user}
  before{user.save}

  it "should be valid" do
    expect(user).to be_valid
  end

  describe "#name" do
    it{is_expected.to validate_presence_of :name}
    it{is_expected.to validate_length_of(:name).
      is_at_most(Settings.validates.maximum_name)}

    context "When the name is empty" do
      before{user.name = nil}
      it_behaves_like "when empty", :name
    end

    context "When the name is too long" do
      before{user.name = "a"*200}
      it_behaves_like "When too long", :name, Settings.validates.maximum_name
    end
  end

  describe "#email" do
    it{is_expected.to validate_presence_of :email}
    it{is_expected.to validate_length_of(:email).
      is_at_most(Settings.validates.maximum_email)}
    it{is_expected.to validate_uniqueness_of(:email).case_insensitive}

    context "when the email is empty" do
      before{user.email = nil}
      it_behaves_like "when empty", :email
    end

    context "when the email is too long" do
      before{user.email = "a"*256}
      it_behaves_like "When too long", :email, Settings.validates.maximum_email
    end

    context "when email format is invalid" do
      it "should be invalid" do
        emails = %w[leducmanh@foo,com leducmanh.org leducmanh@foo.
          foo@bar_baz.com foo@bar+baz.com]
        emails.each do |invalid_address|
          user.email = invalid_address
          expect(user).not_to be_valid
        end
      end
    end

    describe "when email format is valid" do
      it "should be valid" do
        addresses = %w[leducmanh@foo.COM leducmanh@f.b.org le.duc.manh@foo.jp
          a+b@baz.cn]
        addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end
  end

  describe "#phone" do
    it{is_expected.to validate_numericality_of(:phone)}
    it{is_expected.to validate_length_of(:phone).
      is_equal_to(Settings.validates.maximum_phone)}

    it "is invalid phone" do
      user.phone = 12345678910
      is_expected.not_to be_valid
    end

    it "is valid phone" do
      user.phone = 1234567891
      is_expected.to be_valid
    end
  end

   describe "#address" do
    it{is_expected.to validate_length_of(:address).
      is_at_most Settings.validates.maximum_address}

    context "when the address is too long" do
      before{user.address = "a"*300}
      it_behaves_like "When too long", :address,
        Settings.validates.maximum_address
    end
  end

  describe "associations" do
    it "should have many orders" do
      is_expected.to have_many(:orders).dependent :destroy
    end

    it "should have many ratings" do
      is_expected.to have_many(:ratings).dependent :destroy
    end
  end
end
