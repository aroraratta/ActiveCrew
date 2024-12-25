# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.find_or_create_by!(email: ENV["ADMIN_EMAIL"]) do |admin|
  admin.password = ENV["ADMIN_PASSWORD"]
end

kanagawa = User.find_or_create_by!(email: "kanagawa@example.com") do |user|
  user.name = "神奈川太郎"
  user.password = ENV["USER_PASSWORD"]
  user.introduction = "神奈川太郎です。バドミントンとサイクリングが大好きです!気軽にDMしてください。"
  user.user_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/user1_cycling.jpg"), filename:"user1_cycling.jpg")
end

ehime = User.find_or_create_by!(email: "ehime@example.com") do |user|
  user.name = "愛媛花子"
  user.password = ENV["USER_PASSWORD"]
  user.introduction = "愛媛花子です。趣味はダンスとサイクリングです!cycling仲間を増やしたいので気軽にDMしてください。"
  user.user_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/user2_dance.jpg"), filename:"user2_dance.jpg")
end

tokyo = User.find_or_create_by!(email: "tokyo@example.com") do |user|
  user.name = "東京太郎"
  user.password = ENV["USER_PASSWORD"]
  user.introduction = "東京太郎です。一緒に野球をしてくれる人がいたら気軽にDMしてください!一緒に楽しみましょう!"
  user.user_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/user3_baseball.jpg"), filename:"user3_baseball.jpg")
end

kagawa = User.find_or_create_by!(email: "kagawa@example.com") do |user|
  user.name = "香川花子"
  user.password = ENV["USER_PASSWORD"]
  user.introduction = "香川花子です。テニスサークルを探しています。いい雰囲気のサークルがあれば入りたいです。おすすめのサークルがあれば紹介していただきたいです!ビリヤードも趣味でやっています!"
  user.user_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/user4_tennis.jpg"), filename:"user4_tennis.jpg")
end

hoge = User.find_or_create_by!(email: "hoge@example.com") do |user|
  user.name = "hoge"
  user.password = ENV["USER_PASSWORD"]
  user.introduction = "削除ユーザーのテスト用データです。"
  user.is_active = false
end

puts "ユーザーデータ作成完了"

kanagawa.followings << ehime
kanagawa.followings << tokyo
kanagawa.followings << kagawa

ehime.followings << kanagawa
ehime.followings << kagawa
ehime.followings << tokyo

tokyo.followings << kanagawa

kagawa.followings << ehime
kagawa.followings << tokyo

puts "フォローデータ作成完了"

# サークル活動場所選択肢(いつでも更新できるように日本郵便からデータ取得できるように記述)
require "csv"
require "zip"
require "open-uri"
require "cgi"

PREF_CITY_URL = "http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip"
SAVEDIR = "db/"
CSVROW_PREFNAME = 6
CSVROW_CITYNAME = 7
save_path = ""

URI.open(PREF_CITY_URL) do |file|
  ::Zip::File.open_buffer(file.read) do |zf|
    zf.each do |entry|
      save_path = File.join(SAVEDIR, entry.name)
      zf.extract(entry, save_path) { true }
    end
  end
end

CSV.foreach(save_path, encoding: "Shift_JIS:UTF-8") do |row|
  pref_name = row[CSVROW_PREFNAME]
  city_name = row[CSVROW_CITYNAME]
  pref = Prefecture.find_or_create_by(prefecture_name: pref_name)
  City.find_or_create_by(city_name: city_name, prefecture_id: pref.id)
end

File.unlink save_path

puts "サークル活動場所選択肢作成完了"

badminton = Circle.find_or_create_by!(circle_name: "バドミントンサークル") do |circle|
  circle.prefecture_id = 14
  circle.city_id = 717
  circle.owner_id = 1
  circle.circle_introduction = "こんにちわ!バドミントンサークルです。毎週土曜日の19:00~21:30まで活動しています!まずは見学からでも参加可能なので、気になる方は管理者までDMをお願いします!"
end

kanagawa_cycling = Circle.find_or_create_by!(circle_name: "サイクリング好きの集い") do |circle|
  circle.circle_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/post_bike.jpg"), filename:"post-bike.jpg")
  circle.prefecture_id = 14
  circle.city_id = 717
  circle.owner_id = 1
  circle.circle_introduction = "サイクリング好きよ、集まれ!本気の人も趣味程度の人も気軽に参加してください!毎週日曜日の13:00~18:00まで神奈川県や東京あたりを走っています!たくさんの参加者待っています!"
end

ehime_cycling = Circle.find_or_create_by!(circle_name: "愛媛サイクリング") do |circle|
  circle.circle_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/post_sunset.jpg"), filename:"post-sunset.jpg")
  circle.prefecture_id = 38
  circle.city_id = 1548
  circle.owner_id = 2
  circle.circle_introduction = "一緒にしまなみ海道をサイクリングしませんか!半年に1回程度の活動ですが、誰でも楽しめるような活動を心がけています!参加希望者はDMをください!"
end

training = Circle.find_or_create_by!(circle_name: "オンライントレーニング部") do |circle|
  circle.circle_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/post_tennis.jpg"), filename:"post-tennis.jpg")
  circle.prefecture_id = 13
  circle.city_id = 673
  circle.owner_id = 3
  circle.circle_introduction = "全国どこにいても参加可能!トレーニングの記録を投稿して切磋琢磨しよう!たくさんの参加待っています!"
end

puts "サークル作成完了"

kanagawa.circles << badminton
kanagawa.circles << kanagawa_cycling
kanagawa.circles << training

ehime.circles << ehime_cycling
ehime.circles << training

tokyo.circles << kanagawa_cycling

kagawa.circles << badminton
kagawa.circles << training

puts "サークル参加データ作成完了"

Post.find_or_create_by!(body: "本日のトレーニングメニュー:腕立て伏せ100回") do |post|
  post.user = kanagawa
  post.circle_id = 4
end

Post.find_or_create_by!(body: "スカイツリーまでサイクリングに行ってきました。夜だと車すくなくて走りやすいですが、安全第一で走りました!") do |post|
  post.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/post_bike.jpg"), filename:"post-bike.jpg")
  post.user = kanagawa
  post.circle_id = 2
end

Post.find_or_create_by!(body: "今日はバドミントンサークルのみんなでバーベキューしてきました!とても楽しかったです~!") do |post|
  post.user = kanagawa
  post.circle_id = 1
end

Post.find_or_create_by!(body: "バドの練習開始します!") do |post|
  post.user = kanagawa
  post.circle_id = 1
end

Post.find_or_create_by!(body: "明日も練習頑張るぞ") do |post|
  post.user = kanagawa
end

Post.find_or_create_by!(body: "サイクリングロードを走っています!いい天気なので気持ちよく走ることができます~") do |post|
  post.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/post_bridge.jpg"), filename:"post_bridge.jpg")
  post.user = ehime
  post.circle_id = 3
end

Post.find_or_create_by!(body: "ダンスのレッスン疲れた...明日も頑張ります") do |post|
  post.user = ehime
end

Post.find_or_create_by!(body: "12/10 ランニングで体力作り!今日は10km走りました!") do |post|
  post.user = tokyo
  post.circle_id = 4
end

Post.find_or_create_by!(body: "12/11 ランニングで体力作り!今日は12km走りました!") do |post|
  post.user = tokyo
  post.circle_id = 4
end

Post.find_or_create_by!(body: "12/12 ランニングで体力作り!今日は11km走りました!") do |post|
  post.user = tokyo
  post.circle_id = 4
end

Post.find_or_create_by!(body: "今日はサークルのトレーニングに参加しました!海辺のトレーニングです!") do |post|
  post.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/post_sea.jpg"), filename:"post_sea.jpg")
  post.user = ehime
  post.circle_id = 4
end

Post.find_or_create_by!(body: "ビリヤードの練習です。") do |post|
  post.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/post_billiards.jpg"), filename:"post_billiards.jpg")
  post.user = kagawa
end

Post.find_or_create_by!(body: "練習後のうどんおいしい") do |post|
  post.user = kagawa
end

Post.find_or_create_by!(body: "hogeの投稿") do |post|
  post.user = hoge
end

puts "投稿データ作成完了"

PostComment.find_or_create_by!(comment: "素晴らしい!良いトレーニングです") do |post_comment|
  post_comment.user = tokyo
  post_comment.post_id = 1
end

PostComment.find_or_create_by!(comment: "めっちゃ楽しかった!また行こう") do |post_comment|
  post_comment.user = tokyo
  post_comment.post_id = 2
end

PostComment.find_or_create_by!(comment: "大満足です") do |post_comment|
  post_comment.user = tokyo
  post_comment.post_id = 3
end

PostComment.find_or_create_by!(comment: "次回も期待しています!") do |post_comment|
  post_comment.user = ehime
  post_comment.post_id = 3
end

PostComment.find_or_create_by!(comment: "ビリヤードいいね!今度一緒にやりましょう") do |post_comment|
  post_comment.user = ehime
  post_comment.post_id = 11
end