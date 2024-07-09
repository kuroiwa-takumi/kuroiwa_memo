## 概要
- 本記事は[SQL 第2版 ゼロからはじめるデータベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)で学んだ内容をまとめたものです。
  - 前回は「**第0章：イントロダクション**」「**第1章：データベースとSQL**」で学んだ内容をまとめました：[SQL 第2版 ゼロからはじめるデータベース操作 アウトプット（第1回）](https://qiita.com/takumi_links/items/42f54fed377cbc266333)
  - 今回は「**第2章：検索の基本**」についてまとめていきます


## SELECT
### SELECT文とは
- SELECT文はデータベースからデータを取得するためのSQL文
  - SELECT文で必要なデータを検索し、取り出すこと：「問い合わせ」「クエリ（query）」と呼ぶ
- SELECT文の基本構文は以下
  - `SELECT 列名 FROM テーブル名;`
- SELECT, FROM: 句（clause）と呼ぶ
  - 句はSQL文の構成要素のこと
  - 句はキーワードで始まり、キーワードの後に続く情報を指定する

```sql
mysql> SELECT shohin_id, shohin_mei, shiire_tanka FROM Shohin;
+-----------+-----------------+--------------+
| shohin_id | shohin_mei      | shiire_tanka |
+-----------+-----------------+--------------+
| 0001      | T-shirt         |          500 |
| 0002      | Hole Punch      |          320 |
| 0003      | Dress Shirt     |         2800 |
| 0004      | Kitchen Knife   |         2800 |
| 0005      | Pressure Cooker |         5000 |
| 0006      | Fork            |         NULL |
| 0007      | Grater          |          790 |
| 0008      | Ballpoint Pen   |         NULL |
+-----------+-----------------+--------------+
8 rows in set (0.00 sec)
```

- 全列取得したい場合は`*`を使う
  - **アスタリスクを使うと、結果列の並び順を指定することはできない！**
  - CREATE TABLE文で指定した列の順番で取得される
```sql
mysql> SELECT * FROM Shohin;
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

### 列に別名をつける
- 列に`AS`を使って別名をつけることができる
  - 別名をつけることで、列名をわかりやすくすることができる
```sql
mysql> SELECT shohin_id AS 商品ID, shohin_mei AS 商品名, shiire_tanka AS 仕入単価 FROM Shohin;
+-----------+-----------------+--------------+
| 商品ID     | 商品名           | 仕入単価      |
+-----------+-----------------+--------------+
| 0001      | T-shirt         |          500 |
| 0002      | Hole Punch      |          320 |
| 0003      | Dress Shirt     |         2800 |
| 0004      | Kitchen Knife   |         2800 |
| 0005      | Pressure Cooker |         5000 |
| 0006      | Fork            |         NULL |
| 0007      | Grater          |          790 |
| 0008      | Ballpoint Pen   |         NULL |
+-----------+-----------------+--------------+
8 rows in set (0.00 sec)
```

### 重複を除く
- `DISTINCT`を使うと重複を除いた結果を取得できる
  - DISTINCTは列名の前に指定する:先頭の列名の前しか指定できない
  - DISTINCTを使うと、**NULLも1つの値として扱われる**
  - 複数行にNULLが含まれている場合、1つのNULLだけが表示される

```sql
mysql> SELECT DISTINCT shohin_bunrui FROM Shohin;
+------------------+
| shohin_bunrui    |
+------------------+
| Clothing         |
| Office Supplies  |
| Kitchen Supplies |
+------------------+
3 rows in set (0.00 sec)

mysql> SELECT DISTINCT shiire_tanka FROM Shohin;
+--------------+
| shiire_tanka |
+--------------+
|          500 |
|          320 |
|         2800 |
|         5000 |
|         NULL |
|          790 |
+--------------+
6 rows in set (0.00 sec)
```

### WHERE句


### まとめ
- 本記事では「**第0章：イントロダクション**」「**第1章：データベースとSQL**」で学んだ内容をまとめました
- 次回以降は「**第2章：データの検索**」についてまとめていきます

## 参考
- [SQL 第2版 ゼロからはじめるデーエベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)
