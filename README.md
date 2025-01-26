# ActiveCrew
## サイト概要
### サイトテーマ
スポーツのサークルを立ち上げて同志と共に活動を楽しんだり、日々の活動を投稿できるコミュニティサイト

![Image](https://github.com/user-attachments/assets/f1ee250f-a507-4d80-a646-761fea40b781)​

### テーマを選んだ理由
学生時代はバドミントン部に所属していましたが、社会人になると部活がなくなり、バドミントンをする機会がほとんどなくなってしまいました。<br>
そこで、同じようにスポーツを楽しみたい人たちが、自分でサークルや部活動を立ち上げたり、参加できるサービスがあれば便利だと感じました。<br>

現在、サークルメンバーを募集できるWEBサイトはいくつかありますが、メンバー募集の情報のみが掲載されており、どのような人が参加しているのか、<br>
サークルの雰囲気が伝わりにくいという問題があります。そこで、SNS機能を追加し、日々の活動内容を投稿できるようにしました。これにより、<br>
サークル参加者の投稿を通じてサークルの雰囲気を感じながら、どのサークルに参加するかを検討しやすくなり、利便性が向上すると考え、<br>
このテーマを選びました。
​
### ターゲットユーザ
* スポーツが趣味であるが、一緒にやってくれる人がおらず、サークルに所属したいと考えている人
* サークル内の雰囲気を感じながらサークルに加入したい人
* スポーツに特化したSNSを利用したい人
​
### 主な利用シーン
* 引っ越しなどをして近くにスポーツをしてくれる同志がいない時
* どんな雰囲気のサークルの雰囲気を知りたい時
* 日々の活動を投稿を通じて残したい時

## URL
ActiveCrew-alb-1737840770.ap-northeast-1.elb.amazonaws.com

## 機能一覧
* ユーザー登録、ログイン機能(devise)
* フォロー機能
* 投稿機能
  * 画像投稿(ActiveStorage)
* コメント機能
* サークル作成機能、参加リクエスト機能
* サークル活動日、活動内容管理機能(FullCalendar)
* DM機能
* 検索機能
* 人気サークル表示機能

## テスト
* RSpec
  * ログイン前テスト
  * ログイン後テスト

## 設計書
* ER図 (https://app.diagrams.net/#G1033CUkXHqAnIzeQ_nq3XNBLVO5A-9EHC#%7B%22pageId%22%3A%22vzjcXcgsg06S2VZX8npz%22%7D)
* UI Flows (https://app.diagrams.net/#G1033CUkXHqAnIzeQ_nq3XNBLVO5A-9EHC#%7B%22pageId%22%3A%22vzjcXcgsg06S2VZX8npz%22%7D)​
* インフラ設計書(https://app.diagrams.net/#G1iTF0KcVPeRmsga2lJv1m0t-Ee2OCkT01#%7B%22pageId%22%3A%22T6JmGLWKkRxPTz6StvwP%22%7D)

## 開発環境
- OS : Linux(Amazon Linux2)
- 言語 : HTML,CSS,JavaScript,Ruby,SQL
- フレームワーク：Ruby on Rails
- JSライブラリ : jQuery
- IDE : VScode
- AWS :  VPC, EC2, RDS, ALB
![Image](https://github.com/user-attachments/assets/ae5edc7b-1903-4c64-aa22-26bfda174fd4)