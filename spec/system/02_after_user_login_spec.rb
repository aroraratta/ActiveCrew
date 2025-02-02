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
  let(:circle_user3) { create(:circle_user, circle: circle, user: other_user) }
  let!(:post) { create(:post, body: "投稿", user: user, circle: circle) }
  let!(:post2) { create(:post, body: "投稿2", user: other_user, circle: circle2) }
  let(:room) { create(:room) }
  let(:entry) { create(:entry, room: room, user: user) }
  let(:other_entry) { create(:entry, room: room, user: other_user) }
  let(:relationship) { create(:relationship, follower: user, followed: other_user) }
  let(:event) { create(:event, event_title: "テストイベント", circle: circle, start: Time.current + 1.hour, end: Time.current + 2.hour) }

  before do
    visit new_user_session_path
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    click_button "ログイン"
  end
  
  describe "deviseのテスト" do
    context "ユーザログアウト成功のテスト" do
      it "ログアウト後にフラッシュメッセージが表示される" do
        find(".menu-trigger").click
        click_link "ログアウト"
        expect(page).to have_content "ログアウトしました。"
      end
    end

    context "ユーザ退会成功のテスト" do
      it "退会後にフラッシュメッセージが表示される" do
        visit unsubscribe_path
        click_link "退会する"
        expect(page).to have_content "退会処理を実行しました"
      end
    end
  end

  describe "ユーザーのテスト" do
    before do
      visit mypage_path
    end
    context "ユーザ編集成功のテスト" do
      before do
        @user_old_name = user.name
        @user_old_email = user.email
        @user_old_intrpduction = user.introduction
        click_button "編集"
      end
      it "マイページの編集リンクを押下すると編集フォームが出現する" do
        expect(page).to have_css("label[for='image_input']")
        expect(page).to have_field "user[email]"
        expect(page).to have_field "user[name]"
        expect(page).to have_field "user[introduction]"
      end
      # it "ユーザ編集後にフラッシュメッセージが表示され、正しく更新される" do
      #   attach_file("user[user_image]", Rails.root.join("spec/images/logo.png"), visible: false)
      #   fill_in "user[email]", with: "b" + user.email # 確実にuser, other_userと違う文字列にするため
      #   fill_in "user[name]", with: Faker::Lorem.characters(number: 9)
      #   fill_in "user[introduction]", with: Faker::Lorem.characters(number: 9)
      #   click_button "保存"
      #   expect(page).to have_content "ユーザー情報を更新しました"
      #   expect(user.reload.user_image).to be_attached
      #   expect(user.reload.name).not_to eq @user_old_name
      #   expect(user.reload.email).not_to eq @user_old_email
      #   expect(user.reload.introduction).not_to eq @user_old_introduction
      # end
    end
  end

  describe "投稿のテスト" do
    context "新規投稿フォームのテスト" do
      before do
        find("#openPostModalButton").click
      end
      it "新規投稿ボタンを押下するとフォームが表示される" do
        expect(page).to have_field "post[body]"
        expect(page).to have_css("label[for='post_image_input']")
        expect(page).to have_select("post[circle_id]")
        expect(page).to have_button "投稿"
      end
      it "自分の所属しているサークルの選択肢が選択できる" do
        expect(page).to have_select("post[circle_id]", with_options: ["サークルを選択", "テストサークル"])
        expect(page).not_to have_select("post[circle_id]", with_options: ["テストサークル2"])
      end
      it "ファイルを選択したらプレビューが表示される" do
        attach_file("post[post_image]", Rails.root.join("spec/images/logo.png"), visible: false)
        expect(page).to have_css("#post_img_prev[src*='data:image']")
      end
    end
    # context "投稿成功のテスト" do
    #   before do
    #     find("#openPostModalButton").click
    #     fill_in "post[body]", with: Faker::Lorem.characters(number: 20)
    #     click_button "投稿"
    #   end
    #   it "投稿後に投稿詳細ページに遷移する" do
    #     expect(page).to have_current_path"/posts/2"
    #   end
    #   it "投稿後にフラッシュメッセージが表示される" do
    #     expect(page).to have_content "投稿しました"
    #   end
    # end
    
    context "投稿失敗のテスト" do
      before do
        find("#openPostModalButton").click
      end
      it "投稿失敗時にエラーメッセージが出力される" do
        click_button "投稿"
        expect(page).to have_content "件のエラーが発生しました。"
      end
    end

    context "投稿編集成功のテスト" do
      before do
        visit "/posts/1"
      end
      it "編集ボタンを押下すると編集フォームが表示される" do
        click_button "投稿編集"
        expect(page).to have_field "post[body]"
        expect(page).to have_css("label[for='post_image_input']")
        expect(page).to have_select("post[circle_id]", options: [circle.circle_name])
      end
    end
    
    context "投稿編集失敗のテスト" do
      before do
        visit "/posts/1"
        click_button "投稿編集"
        fill_in "post[body]", with: ""
        click_button "保存"
      end
      it "入力フォームを未入力で編集ボタンを押下するとエラーが表示される" do
        expect(page).to have_content "件のエラーが発生しました。"
      end
    end
    
    context "投稿削除のテスト" do
      before do
        visit "/posts/1"
        accept_confirm "本当に消しますか？" do
          click_link "削除"
        end
      end
      it "投稿の削除後、フラッシュメッセージが表示される" do
        expect(page).to have_content "投稿を削除しました"
      end
    end
  end

  describe "サークルのテスト" do
    context "サークル作成フォームのテスト" do
      before do
        find("#openCircleModalButton").click
      end
      it "サークル作成ボタンを押下するとフォームが表示される" do
        expect(page).to have_css("label[for='circle_image_input']")
        expect(page).to have_field "circle[circle_name]"
        expect(page).to have_field "circle[circle_introduction]"
        expect(page).to have_select("circle_prefecture_id")
        expect(page).to have_select("circle_city_id")
        expect(page).to have_button "作成"
      end
      it "選択した件によって市の選択肢が変わる" do
        expect(page).to have_select("circle_prefecture_id", with_options: ["県を選択", "テスト県"])
        select "テスト県", from: "circle_prefecture_id"
        expect(page).to have_select("circle_city_id", with_options: ["市を選択", "テスト市"])
        expect(page).not_to have_select("circle_city_id", with_options: ["テスト市2"])
      end
      it "ファイルを選択したらプレビューが表示される" do
        attach_file("circle[circle_image]", Rails.root.join("spec/images/logo.png"), visible: false)
        expect(page).to have_css("#circle_img_prev[src*='data:image']")
      end
    end
    # context "サークル作成成功のテスト" do
    #   before do
    #     visit root_path
    #     find("#openCircleModalButton").click
    #     fill_in "circle[circle_name]", with: Faker::Lorem.characters(number: 10)
    #     fill_in "circle[circle_introduction]", with: Faker::Lorem.characters(number: 10)
    #     select "テスト県", from: "circle_prefecture_id"
    #     select "テスト市", from: "circle_city_id"
    #     attach_file("circle[circle_image]", Rails.root.join("spec/images/logo.png"), visible: false)
    #   end
    #   it "サークルが正しく保存され、サークル詳細画面へ遷移する" do
    #     expect {
    #       click_button "作成"
    #       expect(page).to have_current_path "/circles/3"
    #     }.to change { Circle.count }.by(1)
    #   end
    #   it "サークル作成後、フラッシュメッセージが表示される" do
    #     click_button "作成"
    #     expect(ActiveStorage::Blob.count).to eq(1)
    #     expect(page).to have_content "サークルを作成しました"
    #   end
    # end

    context "サークル作成失敗のテスト" do
      before do
        visit root_path
        find("#openCircleModalButton").click
        click_button "作成"
      end
      it "サークル作成失敗後、エラーメッセージが表示される" do
        expect(page).to have_content "件のエラーが発生しました。"
      end
    end

    context "サークル編集成功のテスト" do
      before do
        visit "/circles/1"
        click_button "編集"
      end
      it "ファイルを選択したらプレビューが表示される" do
        attach_file("circle[circle_image]", Rails.root.join("spec/images/background.png"), visible: false)
        expect(page).to have_css("#circle_img_prev[src*='data:image']")
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
        visit "/circles/1"
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
        visit "/circles/1"
        accept_confirm "本当に消しますか?" do
          click_link "削除"
        end
      end
      it "サークルの削除後、フラッシュメッセージが表示される" do
        expect(page).to have_content "サークルを削除しました"
      end
    end
  end

  describe "検索のテスト" do
    before do
      visit top_path
    end
    context "検索フォームのテスト" do
      it "検索フォームが表示されている" do
        expect(page).to have_selector("input.custom-form[type='text'][name='word'][id='word']")
        expect(page).to have_selector("input#range_circle[type='radio'][name='[range]'][value='circle']")
        expect(find("#range_circle")).to be_checked
        expect(page).to have_selector("input#range_post[type='radio'][name='[range]'][value='post']")
        expect(find("#range_post")).not_to be_checked
        expect(page).to have_selector("input#range_user[type='radio'][name='[range]'][value='user']")
        expect(find("#range_user")).not_to be_checked
        expect(page).to have_selector("input#search_partial_match[type='radio'][name='search'][value='partial_match']")
        expect(find("#search_partial_match")).to be_checked
        expect(page).to have_selector("input#search_perfect_match[type='radio'][name='search'][value='perfect_match']")
        expect(find("#search_perfect_match")).not_to be_checked
        expect(page).to have_selector("input#search_forward_match[type='radio'][name='search'][value='forward_match']")
        expect(find("#search_forward_match")).not_to be_checked
      end
      it "サークル検索時に活動場所選択フォームが出現し、県を選択すると動的に市が変化する" do
        choose("range_circle")
        expect(page).to have_select("circle_prefecture_id", with_options: ["県を選択", "テスト県", "テスト県2"])
        select "テスト県", from: "circle_prefecture_id"
        expect(page).to have_select("circle_city_id", with_options: ["市を選択", "テスト市"])
        expect(page).not_to have_select("circle_city_id", with_options: ["テスト市2"])
      end
      it "投稿検索時に活動場所選択フォームが出現しない" do
        choose("range_post")
        expect(page).not_to have_select("circle_prefecture_id", with_options: ["県を選択", "テスト県", "テスト県2"])
        expect(page).not_to have_select("circle_city_id", with_options: ["市を選択"])
      end
      it "ユーザー検索時に活動場所選択フォームが出現しない" do
        choose("range_user")
        expect(page).not_to have_select("circle_prefecture_id", with_options: ["県を選択", "テスト県", "テスト県2"])
        expect(page).not_to have_select("circle_city_id", with_options: ["市を選択"])
      end

      context "部分一致検索のテスト" do
        it "サークルの部分一致検索ができる" do
          fill_in "word", with: "スト"
          click_button(class: "btn-custom-blue")
          expect(page).to have_content "サークル 検索結果"
          expect(page).to have_content "テストサークル"
          expect(page).to have_content "テストサークル2"
        end
        it "投稿の部分一致検索ができる" do
          choose("range_post")
          fill_in "word", with: "稿"
          click_button(class: "btn-custom-blue")
          expect(page).to have_content "投稿 検索結果"
          expect(page).to have_content "投稿"
          expect(page).to have_content "投稿2"
        end
        it "ユーザーの部分一致検索ができる" do
          choose("range_user")
          fill_in "word", with: "ザー"
          click_button(class: "btn-custom-blue")
          expect(page).to have_content "ユーザー 検索結果"
          expect(page).to have_content "ユーザー"
          expect(page).to have_content "ユーザー2"
        end
      end

      context "完全一致検索のテスト" do
        before do
          choose("search_perfect_match")
        end
        it "サークルの完全一致検索ができる" do
          fill_in "word", with: "テストサークル"
          click_button(class: "btn-custom-blue")
          expect(page).to have_content "サークル 検索結果"
          expect(page).to have_content "テストサークル"
          expect(page).not_to have_content "テストサークル2"
        end
        it "投稿の完全一致検索ができる" do
          choose("range_post")
          fill_in "word", with: "投稿"
          click_button(class: "btn-custom-blue")
          expect(page).to have_content "投稿 検索結果"
          expect(page).to have_content "投稿"
          expect(page).not_to have_content "投稿2"
        end
        it "ユーザーの完全一致検索ができる" do
          choose("range_user")
          fill_in "word", with: "ユ―ザー"
          click_button(class: "btn-custom-blue")
          expect(page).to have_content "ユーザー 検索結果"
          expect(page).to have_content "ユーザー"
          expect(page).not_to have_content "ユーザー2"
        end
      end
      
      context "前方一致検索のテスト" do
        before do
          choose("search_forward_match")
        end
        it "サークルの前方一致検索ができる" do
          fill_in "word", with: "テスト"
          click_button(class: "btn-custom-blue")
          expect(page).to have_content "サークル 検索結果"
          expect(page).to have_content "テストサークル"
          expect(page).to have_content "テストサークル2"
        end
        it "投稿の前方一致検索ができる" do
          choose("range_post")
          fill_in "word", with: "投稿"
          click_button(class: "btn-custom-blue")
          expect(page).to have_content "投稿 検索結果"
          expect(page).to have_content "投稿"
          expect(page).to have_content "投稿2"
        end
        it "ユーザーの前方一致検索ができる" do
          choose("range_user")
          fill_in "word", with: "ユーザー"
          click_button(class: "btn-custom-blue")
          expect(page).to have_content "ユーザー 検索結果"
          expect(page).to have_content "ユーザー"
          expect(page).to have_content "ユーザー2"
        end
      end
    end
  end
  
  describe "DMのテスト" do
    context "DMルーム作成のテスト" do
      before do
        visit user_path(other_user)
      end
      it "DM開始ボタンを押下するとルームが作成される" do
        expect {click_button "DM開始"}.to change { Room.count }.by(1)
      end
      it "DMルーム作成作成後、DMルームへ遷移する" do
        click_button "DM開始"
        room = Room.last
        expect(page).to have_current_path room_path(room)
      end
      it "DM開始ボタンを押下するとDMルームへのリンクへボタンが変化する" do
        click_button "DM開始"
        visit user_path(other_user)
        expect(page).to have_link "DM"
      end
      it "DMルーム作成作成後、マイページにDMへのリンクが表示される" do
        click_button "DM開始"
        fill_in "message[message]", with: "テストメッセージ"
        click_button "送信"
        visit mypage_path
        click_link "DM一覧"
        room = Room.last
        expect(page).to have_link(href: room_path(room))
        expect(page).to have_content "テストメッセージ"
      end
    end

    context "DM送受信のテスト" do
      before do
        room
        entry
        other_entry
        visit room_path(room)
        fill_in "message[message]", with: "テストメッセージ"
        click_button "送信"
      end
      it "自身が送信したメッセージが表示される" do
        expect(page).to have_css(".send-message", text: "テストメッセージ")
      end
      it "相手から送信されたメッセージが表示される" do
        sign_out user
        sign_in other_user
        visit room_path(room)
        expect(page).to have_css(".sent-message", text: "テストメッセージ")
      end
    end
  end

  describe "フォローのテスト" do
    context "ユーザーフォロー時のフォローユーザーページのテスト" do
      before do
        visit user_path(other_user)
      end
      it "フォローボタンを押下するとフォローできる" do
        expect { click_link "フォロー" }.to change { other_user.followers.count }.by(1)
      end
      it "フォローするとフォロー解除ボタンへ変化する" do
        click_link "フォロー" 
        expect(page).to have_content "フォロー解除"
      end
      it "フォロー解除ボタンを押下するとフォロー解除できる" do
        click_link "フォロー" 
        expect { click_link "フォロー解除" }.to change { other_user.followers.count }.by(-1)
      end
    end

    context "ユーザーフォロー時のマイページのテスト" do
      before do
        relationship
        visit mypage_path
      end
      it "マイページのフォロー数にフォロー一覧へのリンクを持ったフォローユーザー数が表示される" do
        expect(page).to have_link(user.followings.count.to_s, href: user_followings_path(user))
      end
      it "マイページのフォローユーザー投稿にフォロー相手の投稿が表示される" do
        click_link "フォローユーザー投稿"
        expect(page).to have_content("投稿2")
      end
    end
    
    context "ユーザーフォロー時のフォロー一覧ページのテスト" do
      before do
        relationship
        visit user_followings_path(user)
      end
      it "一覧ページにフォローユーザーが表示されている" do
        expect(page).to have_link(href: user_path(other_user))
      end
      it "一覧ページにフォロー解除ボタンが表示されている" do
        expect(page).to have_link(href: user_relationships_path(other_user))
      end
      it "一覧ページのフォロー解除ボタンを押下するとフォロー解除できる" do
        expect { click_link "フォロー解除" }.to change { other_user.followers.count }.by(-1)
      end
    end
  end

  describe "フォロワーのテスト" do
    before do
      relationship
      sign_out user
      sign_in other_user
      visit user_path(other_user)
    end
    context "フォローされた時のマイページのテスト" do
      it "フォローされたユーザーページのフォロワー数にフォロワー一覧へのリンクを持ったフォローユーザー数が表示される" do
        expect(page).to have_link(other_user.followers.count.to_s, href: user_followers_path(other_user))
      end
    end

    context "フォローされた時のフォロワー一覧ページのテスト" do
      before do
        visit user_followers_path(other_user)
      end
      it "一覧ページにフォロワーユーザーが表示されている" do
        expect(page).to have_link(href: user_path(other_user))
        expect(page).to have_link "フォロー"
      end
      it "フォローボタンを押下するとフォローできる" do
        expect { click_link "フォロー" }.to change { other_user.followings.count }.by(1)
      end
      it "フォローするとフォロー解除ボタンへ変化する" do
        click_link "フォロー" 
        expect(page).to have_content "フォロー解除"
      end
      it "フォロー解除ボタンを押下するとフォロー解除できる" do
        click_link "フォロー" 
        expect { click_link "フォロー解除" }.to change { other_user.followings.count }.by(-1)
      end
    end
  end
  
  describe "サークル参加のテスト" do
    before do
      visit circle_path(circle2)
    end
    context "参加申請のテスト" do
      it "参加申請を押下すると参加申請できる" do
        expect { click_link "参加申請" }.to change { Permit.count }.by(1)
      end
      it "参加申請を押下すると申請取り消しボタンに変化する" do
        click_link "参加申請" 
        expect(page).to have_link "申請取消"
      end
      it "参加申請を押下すると申請取り消しボタンに変化する" do
        click_link "参加申請" 
        expect { click_link "申請取消" }.to change { Permit.count }.by(-1)
      end
    end

    context "管理サークルの参加許可のテスト" do
      before do
        click_link "参加申請" 
        sign_out user
        sign_in other_user
        visit circle_path(circle2)
      end
      it "参加申請者が表示されている" do
        expect(page).to have_link(href: user_path(user))
      end
      it "参加許可ボタン、参加拒否ボタンが表示されている" do
        expect(page).to have_link("参加許可", href: circle_circle_users_path(circle2, permit_id: Permit.last))
        expect(page).to have_link("参加拒否", href: circle_permit_path(circle2, id: Permit.last))
      end
      it "参加許可ボタンを押下するとサークルに参加させられる" do
        expect { click_link "参加許可" }.to change { CircleUser.count }.by(1)
      end
      it "参加拒否ボタンを押下するとサークル参加申請を拒否できる" do
        expect { click_link "参加拒否" }.to change { Permit.count }.by(-1)
      end
    end
  
    context "サークル参加者数のテスト" do
      before do
        circle_user3
        visit circle_path(circle)
      end
      it "サークル詳細に参加者一覧のリンクを持った参加申請者が表示されている" do
        expect(page).to have_link(circle.users.count.to_s, href: circle_circle_users_path(circle))
      end
      it "参加者一覧にすべての参加申請者が表示されている" do
        visit circle_circle_users_path(circle)
        expect(page).to have_link(href: user_path(user))
        expect(page).to have_link(href: user_path(other_user))
      end
    end

    context "サークル退出のテスト" do
      before do
        circle_user3
        old_circle_user_count = circle.users.count
      end
      it "サークル管理者は参加者一覧に退出ボタンが表示されている" do
        visit circle_circle_users_path(circle)
        expect(page).to have_link "退出"
      end
      it "サークル管理者以外は参加者一覧に退出ボタンが表示されない" do
        sign_out user
        sign_in other_user
        visit circle_circle_users_path(circle)
        expect(page).not_to have_link "退出"
      end
      it "参加者一覧の退出ボタンを押下するとそのユーザーが退出される" do
        visit circle_circle_users_path(circle)
        old_circle_user_count = circle.users.count
        accept_confirm "ユーザーを退出させますか?" do
          click_link "退出"
        end
        visit current_path
        expect(circle.users.count).to eq(old_circle_user_count - 1)
      end
      it "参加サークルの退出ボタンを押下すると退出できる" do
        sign_out user
        sign_in other_user
        visit circle_path(circle)
        old_circle_user_count = circle.users.count
        accept_confirm "サークルを退出しますか?" do
          click_link "退出"
        end
        visit circle_path(circle)
        expect(circle.users.count).to eq(old_circle_user_count - 1)
      end
    end
  end
  
  describe "イベント作成のテスト" do
    context "イベント作成ボタンのテスト" do
      before do
        visit circle_path(circle)
      end
      it "サークル管理者はイベント作成ボタンが表示される" do
        expect(page).to have_link(href: new_circle_event_path(circle))
      end
      it "イベント作成ボタンを押下するとイベント作成ページへ遷移する" do
        click_link(href: new_circle_event_path(circle))
        expect(current_path).to eq(new_circle_event_path(circle))
      end
      it "サークル管理者以外はイベント作成ボタンが表示されない" do
        circle_user3
        sign_out user
        sign_in other_user
        visit circle_path(circle)
        expect(page).not_to have_link(href: new_circle_event_path(circle))
      end
    end
  
    context "イベント作成のテスト" do
      before do
        visit new_circle_event_path(circle)
      end
      it "未入力で登録ボタンを押下するとエラーメッセージが表示される" do
        click_button "登録"
        expect(page).to have_content "件のエラーが発生しました。"
        expect(page).to have_content "タイトル を入力してください"
      end
      it "イベントが正常に保存され、フラッシュメッセージが表示される" do
        fill_in "event[event_title]", with: "テストイベント"
        fill_in "event_start", with: Time.current.change(sec: 0).strftime("%Y-%m-%dT%H:%M")
        fill_in "event_end", with: Time.current.change(sec: 0).strftime("%Y-%m-%dT%H:%M")
        expect {click_button "登録"}.to change { Event.count }.by(1)
        expect(page).to have_content "イベントを作成しました"
        expect(current_path).to eq(circle_path(circle))
      end
    end

    context "イベント参加のテスト" do
      before do
        visit circle_event_path(event, circle)
      end
      it "イベント詳細画面の参加するボタンを押下すると参加が保存される" do
        expect {click_link "参加する"}.to change { Attend.count }.by(1)
      end
      it "イベント詳細画面の参加中ボタンを押下すると参加が削除される" do
        click_link "参加する"
        expect {click_link "参加中"}.to change { Attend.count }.by(-1)
      end
    end

    context "イベント削除のテスト" do
      before do
        visit circle_event_path(circle, event)
      end
      it "サークル管理者はイベント詳細画面に削除ボタンが表示される" do
        expect(page).to have_link("削除", href: circle_event_path(circle, event))
      end
      it "削除ボタンを押下するとイベントが削除される" do
        @old_event_count = Event.count
        accept_confirm "本当に消しますか？" do
          click_link("削除", href: circle_event_path(circle, event))
        end
        visit circle_path(circle)
        expect(Event.count).to eq(@old_event_count - 1)
      end
      it "イベントを削除するとフラッシュメッセージが表示される" do
        accept_confirm "本当に消しますか？" do
          click_link("削除", href: circle_event_path(circle, event))
        end
        expect(page).to have_content "イベントを削除しました"
      end
      it "イベントを削除するとサークル詳細へ遷移する" do
        accept_confirm "本当に消しますか？" do
          click_link("削除", href: circle_event_path(circle, event))
        end
        expect(current_path).to eq(circle_path(circle))
      end
      it "サークル管理者以外はイベント詳細画面に削除ボタンが表示されない" do
        sign_out user
        sign_in other_user
        visit circle_event_path(circle, event)
        expect(page).not_to have_link("削除", href: circle_event_path(circle, event))
      end
    end
  end
end

# bundle exec rspec spec/system/02_after_login_spec.rb:XXX --format documentation
