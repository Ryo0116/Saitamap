require 'rails_helper'

RSpec.describe "Spots", type: :request do
  let(:user) { create(:user) }
  let!(:new_spot) { create(:spot, user: user) }

  describe "GET #index" do
    before do
      get spots_path
    end

    it "リクエストが成功する事" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #new" do
    before do
      sign_in user
      get new_spot_path
    end

    it "リクエストが成功する事" do
      expect(response).to have_http_status(200)
    end
  end

  describe "spot #create" do
    let(:spot_params) { attributes_for(:spot) }
    let(:invalid_spot_params) { attributes_for(:spot, :invalid) }

    before do
      sign_in user
    end

    context "パラメーターが有効な場合" do
      it "リクエストが成功する事" do
        spot spots_path, params: { spot: spot_params }
        expect(response).to have_http_status(302)
      end

      it "データベースへの保存に成功する事" do
        expect {
          spot spots_path, params: { spot: spot_params }
        }.to change(user.spots, :count).by(1)
      end

      it "リダイレクトに成功する事" do
        spot spots_path, params: { spot: spot_params }
        expect(response).to redirect_to spots_path
      end
    end

    context "パラメーターが無効な場合" do
      it "リクエストが成功する事" do
        spot spots_path, params: { spot: invalid_spot_params }
        expect(response).to have_http_status(200)
      end

      it "データベースへの保存に失敗する事" do
        expect {
          spot spots_path, params: { spot: invalid_spot_params }
        }.not_to change(user.spots, :count)
      end

      it "エラーが表示される事" do
        spot spots_path, params: { spot: invalid_spot_params }
        expect(response.body).to include "新規投稿に失敗しました"
      end
    end
  end

  describe "GET #show" do
    it "リクエストが成功する事" do
      sign_in user
      get spot_path(new_spot)
      expect(response).to have_http_status(200)
    end

    it "未ログインの場合、正常なレスポンスが返ってこない事" do
      get spot_path(new_spot)
      expect(response).not_to have_http_status(200)
    end
  end

  describe "GET #edit" do
    before do
      sign_in user
      get edit_spot_path(new_spot)
    end

    it "リクエストが成功する事" do
      expect(response).to have_http_status(200)
    end

    it "編集前のデータが表示されている事" do
      expect(response.body).to include new_spot.name
      expect(response.body).to include new_spot.escription
      expect(response.body).to include new_spot.address
    end
  end

  describe "PATCH #update" do
    before do
      sign_in user
    end

    context "パラメーターが正常な場合" do
      let!(:spot_params) { attributes_for(:spot, name: "other") }

      it "リクエストが成功する事" do
        patch spot_path(new_spot), params: { spot: spot_params }
        expect(response).to have_http_status(302)
      end

      it "nameが更新される事" do
        expect {
          patch spot_path(new_spot), params: { spot: spot_params }
        }.to change { new_spot.reload.name }.from("テスト投稿").to("other")
      end
    end

    context "パラメーターが異常な場合" do
      let(:invalid_spot_params) { attributes_for(:spot, :invalid) }

      it "リクエストが成功する事" do
        patch spot_path(new_spot), params: { spot: invalid_spot_params }
        expect(response).to have_http_status(200)
      end

      it "nameが更新されない事" do
        expect {
          patch spot_path(new_spot), params: { spot: invalid_spot_params }
        }.not_to change(new_spot.reload, :name)
      end

      it "エラーが表示される事" do
        patch spot_path(new_spot), params: { spot: invalid_spot_params }
        expect(response.body).to include "投稿の編集に失敗しました"
      end
    end
  end

  describe "delete #destroy" do
    before do
      sign_in user
    end

    it "リクエストが成功する事" do
      delete spot_path(new_spot)
      expect(response).to have_http_status(302)
    end

    it "投稿が削除されること" do
      expect do
        delete spot_path(new_spot)
      end.to change { spot.count }.by(-1)
    end

    it "リダイレクトに成功する事" do
      delete spot_path(new_spot)
      expect(response).to redirect_to root_path
    end
  end

  describe "GET #seasonal" do
    before do
      get seasonal_spots_path
    end

    it "リクエストが成功する事" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #search" do
    before do
      get search_spots_path
    end

    it "リクエストが成功する事" do
      expect(response).to have_http_status(200)
    end
  end
end
