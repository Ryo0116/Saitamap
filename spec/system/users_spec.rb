require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:user_with_image) { create(:user, :with_image) }
  let!(:spot) { create(:spot, user: user) }
  let!(:like) { create(:like, spot: spot, user: another_user) }

  describe "ログイン前" do
    describe "アカウント新規登録" do
      context "フォームの入力値が正常" do
        it "ユーザー新規作成が成功する事" do
          visit new_user_registration_path
          fill_in "user[name]", with: "Example User"
          fill_in "user[email]", with: "user@example.com"
          fill_in "user[password]", with: "password"
          fill_in "user[password_confirmation]", with: "password"
          click_on "アカウント登録"
          expect(current_path).to eq root_path
          expect(page).to have_content "アカウント登録が完了しました"
        end
      end

      context "メールアドレスが未入力" do
        it "ユーザー新規作成が失敗する事" do
          visit new_user_registration_path
          fill_in "user[name]", with: "Example User"
          fill_in "user[email]", with: nil
          fill_in "user[password]", with: "password"
          fill_in "user[password_confirmation]", with: "password"
          click_on "アカウント登録"
          expect(current_path).to eq "/users"
          expect(page).to have_content "メールアドレスを入力してください"
        end
      end
    end

    describe "ログイン" do
      context "フォームの入力値が正常" do
        it "ログインが成功する事" do
          login(user)
          expect(current_path).to eq root_path
          expect(page).to have_content "ログインに成功しました"
        end
      end

      context "メールアドレス未入力" do
        it "ログインが失敗する事" do
          visit new_user_session_path
          within ".form-signin" do
            fill_in "user[email]", with: nil
            fill_in "user[password]", with: user.password
            click_on "ログイン"
          end
          expect(current_path).to eq new_user_session_path
          expect(page).to have_content "またはパスワードが違います"
        end
      end
    end
  end

  describe "ログイン後" do
    describe "ユーザー編集" do
      it "ユーザー編集に成功する事" do
        login(user)
        visit edit_user_path(user)
        fill_in "user[name]", with: "test_edit_user"
        fill_in "user[email]", with: "test_edit_user@example.com"
        attach_file "user[image_name]", "#{Rails.root}/spec/factories/test.jpg"
        click_on "更新する"
        expect(current_path).to eq user_path(user)
        expect(page).to have_content "ユーザー情報を編集しました。"
        expect(page).to have_selector "img[src$='test.jpg']"
      end
    end

    describe "パスワード編集" do
      it "パスワードの変更に成功する事" do
        login(user)
        visit edit_user_registration_path
        fill_in "user[password]", with: "test_password"
        fill_in "user[password_confirmation]", with: "test_password"
        fill_in "user[current_password]", with: user.password
        click_on "更新する"
        expect(current_path).to eq user_path(user)
        expect(page).to have_content "パスワードを変更しました。"
      end
    end

    describe "ログアウト機能" do
      it "ログアウトに成功する事" do
        login(user)
        click_on "ログアウト"
        expect(current_path).to eq root_path
        expect(page).to have_content "ログアウトに成功しました"
      end
    end

    describe "表示テスト" do
      describe "マイページ" do
        context "アイコン画像未登録の場合" do
          it "ユーザー情報が正しく表示されている事" do
            login(user)
            visit user_path(user)
            expect(page).to have_content user.name
            expect(page).to have_content user.email
            expect(page).to have_selector "img[src*='default_icon']"
          end
        end

        context "アイコン画像登録済みの場合" do
          it "ユーザー情報が正しく表示されている事" do
            login(user_with_image)
            visit user_path(user_with_image)
            expect(page).to have_content user_with_image.name
            expect(page).to have_content user_with_image.email
            expect(page).to have_selector "img[src$='test.jpg']"
          end
        end

        it "投稿数といいね数が正しく表示されている事" do
          login(user)
          visit user_path(user)
          expect(page).to have_content user.spots.count
          expect(page).to have_content user.likes.count
        end

        describe "一覧表示テスト" do
          context "投稿といいねした投稿がある場合" do
            it "「投稿一覧」をクリックすると自分の投稿が表示される事" do
              login(user)
              visit user_path(user)
              find(".posts-index-button").click
              expect(page).to have_content spot.name
              expect(page).to have_content spot.address
              expect(page).to have_content spot.created_at.to_s(:datetime_jp)
              expect(page).to have_selector "img[src$='post.test.png']"
            end

            it "「いいね一覧」をクリックするといいねをした投稿の一覧が表示される事" do
              login(another_user)
              visit user_path(another_user)
              find(".likes-index-button").click
              expect(page).to have_content spot.name
              expect(page).to have_content spot.address
              expect(page).to have_content spot.created_at.to_s(:datetime_jp)
              expect(page).to have_selector "img[src$='post.test.png']"
            end
          end

          context "投稿がない場合" do
            it "投稿がない場合「投稿一覧」をクリックすると「現在投稿はありません」と表示される事" do
              login(another_user)
              visit user_path(another_user)
              expect(page).to have_content "現在投稿はありません"
            end

            it "いいねした投稿がない場合「いいね一覧」をクリックすると「現在いいねをした投稿はありません」と表示される事" do
              login(user)
              visit user_path(user)
              expect(page).to have_content "現在いいねをした投稿はありません"
            end
          end
        end
      end
    end
  end

  describe "ページ遷移テスト" do
    it "「ログインする」をクリックすると、ログインページに遷移する事" do
      visit new_user_registration_path
      click_on "ログインする"
      expect(current_path).to eq new_user_session_path
    end

    it "「新規登録する」をクリックすると、新規登録ページに遷移する事" do
      visit new_user_session_path
      click_on "新規登録する"
      expect(current_path).to eq new_user_registration_path
    end

    it "パスワード設定は「こちら」をクリックすると、パスワード編集ページに遷移する" do
      login(user)
      visit edit_user_path(user)
      click_on "こちら"
      expect(current_path).to eq edit_user_registration_path
    end

    it "プロフィールの変更は「こちら」をクリックすると、ユーザー編集ページに遷移する" do
      login(user)
      visit edit_user_registration_path
      click_on "こちら"
      expect(current_path).to eq edit_user_path(user)
    end

    it "マイページの投稿一覧の投稿をクリックすると詳細ページへと遷移する事" do
      login(user)
      visit user_path(user)
      find(".spots-index-button").click
      click_on spot.title
      expect(current_path).to eq spot_path(spot)
    end

    it "マイページのいいね一覧の投稿をクリックすると投稿詳細ページへと遷移する事" do
      login(another_user)
      visit user_path(another_user)
      find(".likes-index-button").click
      click_on spot.name
      expect(current_path).to eq spot_path(spot)
    end
  end
end