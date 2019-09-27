require "rails_helper"

RSpec.describe "users/new.html.erb", type: :view do
  let(:user) {User.new}
  subject {rendered}

  before do
    assign :user, user
    render
  end

  describe "users/new.html.erb" do
    it{expect(user).to be_present}

    describe "register form" do
      it{is_expected.to have_field "user_name"}
      it{is_expected.to have_field "user_email"}
      it{is_expected.to have_field "user_password"}
      it{is_expected.to have_field "user_password_confirmation"}
      it{is_expected.to have_field "user_sex_#{Settings.sex.male}"}
      it{is_expected.to have_field "user_sex_#{Settings.sex.female}"}
      it{is_expected.to have_field "user_birthday_1i"}
      it{is_expected.to have_field "user_birthday_2i"}
      it{is_expected.to have_field "user_birthday_3i"}
      it{is_expected.to have_field "user_phone"}
      it{is_expected.to have_field "user_address"}
      it{have_submit_button I18n.t("users.register")}
    end
  end
end
