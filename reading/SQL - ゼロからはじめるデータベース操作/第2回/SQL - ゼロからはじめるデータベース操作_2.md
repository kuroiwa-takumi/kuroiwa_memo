## 概要
- 本記事は[SQL 第2版 ゼロからはじめるデータベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)で学んだ内容をまとめたものです。
  - 前回は「**第0章：イントロダクション**」「**第1章：データベースとSQL**」で学んだ内容をまとめました：[SQL 第2版 ゼロからはじめるデータベース操作 アウトプット（第1回）](https://qiita.com/takumi_links/items/42f54fed377cbc266333)
  - 今回は「**第2章：検索の基本**」についてまとめていきます
  - 第2章が意外とボリュームがあったので、複数回に分けてまとめていきます

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
- SELECT文では、選択したい行の条件を**WHERE句**で指定できる
  - WHERE句はSELECT文のFROM句の後に指定する
  - 「ある列の値がこの文字列と等しい」「ある列の値がこの数値より大きい」などの条件を指定できる
  - 条件式：検索条件を指定する式

### 1行コメントと複数行コメント
- 1行コメント：`--`を使う
- 複数行コメント：`/* */`を使う

```sql
mysql> SELECT shohin_mei, shohin_bunrui FROM Shohin WHERE shohin_bunrui = 'Clothing';
+-------------+---------------+
| shohin_mei  | shohin_bunrui |
+-------------+---------------+
| T-shirt     | Clothing      |
| Dress Shirt | Clothing      |
+-------------+---------------+
2 rows in set (0.00 sec)
```

## 算術演算子
### 演算子とは
- 演算子の両辺にある値を使って四則演算や文字列の結合、数値の大小比較などの演算を行う

### 算術演算子
- 四則演算を行う記号：`+`, `-`, `*`, `/`は算術演算子と呼ばれる

```sql
-- 各商品について2つ分の価格
mysql> SELECT shohin_mei, hanbai_tanka, hanbai_tanka * 2 AS 'hanbai_tanka * 2' FROM Shohin;
+-----------------+--------------+------------------+
| shohin_mei      | hanbai_tanka | hanbai_tanka * 2 |
+-----------------+--------------+------------------+
| T-shirt         |         1000 |             2000 |
| Hole Punch      |          500 |             1000 |
| Dress Shirt     |         4000 |             8000 |
| Kitchen Knife   |         3000 |             6000 |
| Pressure Cooker |         6800 |            13600 |
| Fork            |          500 |             1000 |
| Grater          |          880 |             1760 |
| Ballpoint Pen   |          100 |              200 |
+-----------------+--------------+------------------+
8 rows in set (0.00 sec)
```

### NULLの計算に注意
- NULLを含んだ計算は、問答無用でNULLになる
  - NULLは「未定義」「不明」という意味
  - NULLが含まれると、計算結果もNULLになる
```sql
mysql> select 5 + NULL
    -> ;
+----------+
| 5 + NULL |
+----------+
|     NULL |
+----------+
1 row in set (0.00 sec)

mysql> select 5 + NULL;
+----------+
| 5 + NULL |
+----------+
|     NULL |
+----------+
1 row in set (0.00 sec)

mysql> select 10 - NULL;
+-----------+
| 10 - NULL |
+-----------+
|      NULL |
+-----------+
1 row in set (0.00 sec)

mysql> select 1 * NULL;
+----------+
| 1 * NULL |
+----------+
|     NULL |
+----------+
1 row in set (0.00 sec)

mysql> select 4 / NULL;
+----------+
| 4 / NULL |
+----------+
|     NULL |
+----------+
1 row in set (0.00 sec)

mysql> select NULL / 9;
+----------+
| NULL / 9 |
+----------+
|     NULL |
+----------+
1 row in set (0.00 sec)

mysql> select NULL / 0;
+----------+
| NULL / 0 |
+----------+
|     NULL |
+----------+
1 row in set (0.00 sec)
```


### まとめ
- 本記事では「**第2章：検索の基本**」2-1:SELECT文の基本, 2-2: 算術演算子と比較演算子の途中（比較演算子はまだ）までまとめました
- 次回以降は「**第2章：検索の基本**」2-2: 算術演算子と比較演算, 2-3: 論理演算子 についてまとめていきます

## 参考
- [SQL 第2版 ゼロからはじめるデーエベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)
