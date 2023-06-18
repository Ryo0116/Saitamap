require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:spot) { create(:spot_address) }
  let!(:like) { create(:like, spot: spot, user: user) }

  describe "バリデーション" do
    it "1つの投稿に複数のいいねができない事" do
      another_like = build(:like, spot: spot, user: user)
      another_like.valid?
      expect(another_like.errors.full_messages).to include "すでにいいねしてします"
    end
  end
end