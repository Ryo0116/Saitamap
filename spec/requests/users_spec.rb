require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user) }

  describe "ログイン前" do
    it "新規登録ページへのレスポンスが正しく返ってくる事" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end

    it "ログインページへのレスポンスが正しく返ってくる事" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe "ログイン後" do
    before do
      sign_in user
    end

    it "ユーザー詳細ページへのレスポンスが正常に返ってくる事" do
      get user_path(user)
      expect(response).to have_http_status(200)
    end

    it "ユーザー編集ページへのレスポンスが正常に返ってくる事" do
      get edit_user_path(user)
      expect(response).to have_http_status(200)
    end

    it "ユーザーパスワード編集ページへのレスポンスが正常に返ってくる事" do
      get edit_user_registration_path
      expect(response).to have_http_status(200)
    end
  end
end