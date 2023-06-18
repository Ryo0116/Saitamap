require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    describe "登録成功" do
      it "名前、メールアドレス、パスワードがある場合、有効である事" do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    describe "登録失敗" do
      it "名前がない場合無効である事" do
        user = build(:user, name: nil)
        user.valid?
        expect(user.errors[:name]).to include "を入力してください"
      end

      it "名前が21文字以上の場合無効である事" do
        user = build(:user, name: "error_data_for_testing")
        user.valid?
        expect(user.errors[:name]).to include "は20文字以内で入力してください"
      end

      it "メールアドレスがない場合無効である事" do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include "を入力してください"
      end

      it "メールアドレスが重複している場合無効である事" do
        user = create(:user)
        user2 = build(:user, email: user.email)
        user2.valid?
        expect(user2.errors[:email]).to include "はすでに存在します"
      end

      it "メールアドレスが51文字以上の場合無効である事" do
        user = build(:user, email: ("test" * 12 + "@.com"))
        user.valid?
        expect(user.errors[:email]).to include "は50文字以内で入力してください"
      end

      it "メールアドレスが正しい形式でない場合無効である事" do
        user = build(:user, email: "test@test")
        user.valid?
        expect(user.errors[:email]).to include "が有効ではありません"
      end

      it "パスワードがない場合無効であるこ事" do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors[:password]).to include "を入力してください"
      end

      it "パスワードが5文字以内の場合無効である事" do
        user = build(:user, password: "test")
        user.valid?
        expect(user.errors[:password]).to include "は6文字以上で入力してください"
      end

      it "確認用パスワードがパスワードと異なる値の場合無効である事" do
        user = build(:user, password_confirmation: "testuser2")
        user.valid?
        expect(user.errors[:password_confirmation]).to include "とパスワードの入力が一致しません"
      end
    end
  end
end
