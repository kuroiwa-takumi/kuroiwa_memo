## 概要
- GMOグループさんが挙げていた記事：[新人研修でマスターするDBのパフォーマンスチューニング](https://recruit.gmo.jp/engineer/jisedai/blog/mysql-index-training/)がとても良かったので、自分もやってみようと思ったのがきっかけ
- 今回は記事になっているTODOアプリケーションのDBのパフォーマンスチューニングを行ってみる。
  - テーブル構成等も載せていただいているのでとても助かる・・・

## 検証環境
- macOS Sonoma 14.0.0
- MySQL 8.0.26
- dockerでMySQLを起動する

## テーブルを作成する
- まずは、記事にあるDB、テーブルを作成する
  - dockerでMySQLを起動して、テーブルを作成する方針とする。

### docker-compose.yaml
```yaml
version: '3.1'

services:
  db:
    image: mysql:8.0.26
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root1234 # ここにrootユーザーのパスワードを設定
      MYSQL_DATABASE: mydatabase  # オプション: 初期データベースの作成
      MYSQL_USER: user            # オプション: 新しいユーザーの作成
      MYSQL_PASSWORD: password    # 上記ユーザーのパスワード
    ports:
      - "3306:3306" # ホストのポートをコンテナのポートにマッピング
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      - my_db:/var/lib/mysql

volumes:
  my_db:
```


