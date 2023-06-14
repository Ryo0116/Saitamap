require 'rails_helper'

RSpec.describe "Spots", type: :system do
  let!(:spot) { create(:spot, user: user) }
  let(:user) { create(:user) }
  let!(:like) { create(:like, user: user, spot: spot) }

  describe "掲示板一覧ページ" do
    before do
      visit spots_path
    end

    describe "表示テスト" do
      it "spotsテーブルのデータが正しく表示されている事" do
        expect(page).to have_content spot.name
        expect(page).to have_content spot.address
        expect(page).to have_content spot.description
        expect(page).to have_content spot.created_at.to_s(:datetime_jp)
        expect(page).to have_selector "img[src$='spot.test.png']"
      end

      it "usersテーブルのデータが正しく表示されている事" do
        expect(page).to have_content spot.user.name
        expect(page).to have_selector "img[src*='default_icon']"
      end

      it "likesテーブルのデータが正しく表示されている事" do
        expect(page).to have_content spot.likes.count
      end

      describe "ログイン前" do
        it "ヘッダーに「新規登録」「ログイン」が表示されている事" do
          within ".navbar" do
            expect(page).to have_content "ログイン"
            expect(page).to have_content "新規登録"
          end
        end
      end

      describe "ログイン後" do
        before do
          login(user)
        end

        it "ヘッダーに「スポット登録」「登録済みスポット一覧」「設定」「ログアウト」が表示されている事" do
          within ".navbar" do
            expect(page).to have_content "スポット登録"
            expect(page).to have_content "登録済みスポット一覧"
            expect(page).to have_content "設定"
            expect(page).to have_content "ログアウト"
          end
        end
      end
    end

    describe "ページ遷移テスト" do
      describe "ログイン前" do
        it "ヘッダーの「新規登録」をクリックすると新規登録ページに遷移する事" do
          within ".navbar" do
            click_on "新規登録"
          end
          expect(current_path).to eq new_user_registration_path
        end

        it "ヘッダーの「ログイン」をクリックするとログインページに遷移する事" do
          within ".navbar" do
            click_on "ログイン"
          end
          expect(current_path).to eq new_user_session_path
        end
      end

      describe "ログイン後" do
        before do
          login(user)
        end

        it "ヘッダーの「ホーム」をクリックすると掲示板一覧ページに遷移する事" do
          within ".navbar" do
            click_on "ホーム"
          end
          expect(current_path).to eq root_path
        end

        it "ヘッダーの「新規投稿」をクリックすると新規投稿ページに遷移する事" do
          within ".navbar" do
            click_on "新規投稿"
          end
          expect(current_path).to eq new_post_path
        end

        it "ヘッダーの「マイページ」をクリックするとユーザー詳細ページに遷移する事" do
          within ".navbar" do
            click_on "マイページ"
          end
          expect(current_path).to eq user_path(user)
        end

        it "ヘッダーの「ログアウト」をクリックすると掲示板一覧ページに遷移する事" do
          within ".navbar" do
            click_on "ログアウト"
          end
          expect(current_path).to eq root_path
        end

        it "投稿をクリックすると投稿詳細ページに遷移する事" do
          within ".posts-list" do
            click_on post.title
          end
          expect(current_path).to eq post_path(post)
        end
      end
    end
  end

  describe "新規投稿ページ" do
    before do
      login(user)
      visit new_spot_path
    end

    describe "表示テスト" do
      it "投稿ボタンが「登録」という表記になっている事" do
        expect(page).to have_button "登録"
      end
    end

    describe "遷移テスト" do
      context "フォーム入力値が正常" do
        it "新規投稿に成功する事" do
          fill_in "spot_name", with: "test_name"
          fill_in "spot_address", with: "test_address"
          fill_in "spot.description", with: "test_description"
          attach_file "spot[image]", "#{Rails.root}/spec/factories/post.test.png"
          click_on "登録"
          expect(current_path).to eq spots_path
          expect(page).to have_content "新規投稿に成功しました"
        end
      end

      context "タイトルが未入力" do
        it "新規投稿に失敗する事" do
          fill_in "spot_name", with: "test_name"
          fill_in "spot_address", with: "test_address"
          fill_in "spot.description", with: "test_description"
          attach_file "spot[image]", "#{Rails.root}/spec/factories/post.test.png"
          click_on "登録"
          expect(current_path).to eq spots_path
          expect(page).to have_content "新規投稿に失敗しました"
          expect(page).to have_content "タイトルを入力してください"
        end
      end
    end
  end

  describe "投稿詳細ページ" do
    describe "表示テスト" do
      it "spotsテーブルのデータが正しく表示されている事" do
        login(user)
        visit spot_path(spot)
        expect(page).to have_content spot.name
        expect(page).to have_content spot.address
        expect(page).to have_content spot.description
        expect(page).to have_content spot.created_at.to_s(:datetime_jp)
        expect(page).to have_selector "img[src$='spot.test.png']"
      end

      it "「♡」をクリックするといいね数が変化し「❤︎」に切り替わること" do
        login(user)
        visit spot_path(spot)
        find(".like-create").click
        expect(page).to have_content "❤︎"
        expect(page).not_to have_content "♡"
        expect(spot.likes.count).to eq(1)
      end

      describe "ユーザー表示テスト" do
        describe "ユーザー画像未登録の場合" do
          it "投稿したユーザーの情報が正しく表示されている事" do
            login(user)
            visit post_path(post)
            expect(page).to have_content spot.user.name
            expect(page).to have_selector "img[src*='default_icon']"
          end
        end

        describe "ユーザーが画像登録済みの場合" do
          let!(:post) { create(:post, user: user_with_image) }
          let(:user_with_image) { create(:user, :with_image) }

          it "投稿したユーザーの情報が正しく表示されている事" do
            login(user_with_image)
            visit post_path(post)
            expect(page).to have_content spot.user.name
            expect(page).to have_selector "img[src$='test.jpg']"
          end
        end
      end
    end

    describe "遷移テスト" do
      it "編集をクリックすると投稿編集ページに遷移する事" do
        login(user)
        visit spot_path(spoy)
        click_on "編集"
        expect(current_path).to eq edit_spot_path(spot)
      end
    end
  end

  describe "投稿編集ページ" do
    before do
      login(user)
      visit edit_spot_path(spot)
    end

    describe "表示テスト" do
      it "投稿ボタンが「編集」という表記になっている事" do
        expect(page).to have_button "編集"
      end
    end

    describe "遷移テスト" do
      let(:another_user_spot) { create(:spot) }

      context "フォーム入力値が正常" do
        it "投稿編集に成功する事" do
          fill_in "spot_name", with: "test_name"
          fill_in "spot_address", with: "test_address"
          fill_in "spot.description", with: "test_description"
          attach_file "spot[image]", "#{Rails.root}/spec/factories/post.test.png"
          click_on "更新"
          expect(current_path).to eq spot_path(spot)
          expect(page).to have_content "投稿を更新しました"
        end
      end

      context "タイトルが未入力" do
        it "投稿編集に失敗する事" do
          fill_in "spot_name", with: "test_name"
          fill_in "spot_address", with: "test_address"
          fill_in "spot.description", with: "test_description"
          attach_file "spot[image]", "#{Rails.root}/spec/factories/post.test.png"
          click_on "更新"
          expect(current_path).to eq "/spots/#{spot.id}"
          expect(page).to have_content "投稿の編集に失敗しました"
          expect(page).to have_content "タイトルを入力してください"
        end
      end

      it "投稿作成者以外が編集しようとするとトップページに戻される事" do
        visit edit_spot_path(another_user_spot)
        expect(current_path).to eq root_path
        expect(page).to have_content "他のユーザーの投稿は編集できません"
      end
    end
  end

  describe "投稿削除テスト" do
    before do
      login(user)
    end

    it "「削除」をクリックすると投稿が削除される事" do
      visit spot_path(spot)
      expect do
        click_on "削除"
      end.to change { Spot.count }.by(-1)
      expect(current_path).to eq spots_path
      expect(page).to have_content "投稿を削除しました"
    end
  end

  describe "遷移テスト" do
    it "詳細をクリックすると詳細に遷移する事" do
      click_on spot_path(spot.id)
      expect(current_path).to eq spot_path(spot/id)
    end
  end

  describe "投稿検索機能テスト" do
    let!(:another_post) { create(:post, title: "検索機能表示テスト", content: "検索機能表示テスト", user: user) }

    before do
      login(user)
      root_path
    end

    describe "表示テスト" do
      it "検索した内容を含む投稿を表示する事" do
        fill_in "q[content_cont]", with: "検索機能"
        click_on "検索"
        expect(page).to have_content another_post.title
      end

      it "検索した内容を含まない投稿を表示しない事" do
        fill_in "q[content_cont]", with: "検索機能"
        click_on "検索"
        expect(page).not_to have_content post.title
      end
    end

    describe "遷移テスト" do
      it "詳細をクリックすると詳細に遷移する事" do
        click_on spot_path(spot.id)
        expect(current_path).to eq spot_path(spot/id)
      end
    end
  end
end
