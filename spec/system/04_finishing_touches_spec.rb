require "rails_helper"

describe "[STEP3] 仕上げのテスト" do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe "サクセスメッセージのテスト" do
    subject { page }

    it "ユーザ新規登録成功時" do
      visit new_user_registration_path
      fill_in "user[name]", with: Faker::Lorem.characters(number: 9)
      fill_in "user[email]", with: "a" + user.email # 確実にuser, other_userと違う文字列にするため
      fill_in "user[password]", with: "password"
      fill_in "user[password_confirmation]", with: "password"
      click_button "登録"
      is_expected.to have_content "アカウント登録が完了しました。"
    end
    it 'ユーザログイン成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      is_expected.to have_content 'ログインしました。'
    end
    it 'ユーザログアウト成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      find('.menu-trigger').click
      click_link "ログアウト"
      is_expected.to have_content 'ログアウトしました。'
    end
    it 'ユーザ退会成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      visit unsubscribe_path
      click_link '退会する'
      is_expected.to have_content '退会処理を実行しました'
    end
  end
end
