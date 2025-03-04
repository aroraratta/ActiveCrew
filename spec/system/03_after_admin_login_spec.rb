require "rails_helper"

describe "[STEP2] 管理者ログイン後のテスト", js: true do
  let(:admin) { create(:admin) }
  let(:user) { create(:user, name: "ユーザー") }
  let!(:other_user) { create(:user, name: "ユーザー2") }
  let!(:prefecture) { create(:prefecture, prefecture_name: "テスト県") }
  let!(:prefecture2) { create(:prefecture, prefecture_name: "テスト県2") }
  let!(:city) { create(:city, city_name: "テスト市", prefecture: prefecture) }
  let!(:city2) { create(:city, city_name: "テスト市2", prefecture: prefecture2) }
  let!(:circle) { create(:circle, circle_name: "テストサークル", prefecture: prefecture, city: city, owner: user) }
  let!(:circle2) { create(:circle, circle_name: "テストサークル2", prefecture: prefecture, city: city, owner: other_user) }
  let!(:circle_user) { create(:circle_user, circle: circle, user: user) }
  let!(:circle_user2) { create(:circle_user, circle: circle2, user: other_user) }
  let(:circle_user3) { create(:circle_user, circle: circle, user: other_user) }
  let!(:post) { create(:post, body: "投稿", user: user, circle: circle) }
  let!(:post2) { create(:post, body: "投稿2", user: other_user, circle: circle2) }
  let(:room) { create(:room) }
  let(:entry) { create(:entry, room: room, user: user) }
  let(:other_entry) { create(:entry, room: room, user: other_user) }
  let(:relationship) { create(:relationship, follower: user, followed: other_user) }
  let(:event) { create(:event, event_title: "テストイベント", circle: circle, start: Time.current + 1.hour, end: Time.current + 2.hour) }

  before do
    visit new_admin_session_path
    fill_in "admin[email]", with: admin.email
    fill_in "admin[password]", with: admin.password
    click_button "ログイン"
  end

  describe "ユーザー管理のテスト" do
    before do
      visit admin_user_path(user)
    end
    it "ユーザーの詳細画面でユーザー編集ボタンを押下すると編集フォームが表示される" do
      click_button "ユーザー編集"
      expect(page).to have_css("label[for='image_input']")
      expect(page).to have_selector("label[for='is_active_true']", text: '有効')
      expect(page).to have_selector("label[for='is_active_false']", text: '退会')
      expect(page).to have_field "user[email]"
      expect(page).to have_field "user[name]"
      expect(page).to have_field "user[introduction]"
    end
    it "ユーザー情報を正しく修正できる" do
      click_button "ユーザー編集"
      fill_in "user[name]", with: "編集されたユーザー名"
      fill_in "user[introduction]", with: "編集された紹介文"
      click_button "保存"
      expect(page).to have_content "編集されたユーザー名"
      expect(page).to have_content "編集された紹介文"
    end
    it "ユーザーを論理削除することができる" do
      click_button "ユーザー編集"
      choose "退会"
      click_button "保存"
      visit admin_user_path(user)
      expect(page).to have_content "退会ユーザー"
    end
  end

  describe "投稿管理のテスト" do
    before do
      visit admin_post_path(post)
    end
    context "投稿編集フォームのテスト" do
      it "投稿の詳細画面で投稿編集ボタンを押下すると編集フォームが表示される" do
        click_button "投稿編集"
        expect(page).to have_field "post[body]"
        expect(page).to have_css("label[for='image_input']")
        expect(page).to have_select("post[circle_id]", options: [circle.circle_name])
      end
      # it "ファイルを選択したらプレビューが表示される" do
      #   attach_file("post[post_image]", Rails.root.join("spec/images/logo.png"), visible: false)
      #   expect(page).to have_css("#img_prev[src*='data:image']")
      # end
    end

    context "投稿編集フォームのテスト" do
      it "入力フォームを未入力で編集ボタンを押下するとエラーが表示される" do
        click_button "投稿編集"
        fill_in "post[body]", with: ""
        click_button "保存"
        expect(page).to have_content "件のエラーが発生しました。"
      end
      it "投稿の詳細画面で投稿削除ボタンを押下すると投稿が削除される" do
        old_post_count = Post.count
        accept_confirm "本当に消しますか？" do
          click_link("削除", href: admin_post_path(post))
        end
        page.refresh
        expect(Post.count).to eq(old_post_count - 1)
      end
      # it "投稿の削除後、フラッシュメッセージが表示される" do
      #   accept_confirm "本当に消しますか？" do
      #     click_link("削除", href: admin_post_path(post))
      #   end
      #   expect(page).to have_content "投稿を削除しました"
      # end
    end
  end
  
  describe "サークルのテスト" do
    context "サークル編集成功のテスト" do
      before do
        visit admin_circle_path(circle)
        click_button "編集"
      end
      it "ファイルを選択したらプレビューが表示される" do
        attach_file("circle[circle_image]", Rails.root.join("spec/images/background.png"), visible: false)
        expect(page).to have_css("#img_prev[src*='data:image']")
      end
      before do
        fill_in "circle[circle_name]", with:"aaaaaaaaaa"
        fill_in "circle[circle_introduction]", with:"bbbbbbbbbb"
        select "テスト県2", from: "circle_prefecture_id"
        select "テスト市2", from: "circle_city_id"
        attach_file("circle[circle_image]", Rails.root.join("spec/images/background.png"), visible: false)
        click_button "変更を保存"
      end
      it "編集内容が正常に保存されている" do
        expect(page).to have_content "aaaaaaaaaa"
        expect(page).to have_content "bbbbbbbbbb"
        expect(page).to have_content "テスト県2"
        expect(page).to have_content "テスト市2"
        expect(page).to have_css("img[src*='background.png']")
      end
      it "編集成功時にフラッシュメッセージが表示される" do
        expect(page).to have_content "サークルを編集しました"
      end
    end

    context "サークル編集失敗のテスト" do
      before do
        visit admin_circle_path(circle)
        click_button "編集"
        fill_in "circle[circle_name]", with:""
        click_button "変更を保存"
      end
      it "エラーメッセージが表示される" do
        expect(page).to have_content "件のエラーが発生しました。"
      end
    end

    context "サークル削除のテスト" do
      before do
        visit admin_circle_path(circle)
        accept_confirm "本当に消しますか?" do
          click_link "削除"
        end
      end
      it "サークルの削除後、フラッシュメッセージが表示される" do
        expect(page).to have_content "サークルを削除しました"
      end
    end
  end
end

# bundle exec rspec spec/system/03_after_admin_login_spec.rb:XXX --format documentation
