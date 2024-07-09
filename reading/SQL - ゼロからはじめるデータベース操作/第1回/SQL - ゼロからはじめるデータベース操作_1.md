## 概要
- 本記事は[SQL 第2版 ゼロからはじめるデータベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)で学んだ内容をまとめたものです。
  - エンジニア歴7年の私が、SQLを学び直すために本棚にあったこの本を読んでみたところ、SQLについてもう一度学び直したいと思い、一気に読み進めました
  - 以下記事では、実際にやってみた中で特に重要だと感じた内容をまとめています
  - 本書の内容をそのまま引用することは避け、自分の言葉でまとめています

※ 本のボリュームが多かったので、本記事ではまず「第0章：イントロダクション」と「第1章：データベースとSQL」に関連する内容をまとめています

## SQL学習環境を作る
- サンプルコードは以下のリンクからダウンロードできます
  - [SQL 第2版 ゼロからはじめるデータベース操作](https://www.shoeisha.co.jp/book/download/9784798144450/detail)の公式サイト
- 書籍の中ではWindows環境での学習環境構築が紹介されていますが、私はMacを使用しているため、Mac環境で学習環境を構築しました(`MySQLを使用`)
  - 以前自分が書いたブログの内容で作成できます　[検証用のDBコンテナを作成する](https://zenn.dev/t_kuroiwa/articles/041da5abee95b9)


## データベースとは何か
- 「**第1章：データベースとSQL**」にて、データベースの概要について詳しくまとめられていたので整理してみます

### データベースとは
- 大量の情報を保存し、コンピュータから効率良くアクセスできるように加工したデータの集まりのことを「データベース」と呼ぶ
- データベースを管理するコンピュータシステムのことを「データベース管理システム(`DBMS`)」と呼ぶ
  - DBMSはデータの追加、削除、更新、検索などの操作を行うための機能を提供する
  - 代表的なDBMSにはOracle Database、MySQL、PostgreSQL、SQLiteなどがある

- 本の中では`DB`と`DBMS`を明確に区別していました
  - **データベース**：保存されるデータの集まり
  - **データベース管理システム**：データベースを管理するためのシステム

### なぜDBMSを使うのか
- DBMSがなくてもテキストファイルやエクセルなどの表計算ソフトでデータを管理することもできそうだが、DBMSを使うメリットは以下の通り
  - **多人数での利用**：複数のユーザが同時にデータを操作できる
  - **大量のデータを効率的に処理**：データの追加、削除、更新、検索などの操作を効率的に行える
  - **プログラミングしなくてもデータ操作ができる**：SQLという言語を使ってデータ操作ができる
  - **万が一の障害に備えた機能**：データのバックアップや復旧機能がある

### データベースの構成
- DBMSの中でも、リレーショナルデータベース管理システム(RDBMS)が広く使われている
  - RDBMSはデータを表形式で管理する
  - Excelのような列と行からなる表形式でデータを管理する
  - SQL（Structured Query Language）という言語を使ってデータ操作を行う

- RDBMSにおける一般的なシステム構成に「C/S型」（クライアント/サーバ型）がある
  - **C/S型**：クライアントPCとサーバPCがネットワークで接続され、クライアントPCからサーバPCにアクセスしてデータを操作する

### RDBMSについて深堀り
- RDBMSはデータを表形式で管理する
  - 表形式でデータを管理するため、データの整合性を保つことができる
- 表のことを「**テーブル**」と呼ぶ
  - テーブルは行と列からなる
  - 行：レコード（データの1行）
  - 列：カラム（データの1列）
- 重要：行単位でデータを読み書きする

### SQLとは
- SQL（Structured Query Language）はデータベースに対して操作を行うための言語
  - SQLはデータの追加、削除、更新、検索などの操作を行う

### SQLの種類
- SQLには以下の種類がある
  - **DDL（Data Definition Language）**：データベースの構造を定義するための言語
    - CREATE、ALTER、DROPなど
  - **DML（Data Manipulation Language）**：データの操作を行うための言語
    - INSERT、UPDATE、DELETEなど
  - **DCL（Data Control Language）**：データの制御を行うための言語
    - GRANT、REVOKEなど
  - **TCL（Transaction Control Language）**：トランザクションの制御を行うための言語
    - COMMIT、ROLLBACKなど

### SQLの記述ルール
- SQLは大文字小文字を区別しない
- SQLはセミコロン（;）で文の終わりを示す
- 定数はシングルクォーテーション（'）で囲む
- コメントは「--」で始まる
- 単語と単語の間はスペースで区切る

### テーブルの作成・変更・削除
- 実際にデータベースを作成するチュートリアルが書かれているので作成してみます

- データベースの作成
```sql
mysql> create database shop;


mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sample_db          |
| shop               |
| sys                |
+--------------------+
6 rows in set (0.00 sec)
```

- テーブルの作成
  - 使用するデータベースを指定してからテーブルを作成します

```sql
mysql> use shop;
Database changed
mysql> CREATE TABLE Shohin
    -> (
    ->     shohin_id     CHAR(4)      NOT NULL,
    ->     shohin_mei    VARCHAR(100) NOT NULL,
    ->     shohin_bunrui VARCHAR(32)  NOT NULL,
    ->     hanbai_tanka  INTEGER,
    ->     shiire_tanka  INTEGER,
    ->     torokubi      DATE,
    ->     PRIMARY KEY (shohin_id)
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql> show tables;
+----------------+
| Tables_in_shop |
+----------------+
| Shohin         |
+----------------+
1 row in set (0.00 sec)
```

- テーブルの変更
  - テーブルの変更はALTER TABLE文を使います

```sql
-- shohin_kubunというカラムを追加
mysql> ALTER TABLE Shohin ADD COLUMN shohin_kubun CHAR(1) NOT NULL;
Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0

-- shohin_kubunを削除
mysql> ALTER TABLE Shohin DROP COLUMN shohin_kubun;
Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0
```

- データの登録
  - INSERT文を使ってデータを登録します

```sql
-- DML: Data Insertion
START TRANSACTION;
INSERT INTO Shohin VALUES ('0001', 'T-shirt', 'Clothing', 1000, 500, '2009-09-20');
INSERT INTO Shohin VALUES ('0002', 'Hole Punch', 'Office Supplies', 500, 320, '2009-09-11');
INSERT INTO Shohin VALUES ('0003', 'Dress Shirt', 'Clothing', 4000, 2800, NULL);
INSERT INTO Shohin VALUES ('0004', 'Kitchen Knife', 'Kitchen Supplies', 3000, 2800, '2009-09-20');
INSERT INTO Shohin VALUES ('0005', 'Pressure Cooker', 'Kitchen Supplies', 6800, 5000, '2009-01-15');
INSERT INTO Shohin VALUES ('0006', 'Fork', 'Kitchen Supplies', 500, NULL, '2009-09-20');
INSERT INTO Shohin VALUES ('0007', 'Grater', 'Kitchen Supplies', 880, 790, '2008-04-28');
INSERT INTO Shohin VALUES ('0008', 'Ballpoint Pen', 'Office Supplies', 100, NULL, '2009-11-11');
COMMIT;

Query OK, 0 rows affected (0.00 sec)

mysql> select * from Shohin;
+-----------+-----------------+------------------+--------------+--------------+------------+
| shohin_id | shohin_mei      | shohin_bunrui    | hanbai_tanka | shiire_tanka | torokubi   |
+-----------+-----------------+------------------+--------------+--------------+------------+
| 0001      | T-shirt         | Clothing         |         1000 |          500 | 2009-09-20 |
| 0002      | Hole Punch      | Office Supplies  |          500 |          320 | 2009-09-11 |
| 0003      | Dress Shirt     | Clothing         |         4000 |         2800 | NULL       |
| 0004      | Kitchen Knife   | Kitchen Supplies |         3000 |         2800 | 2009-09-20 |
| 0005      | Pressure Cooker | Kitchen Supplies |         6800 |         5000 | 2009-01-15 |
| 0006      | Fork            | Kitchen Supplies |          500 |         NULL | 2009-09-20 |
| 0007      | Grater          | Kitchen Supplies |          880 |          790 | 2008-04-28 |
| 0008      | Ballpoint Pen   | Office Supplies  |          100 |         NULL | 2009-11-11 |
+-----------+-----------------+------------------+--------------+--------------+------------+
8 rows in set (0.00 sec)
```
- テーブル名の変更
  - RENAME TABLE文を使ってテーブル名を変更します

```sql
mysql> RENAME TABLE Shoin TO Shohin;
```

### 命名ルール（大事）
- DBやテーブル、列などに使っていい文字は以下の通り
  - 半角英数字
  - アンダースコア（_）
  - **ダッシュ（-） やドット（.）は使わない**

### データ型について（大事）
- DBには色々なデータ型がある
  - 代表的なデータ型については以下

| データ型 | 説明                                                                                                         |
| ---- |------------------------------------------------------------------------------------------------------------|
| INTEGER | 整数型、小数は扱えない。範囲はDBMSによって異なる                                                                                 |
| CHAR(n) | 固定長文字列。文字列を入れる列に指定する文字列型。n文字分の領域を確保する。n文字未満の文字列を入れると、残りの領域はスペースで埋められる。</br>例）CHAR(4)の場合、'abc'を入れると'abc 'になる |
| VARCHAR(n) | 可変長文字列。文字列を入れる列に指定する文字列型。最大n文字分の領域を確保する。n文字未満の文字列を入れると、余分な領域は使われない</br>例）VARCHAR(4)の場合、'abc'を入れると'abc'になる|
| DATE | 日付型。年月日を扱う                                                                                                        |

### 制約
- テーブルには制約を設定することができる
  - `NOT NULL`：NULLを許可しない、必ず値を入れる
  - `主キー制約`：重複を許さない、一意な値を入れる 例：shohin_idを主キーに設定、shohin_idに重複する値を入れるとエラーになる
    - 1つの行を特定できることを「`ユニークに識別できる`」という

### まとめ
- 本記事では「**第0章：イントロダクション**」「**第1章：データベースとSQL**」で学んだ内容をまとめました
- 次回以降は「**第2章：データの検索**」についてまとめていきます

## 参考
- [SQL 第2版 ゼロからはじめるデーエベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)
