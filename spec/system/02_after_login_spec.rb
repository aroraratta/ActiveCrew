require "rails_helper"

describe "[STEP2] ユーザログイン後のテスト", js: true do
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
  let!(:post) { create(:post, body: "投稿", user: user, circle: circle) }
  let!(:post2) { create(:post, body: "投稿2", user: other_user, circle: circle2) }
  let(:room) { create(:room) }
  let(:entry) { create(:entry, room: room, user: user) }
  let(:other_entry) { create(:entry, room: room, user: other_user) }

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
      # it 'ユーザ編集後にフラッシュメッセージが表示され、正しく更新される' do
      #   attach_file('user[user_image]', Rails.root.join('spec/images/logo.png'), visible: false)
      #   fill_in 'user[email]', with: "b" + user.email # 確実にuser, other_userと違う文字列にするため
      #   fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
      #   fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 9)
      #   click_button '保存'
      #   expect(page).to have_content 'ユーザー情報を更新しました'
      #   expect(user.reload.user_image).to be_attached
      #   expect(user.reload.name).not_to eq @user_old_name
      #   expect(user.reload.email).not_to eq @user_old_email
      #   expect(user.reload.introduction).not_to eq @user_old_introduction
      # end
    end
  end

  describe "投稿のテスト" do
    context '新規投稿フォームのテスト' do
      before do
        find('#openPostModalButton').click
      end
      it '新規投稿ボタンを押下するとフォームが表示される' do
        expect(page).to have_field 'post[body]'
        expect(page).to have_css('label[for="post_image_input"]')
        expect(page).to have_select('post[circle_id]')
        expect(page).to have_button "投稿"
      end
      it '自分の所属しているサークルの選択肢が選択できる' do
        expect(page).to have_select('post[circle_id]', with_options: ['サークルを選択', 'テストサークル'])
        expect(page).not_to have_select('post[circle_id]', with_options: ['テストサークル2'])
      end
      it 'ファイルを選択したらプレビューが表示される' do
        attach_file('post[post_image]', Rails.root.join('spec/images/logo.png'), visible: false)
        expect(page).to have_css('#post_img_prev[src*="data:image"]')
      end
    end
    # context '投稿成功のテスト' do
    #   before do
    #     find('#openPostModalButton').click
    #     fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
    #     click_button '投稿'
    #   end
    #   it '投稿後に投稿詳細ページに遷移する' do
    #     expect(page).to have_current_path"/posts/2"
    #   end
    #   it '投稿後にフラッシュメッセージが表示される' do
    #     expect(page).to have_content '投稿しました'
    #   end
    # end
    
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
        expect(page).to have_css('label[for="post_image_input"]')
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
    context 'サークル作成フォームのテスト' do
      before do
        find('#openCircleModalButton').click
      end
      it 'サークル作成ボタンを押下するとフォームが表示される' do
        expect(page).to have_css('label[for="circle_image_input"]')
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
      end
      it 'ファイルを選択したらプレビューが表示される' do
        attach_file('circle[circle_image]', Rails.root.join('spec/images/logo.png'), visible: false)
        expect(page).to have_css('#circle_img_prev[src*="data:image"]')
      end
    end
    # context 'サークル作成成功のテスト' do
    #   before do
    #     visit root_path
    #     find('#openCircleModalButton').click
    #     fill_in 'circle[circle_name]', with: Faker::Lorem.characters(number: 10)
    #     fill_in 'circle[circle_introduction]', with: Faker::Lorem.characters(number: 10)
    #     select "テスト県", from: "circle_prefecture_id"
    #     select "テスト市", from: "circle_city_id"
    #     attach_file('circle[circle_image]', Rails.root.join('spec/images/logo.png'), visible: false)
    #   end
    #   it "サークルが正しく保存され、サークル詳細画面へ遷移する" do
    #     expect {
    #       click_button '作成'
    #       expect(page).to have_current_path "/circles/3"
    #     }.to change { Circle.count }.by(1)
    #   end
    #   it "サークル作成後、フラッシュメッセージが表示される" do
    #     click_button '作成'
    #     expect(ActiveStorage::Blob.count).to eq(1)
    #     expect(page).to have_content 'サークルを作成しました'
    #   end
    # end

    context 'サークル作成失敗のテスト' do
      before do
        visit root_path
        find('#openCircleModalButton').click
        click_button '作成'
      end
      it "サークル作成失敗後、エラーメッセージが表示される" do
        expect(page).to have_content '件のエラーが発生しました。'
      end
    end

    context 'サークル編集成功のテスト' do
      before do
        visit "/circles/1"
        click_button '編集'
      end
      it 'ファイルを選択したらプレビューが表示される' do
        attach_file('circle[circle_image]', Rails.root.join('spec/images/background.png'), visible: false)
        expect(page).to have_css('#circle_img_prev[src*="data:image"]')
      end
      before do
        fill_in 'circle[circle_name]', with:"aaaaaaaaaa"
        fill_in 'circle[circle_introduction]', with:"bbbbbbbbbb"
        select "テスト県2", from: "circle_prefecture_id"
        select "テスト市2", from: "circle_city_id"
        attach_file('circle[circle_image]', Rails.root.join('spec/images/background.png'), visible: false)
        click_button '変更を保存'
      end
      it "編集内容が正常に保存されている" do
        expect(page).to have_content 'aaaaaaaaaa'
        expect(page).to have_content 'bbbbbbbbbb'
        expect(page).to have_content 'テスト県2'
        expect(page).to have_content 'テスト市2'
        expect(page).to have_css("img[src*='background.png']")
      end
      it "編集成功時にフラッシュメッセージが表示される" do
        expect(page).to have_content 'サークルを編集しました'
      end
    end

    context 'サークル編集失敗のテスト' do
      before do
        visit "/circles/1"
        click_button '編集'
        fill_in 'circle[circle_name]', with:""
        click_button '変更を保存'
      end
      it "エラーメッセージが表示される" do
        expect(page).to have_content '件のエラーが発生しました。'
      end
    end

    context 'サークル削除のテスト' do
      before do
        visit "/circles/1"
        accept_confirm "本当に消しますか?" do
          click_link '削除'
        end
      end
      it 'サークルの削除後、フラッシュメッセージが表示される' do
        expect(page).to have_content 'サークルを削除しました'
      end
    end
  end

  describe "検索のテスト" do
    before do
      visit top_path
    end
    context '検索フォームのテスト' do
      it "検索フォームが表示されている" do
        expect(page).to have_selector('input.custom-form[type="text"][name="word"][id="word"]')
        expect(page).to have_selector('input#range_circle[type="radio"][name="[range]"][value="circle"]')
        expect(find('#range_circle')).to be_checked
        expect(page).to have_selector('input#range_post[type="radio"][name="[range]"][value="post"]')
        expect(find('#range_post')).not_to be_checked
        expect(page).to have_selector('input#range_user[type="radio"][name="[range]"][value="user"]')
        expect(find('#range_user')).not_to be_checked
        expect(page).to have_selector('input#search_partial_match[type="radio"][name="search"][value="partial_match"]')
        expect(find('#search_partial_match')).to be_checked
        expect(page).to have_selector('input#search_perfect_match[type="radio"][name="search"][value="perfect_match"]')
        expect(find('#search_perfect_match')).not_to be_checked
        expect(page).to have_selector('input#search_forward_match[type="radio"][name="search"][value="forward_match"]')
        expect(find('#search_forward_match')).not_to be_checked
      end
      it "サークル検索時に活動場所選択フォームが出現し、県を選択すると動的に市が変化する" do
        choose('range_circle')
        expect(page).to have_select('circle_prefecture_id', with_options: ['県を選択', 'テスト県', 'テスト県2'])
        select 'テスト県', from: 'circle_prefecture_id'
        expect(page).to have_select('circle_city_id', with_options: ['市を選択', 'テスト市'])
        expect(page).not_to have_select('circle_city_id', with_options: ['テスト市2'])
      end
      it "投稿検索時に活動場所選択フォームが出現しない" do
        choose('range_post')
        expect(page).not_to have_select('circle_prefecture_id', with_options: ['県を選択', 'テスト県', 'テスト県2'])
        expect(page).not_to have_select('circle_city_id', with_options: ['市を選択'])
      end
      it "ユーザー検索時に活動場所選択フォームが出現しない" do
        choose('range_user')
        expect(page).not_to have_select('circle_prefecture_id', with_options: ['県を選択', 'テスト県', 'テスト県2'])
        expect(page).not_to have_select('circle_city_id', with_options: ['市を選択'])
      end

      context '部分一致検索のテスト' do
        it "サークルの部分一致検索ができる" do
          fill_in 'word', with: 'スト'
          click_button(class: 'btn-custom-blue')
          expect(page).to have_content 'サークル 検索結果'
          expect(page).to have_content 'テストサークル'
          expect(page).to have_content 'テストサークル2'
        end
        it "投稿の部分一致検索ができる" do
          choose('range_post')
          fill_in 'word', with: '稿'
          click_button(class: 'btn-custom-blue')
          expect(page).to have_content '投稿 検索結果'
          expect(page).to have_content '投稿'
          expect(page).to have_content '投稿2'
        end
        it "ユーザーの部分一致検索ができる" do
          choose('range_user')
          fill_in 'word', with: 'ザー'
          click_button(class: 'btn-custom-blue')
          expect(page).to have_content 'ユーザー 検索結果'
          expect(page).to have_content 'ユーザー'
          expect(page).to have_content 'ユーザー2'
        end
      end

      context '完全一致検索のテスト' do
        before do
          choose('search_perfect_match')
        end
        it "サークルの完全一致検索ができる" do
          fill_in 'word', with: 'テストサークル'
          click_button(class: 'btn-custom-blue')
          expect(page).to have_content 'サークル 検索結果'
          expect(page).to have_content 'テストサークル'
          expect(page).not_to have_content 'テストサークル2'
        end
        it "投稿の完全一致検索ができる" do
          choose('range_post')
          fill_in 'word', with: '投稿'
          click_button(class: 'btn-custom-blue')
          expect(page).to have_content '投稿 検索結果'
          expect(page).to have_content '投稿'
          expect(page).not_to have_content '投稿2'
        end
        it "ユーザーの完全一致検索ができる" do
          choose('range_user')
          fill_in 'word', with: 'ユ―ザー'
          click_button(class: 'btn-custom-blue')
          expect(page).to have_content 'ユーザー 検索結果'
          expect(page).to have_content 'ユーザー'
          expect(page).not_to have_content 'ユーザー2'
        end
      end
      
      context '前方一致検索のテスト' do
        before do
          choose('search_forward_match')
        end
        it "サークルの前方一致検索ができる" do
          fill_in 'word', with: 'テスト'
          click_button(class: 'btn-custom-blue')
          expect(page).to have_content 'サークル 検索結果'
          expect(page).to have_content 'テストサークル'
          expect(page).to have_content 'テストサークル2'
        end
        it "投稿の前方一致検索ができる" do
          choose('range_post')
          fill_in 'word', with: '投稿'
          click_button(class: 'btn-custom-blue')
          expect(page).to have_content '投稿 検索結果'
          expect(page).to have_content '投稿'
          expect(page).to have_content '投稿2'
        end
        it "ユーザーの前方一致検索ができる" do
          choose('range_user')
          fill_in 'word', with: 'ユーザー'
          click_button(class: 'btn-custom-blue')
          expect(page).to have_content 'ユーザー 検索結果'
          expect(page).to have_content 'ユーザー'
          expect(page).to have_content 'ユーザー2'
        end
      end
    end
  end
  
  describe "DMのテスト" do
    context 'DMルーム作成のテスト' do
      before do
        visit user_path(other_user)
      end
      it "DM開始ボタンを押下するとルームが作成される" do
        expect {click_button 'DM開始'}.to change { Room.count }.by(1)
      end
      it "DMルーム作成作成後、DMルームへ遷移する" do
        click_button 'DM開始'
        room = Room.last
        expect(page).to have_current_path room_path(room)
      end
      it "DM開始ボタンを押下するとDMルームへのリンクへボタンが変化する" do
        click_button 'DM開始'
        visit user_path(other_user)
        expect(page).to have_link 'DM'
      end
      it "DMルーム作成作成後、マイページにDMへのリンクが表示される" do
        click_button 'DM開始'
        fill_in 'message[message]', with: 'テストメッセージ'
        click_button '送信'
        visit mypage_path
        click_link 'DM一覧'
        room = Room.last
        expect(page).to have_link(href: room_path(room))
        expect(page).to have_content 'テストメッセージ'
      end
    end

    context 'DM送受信のテスト' do
      before do
        room
        entry
        other_entry
        visit room_path(room)
        fill_in 'message[message]', with: 'テストメッセージ'
        click_button '送信'
      end
      it "自身が送信したメッセージが表示される" do
        expect(page).to have_css('.send-message', text: 'テストメッセージ')
      end
      it "相手から送信されたメッセージが表示される" do
        sign_out user
        sign_in other_user
        visit room_path(room)
        expect(page).to have_css('.sent-message', text: 'テストメッセージ')
      end
    end
  end
end

# テスト実行コードbundle exec rspec spec/system/02_after_login_spec.rb:XXX --format documentation
