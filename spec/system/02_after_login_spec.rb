require "rails_helper"

describe "[STEP2] ユーザログイン後のテスト", js: true do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:prefecture) { create(:prefecture) }
  let!(:city) { create(:city) }
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
end
