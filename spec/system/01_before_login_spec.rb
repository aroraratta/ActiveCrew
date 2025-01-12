require "rails_helper"

describe "[STEP1] ユーザログイン前のテスト" do

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '名前フォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'メールフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it '確認用パスワードフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
      it 'ログインリンクが表示される' do
        expect(page).to have_link 'こちら', href: new_user_session_path
      end
    end
    
    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end
      it '正しく新規登録される' do
        expect { click_button '登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button '登録'
        expect(current_path).to eq '/mypage'
      end
      it '新規登録後にフラッシュメッセージが表示される' do
        click_button '登録'
        expect(page).to have_content 'アカウント登録が完了しました。'
      end
    end
    
    context '新規登録失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button '登録'
      end
      it '新規登録に失敗し、新規登録画面にリダイレクトされる' do
        expect(current_path).to eq '/users'
      end
      it '新規登録失敗後にエラーメッセージが表示される' do
        expect(page).to have_content '件のエラーが発生しました。'
        expect(page).to have_content 'メールアドレス を入力してください。'
        expect(page).to have_content 'パスワード を入力してください。'
        expect(page).to have_content '名前 を入力してください。'
      end
    end
  end

  describe 'ユーザログインのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it 'メールフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
      it '新規登録リンクが表示される' do
        expect(page).to have_link 'こちら', href: new_user_registration_path
      end
      it 'ゲストログインリンクが表示される' do
        expect(page).to have_link 'こちら', href: users_guest_sign_in_path
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end
      it 'ログイン後にフラッシュメッセージが表示される' do
        expect(page).to have_content 'ログインしました。'
      end
      it 'ログイン後のリダイレクト先が、ログインしたユーザのマイページになっている' do
        expect(current_path).to eq '/mypage'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end
      it 'ログイン失敗後にフラッシュメッセージが表示される' do
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end

    context 'ゲストログインのテスト' do
      before do
        visit new_user_session_path
        find('a[href="/users/guest_sign_in"]').click
      end
      it 'ゲストログイン後にフラッシュメッセージが表示される' do
        expect(page).to have_content 'ゲストユーザーでログインしました'
      end
    end
  end
end
