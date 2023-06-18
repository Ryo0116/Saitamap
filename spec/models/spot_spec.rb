require 'rails_helper'

RSpec.describe Spot, type: :model do
  let!(:user) { create(:user) }

  describe "バリデーション" do
    describe "投稿成功" do
      it "タイトル、投稿内容、追加料金、カスタマイズレベル、画像があれば有効な事" do
        spot = build(:spot)
        expect(spot).to be_valid
      end
    end

    describe "投稿失敗" do
      it "タイトルがなければ無効である事" do
        spot = build(:spot, name: nil)
        spot.valid?
        expect(spot.errors[:name]).to include "を入力してください"
      end

      it "投稿内容がなければ無効である事" do
        spot = build(:spot, description: nil)
        spot.valid?
        expect(spot.errors[:description]).to include "を入力してください"
      end

      it "住所がなければ無効である事" do
        spot = build(:spot, address: nil)
        spot.valid?
        expect(spot.errors[:address]).to include "を入力してください"
      end

      it "画像がなければ無効である事" do
        spot = build(:spot, image_name: nil)
        spot.valid?
        expect(spot.errors[:image_name]).to include "を入力してください"
      end
    end
  end
end
