# Freedger

Freedgerは、冷蔵庫または冷凍庫にある食材や飲料の消費期限をチェックするアプリになります。

## :globe_with_meridians: APP URL
### **https://freedger-20200925075006.herokuapp.com/**


## :wrench: 使用方法

### 1:　コンテナを作成する :package:
はじめに冷蔵庫・冷凍庫の代わりとなる、コンテナを作りましょう。

### 2:　コンテナ内に食材や飲料を登録しよう :fork_and_knife:
作成したコンテナの中で食材や飲料の代わりとなるProductを登録しましょう。

### 3:　トップページでアラートをチェックしよう :heavy_check_mark:
トップページにあるボタンを押すことで、食材や飲料の消費期限を確認することができます。

消費期限から3日分猶予のあるものは **『_Recommend_』**、

消費期限当日のものは **『_Warning_』**、

消費期限がすでに切れているものは **『_Expired_』** で表示されます。

##### *　詳細な操作については、Freedger の About ページをご覧ください。

## :book: 実装している機能及びテスト

- レスポンシブWebデザイン
- ユーザー登録、ログイン機能(devise gem)
- Container と Product の作成及び編集、任意で写真も登録可(carrierwave gem, AWS-S3)
- Product の Expiration-date によって変化する Alerts の作成機能
- 各Container に Products がどれほど登録されているかがわかる棒グラフ、
- Alerts の合計数及び割合を確認できる、円グラフ　の表示(chartkick gem)
- Product と Alerts に対するページネーション機能(kaminari gem, ajax)
- Product の検索機能、検索機能の表示（jquery-ui-rails gem）
- Product のタグ作成、タグによる絞り込み機能(acts-as-taggable-on gem)
- 管理者用ページ(rails_admin gem)
- 表示された Alerts 一覧をpdfで出力できる機能(prawn gem)

- Rspec
    - Helpers: ヘルパーメソッドのテスト
    - Models: 各モデルのテスト
    - Requests: 各コントローラーのアクションの稼働テスト
    - System: ブラウザ上での統合テスト

- Rubocop

## :page_facing_up: 簡単な構成図
![Freedger_image](https://user-images.githubusercontent.com/62587962/94274623-da349f80-ff80-11ea-953b-67ab46ab62ff.png)

`git push` 時に Rspec と Rubocop が行われ、成功した場合にのみ Heroku にデプロイされる様になっています。
