require "rails_helper"

describe "[STEP2] ユーザログイン後のテスト", js: true do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:prefecture) { create(:prefecture, prefecture_name: "テスト県") }
  let!(:prefecture2) { create(:prefecture, prefecture_name: "テスト県2") }
  let!(:city) { create(:city, city_name: "テスト市", prefecture: prefecture) }
  let!(:city2) { create(:city, city_name: "テスト市2", prefecture: prefecture2) }
  let!(:circle) { create(:circle, prefecture: prefecture, city: city, owner: user) }
  let!(:circle_user) { create(:circle_user, circle: circle, user: user) }
  let!(:post) { create(:post, user: user, circle: circle) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  
  describe "deviseのテスト" do
    context 'ユーザログアウト成功のテスト' do
      it 'ログアウト後にフラッシュメッセージが表示される' do
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

  describe "ユーザーのテスト" do
    before do
      visit mypage_path
    end
    context 'ユーザ編集成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_email = user.email
        @user_old_intrpduction = user.introduction
        click_button '編集'
      end
      it 'マイページの編集リンクを押下すると編集フォームが出現する' do
        expect(page).to have_css('label[for="image_input"]')
        expect(page).to have_field 'user[email]'
        expect(page).to have_field 'user[name]'
        expect(page).to have_field 'user[introduction]'
      end
      it 'ユーザ編集後にフラッシュメッセージが表示され、正しく更新される' do
        attach_file('image_input', Rails.root.join('spec/images/logo.png'), make_visible: true)
        fill_in 'user[email]', with: "b" + user.email # 確実にuser, other_userと違う文字列にするため
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 9)
        click_button '保存'
        expect(page).to have_content 'ユーザー情報を更新しました'
        expect(user.reload.user_image).to be_attached
        expect(user.reload.name).not_to eq @user_old_name
        expect(user.reload.email).not_to eq @user_old_email
        expect(user.reload.introduction).not_to eq @user_old_introduction
      end
    end
  end

  describe "投稿のテスト" do
    context '投稿成功のテスト' do
      before do
        find('#openPostModalButton').click
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
        click_button '投稿'
      end
      it '投稿後に投稿詳細ページに遷移する' do
        expect(page).to have_current_path"/posts/2"
      end
      it '投稿後にフラッシュメッセージが表示される' do
        expect(page).to have_content '投稿しました'
      end
    end
    
    context '投稿失敗のテスト' do
      before do
        find('#openPostModalButton').click
      end
      it '投稿失敗時にエラーメッセージが出力される' do
        click_button '投稿'
        expect(page).to have_content '件のエラーが発生しました。'
      end
    end

    context '投稿編集成功のテスト' do
      before do
        visit "/posts/1"
      end
      it '編集ボタンを押下すると編集フォームが表示される' do
        click_button '投稿編集'
        expect(page).to have_field 'post[body]'
        expect(page).to have_css('label[for="image_input"]')
        expect(page).to have_select('post[circle_id]', options: [circle.circle_name])
      end
    end
    
    context '投稿編集失敗のテスト' do
      before do
        visit "/posts/1"
        click_button '投稿編集'
        fill_in 'post[body]', with: ''
        click_button '保存'
      end
      it '入力フォームを未入力で編集ボタンを押下するとエラーが表示される' do
        expect(page).to have_content '件のエラーが発生しました。'
      end
    end
    
    context '投稿削除のテスト' do
      before do
        visit "/posts/1"
        accept_confirm "本当に消しますか？" do
          click_link '削除'
        end
      end
      it '投稿の削除後、フラッシュメッセージが表示される' do
        expect(page).to have_content '投稿を削除しました'
      end
    end
  end

  describe "サークルのテスト" do
    context 'サークル作成成功のテスト' do
      before do
        find('#openCircleModalButton').click
      end
      it 'サークル作成ボタンを押下するとフォームが表示される' do
        expect(page).to have_css('label[for="image_input"]')
        expect(page).to have_field 'circle[circle_name]'
        expect(page).to have_field 'circle[circle_introduction]'
        expect(page).to have_select('circle_prefecture_id')
        expect(page).to have_select('circle_city_id')
        expect(page).to have_button "作成"
      end
      it '選択した件によって市の選択肢が変わる' do
        expect(page).to have_select('circle_prefecture_id', with_options: ['県を選択', 'テスト県'])
        select 'テスト県', from: 'circle_prefecture_id'
        expect(page).to have_select('circle_city_id', with_options: ['市を選択', 'テスト市'])
        expect(page).not_to have_select('circle_city_id', with_options: ['テスト市2'])
        expect(page).to have_button "作成"
      end
    end
    context 'サークル作成成功のテスト' do
      before do
        visit root_path
        find('#openCircleModalButton').click
        fill_in 'circle[circle_name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'circle[circle_introduction]', with: Faker::Lorem.characters(number: 10)
        select "テスト県", from: "circle_prefecture_id"
        select "テスト市", from: "circle_city_id"
        attach_file('circle[circle_image]', Rails.root.join('spec/images/logo.png'), visible: false)
        click_button '作成'
      end
      it "サークル作成後、サークル詳細画面へ遷移する" do
        expect(page).to have_current_path"/circles/2"
      end
      it "サークル作成後、フラッシュメッセージが表示される" do
        expect(page).to have_content 'サークルを作成しましたaa'
      end
    end
  end
end

# bundle exec rspec spec/system/02_after_login_spec.rb:37 --format documentation