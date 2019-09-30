require "rails_helper"

RSpec.describe UsersController, type: :controller do
  include SessionsHelper

  let!(:user){FactoryBot.create :user}
  let(:user_params) do
    {name: "Le Duc Manh", email: "ldmanh101198@gmail.com", password: "123456",
      password_confirmation: "123456"}
  end
  let(:user_password_params){{old_password: "123456", password: "1234567",
    password_confirmation: "1234567"}}

  describe "GET #new" do
    it "when user not logged in" do
      get :new
      expect(response).to have_http_status :success
      expect(response).to render_template :new
    end

    it "when user logged in" do
      log_in user
      expect(response).to have_http_status :success
    end

    it "when user logged in should can not access signup page" do
      log_in user
      get :new
      expect(response).to redirect_to root_url
    end
  end

  describe "GET #show" do
    it "when user not logged in" do
      get :show, params:{id: user.id}
      expect(response).to redirect_to root_url
    end

    it "when user logged in" do
      log_in user
      get :show, params:{id: user.id}
      expect(response).to have_http_status :success
      expect(response).to render_template :show
    end
  end

  describe "POST #create" do
    before{log_in user}

    it "with valid attributes" do
      post :create, params: {user: FactoryBot.attributes_for(:user)}
      expect(flash[:success]) == I18n.t("users.register_success")
      expect(response).to redirect_to root_url
    end

    context "with invalid attributes" do
      before{user_params[:email] = ""}
      it do
        post :create, params: {user: user_params}
        expect(flash.now[:danger]) == I18n.t("users.register_fail")
        expect(response).to render_template :new
      end
    end

    context "when password and password confirm not same" do
      before do
        user_params[:password] = "leducmanh"
        user_params[:password_confirmation] = "123456"
      end
      it do
        post :create, params: {user: user_params}
        expect(assigns(:user).errors).to_not be_empty
      end
    end
  end

  describe "PATCH #update" do
    before{log_in user}

    it "with valid attributes" do
      patch :update, params: {id: user.id,
        user: FactoryBot.attributes_for(:user)}
      expect(assigns(:user)).to be_a User
      expect(flash[:success]) == I18n.t("users.update_success")
      expect(response).to redirect_to user
    end

    context "with invalid attributes" do
      before{user_params[:email] = ""}
      it do
        patch :update, params: {id: user.id, user: user_params}
        expect(flash[:danger]) == I18n.t("users.register_fail")
        expect(response).to redirect_to user
      end
    end

    context "when password and password confirm not same" do
      before do
        user_params[:password] = "leducmanh"
        user_params[:password_confirmation] = "123456"
      end
      it do
        patch :update, params: {id: user.id, user: user_params}
        expect(assigns(:user).errors).to_not be_empty
      end
    end
  end

  describe "GET #change_password" do
    it "when user not logged in" do
      get :change_password, params:{id: user.id}
      expect(response).to redirect_to root_url
    end

    it "when user logged in" do
      log_in user
      get :change_password, params:{id: user.id}
      expect(response).to have_http_status :success
      expect(response).to render_template :change_password
    end
  end

  describe "PATCH #change_password" do
    before{log_in user}

    context "When empty old password" do
      before{user_password_params[:old_password] = nil}
      it do
        patch :change_password, params: {id: user.id, user: user_password_params}
        expect(response).to render_template :change_password
      end
    end

    context "When old password and password not same" do
      before{user_password_params[:old_password] = "l1d2m3456"}
      it do
        patch :change_password, params: {id: user.id, user: user_password_params}
        expect(response).to render_template :change_password
      end
    end

    it "with valid attributes" do
      patch :change_password, params: {id: user.id, user: user_password_params}
      expect(assigns(:user)).to be_a User
      expect(flash[:success]) == I18n.t("users.change_password_success")
      expect(response).to have_http_status :success
    end
  end
end
