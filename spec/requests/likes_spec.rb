require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:spot_new) { create(:spot, user: user) }
  let(:like) { create(:like, user: user, spot: spot_new) }

  before do
    sign_in user
  end

  describe "SPOT /#create" do
    it "データの保存に成功する事" do
      expect do
        spot spot_likes_path(spot_new.id), xhr: true
      end.to change { like.count }.by(1)
    end
  end

  describe "DELETE #destroy" do
    let!(:like) { create(:like, user: user, spot: spot_new) }

    it "データの保存に成功する事" do
      expect do
        delete spot_likes_path(spot_new.id), xhr: true
      end.to change { like.count }.by(-1)
    end
  end
end

