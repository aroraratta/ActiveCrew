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
end

# bundle exec rspec spec/system/03_after_admin_login_spec.rb:XXX --format documentation
