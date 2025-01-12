require "rails_helper"

describe "[STEP2] ユーザログイン後のテスト" do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  
  context 'ユーザログアウト成功のテスト' do
    it 'ログアウト後にフラッシュメッセージが表示される', js: true do
      find('.menu-trigger').click
      click_link "ログアウト"
      expect(page).to have_content 'ログアウトしました。'
    end
  end

  context 'ユーザ退会成功のテスト' do
    it '退会後にフラッシュメッセージが表示される' do
      visit unsubscribe_path
      click_link '退会する'
      expect(page).to have_content '退会処理を実行しました'
    end
  end
end
