## 概要
- 本記事は[SQL 第2版 ゼロからはじめるデータベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)で学んだ内容をまとめたものです。
  - 前回は「**第3章：集約と並び替え**」3-1: テーブルを集約して検索する, 3-2: テーブルをグループに切り分ける で学んだ内容をまとめました：[SQL 第2版 ゼロからはじめるデータベース操作 アウトプット（第4回）](https://qiita.com/takumi_links/items/68fb42bc14ebfb04d8d9)
  - 今回は「**第3章：集約と並び替え**」3-3: 集約した結果に条件を指定する, 3-4: 検索結果を並び替える　についてまとめていきます
  - 第3章もボリュームがあったので、複数回に分けてまとめていきます

### HAVING句
- `GROUP BY`句で集約した結果に対する条件を指定するための句
  - `WHERE`句は集約前のデータ（行、レコード）に対する条件を指定する
  - `HAVING`句は集約後のデータに対する条件を指定する
  - `HAVING`句の記述順序：`SELECT`句→`FROM`句→`WHERE`句→`GROUP BY`句→`HAVING`句

```sql
mysql> SELECT shohin_bunrui, COUNT(*) FROM Shohin GROUP BY shohin_bunrui HAVING COUNT(*) = 2;
+-----------------+----------+
| shohin_bunrui   | COUNT(*) |
+-----------------+----------+
| Clothing        |        2 |
| Office Supplies |        2 |
+-----------------+----------+
2 rows in set (0.00 sec)

mysql> SELECT shohin_bunrui, COUNT(*) FROM Shohin GROUP BY shohin_bunrui;
+------------------+----------+
| shohin_bunrui    | COUNT(*) |
+------------------+----------+
| Clothing         |        2 |
| Office Supplies  |        2 |
| Kitchen Supplies |        4 |
+------------------+----------+
3 rows in set (0.00 sec)

mysql> SELECT shohin_bunrui, AVG(hanbai_tanka) FROM Shohin GROUP BY shohin_bunrui HAVING AVG(hanbai_tanka) >= 2500;
+------------------+-------------------+
| shohin_bunrui    | AVG(hanbai_tanka) |
+------------------+-------------------+
| Clothing         |         2500.0000 |
| Kitchen Supplies |         2795.0000 |
+------------------+-------------------+
2 rows in set (0.00 sec)

```

#### HAVING句の注意点
- 注意点①：`HAVING`句に書ける要素は以下3つ
  - **定数、集約関数、GROUP BY句に指定した列（集約キー）**
  - `GROUP BY`句で指定した列（集約キー）以外の列は`HAVING`句に書くことができない!

```sql
mysql> SELECT shohin_bunrui, COUNT(*) FROM Shohin GROUP BY shohin_bunrui HAVING shohin_mei = 'Ballpoint Pen';
ERROR 1054 (42S22): Unknown column 'shohin_mei' in 'having clause'
mysql> SELECT shohin_mei, COUNT(*) FROM Shohin GROUP BY shohin_mei HAVING shohin_mei = 'Ballpoint Pen';
+---------------+----------+
| shohin_mei    | COUNT(*) |
+---------------+----------+
| Ballpoint Pen |        1 |
+---------------+----------+
1 row in set (0.00 sec)
```

- 注意点②：`HAVING`句に書くか、`WHERE`句に書くか
  - 「**集約キーに対する条件**」は`WHERE`句に書くべき！
  - `WHERE`句：単なる「行・レコード」に対する条件を指定する
  - `HAVING`句：「集約した結果」に対する条件を指定する

### ORDER BY句
- 検索結果を並べるには、`ORDER BY`句を使う
  - `ORDER BY`句の記述順序：`SELECT`句→`FROM`句→`WHERE`句→`GROUP BY`句→`HAVING`句→`ORDER BY`句
  - **`ORDER BY`句は、常にSELECT文の最後に書く**：ポイント！！
  - `ORDER BY`句には、並べる列名を指定する
  - `ORDER BY`句には、昇順（ASC）・降順（DESC）を指定できる

- `ORDER BY`句を指定していない場合は、**ランダム**な順番で表示される
  - `ORDER BY`句に書く列名を「**ソートキー**」と呼ぶ
  
- `ASC`と`DESC`を使って昇順・降順を指定する
  - `ASC`：昇順（デフォルト） ascendant（昇っていく）
  - `DESC`：降順 descendant（降っていく）

```sql
mysql> SELECT shohin_id, shohin_mei, hanbai_tanka, shiire_tanka FROM Shohin ORDER BY hanbai_tanka;
+-----------+-----------------+--------------+--------------+
| shohin_id | shohin_mei      | hanbai_tanka | shiire_tanka |
+-----------+-----------------+--------------+--------------+
| 0008      | Ballpoint Pen   |          100 |         NULL |
| 0002      | Hole Punch      |          500 |          320 |
| 0006      | Fork            |          500 |         NULL |
| 0007      | Grater          |          880 |          790 |
| 0001      | T-shirt         |         1000 |          500 |
| 0004      | Kitchen Knife   |         3000 |         2800 |
| 0003      | Dress Shirt     |         4000 |         2800 |
| 0005      | Pressure Cooker |         6800 |         5000 |
+-----------+-----------------+--------------+--------------+
8 rows in set (0.01 sec)

mysql> SELECT shohin_id, shohin_mei, hanbai_tanka, shiire_tanka FROM Shohin ORDER BY hanbai_tanka DESC;
+-----------+-----------------+--------------+--------------+
| shohin_id | shohin_mei      | hanbai_tanka | shiire_tanka |
+-----------+-----------------+--------------+--------------+
| 0005      | Pressure Cooker |         6800 |         5000 |
| 0003      | Dress Shirt     |         4000 |         2800 |
| 0004      | Kitchen Knife   |         3000 |         2800 |
| 0001      | T-shirt         |         1000 |          500 |
| 0007      | Grater          |          880 |          790 |
| 0002      | Hole Punch      |          500 |          320 |
| 0006      | Fork            |          500 |         NULL |
| 0008      | Ballpoint Pen   |          100 |         NULL |
+-----------+-----------------+--------------+--------------+
8 rows in set (0.01 sec)

mysql> SELECT shohin_id, shohin_mei, hanbai_tanka, shiire_tanka FROM Shohin ORDER BY hanbai_tanka DESC;
+-----------+-----------------+--------------+--------------+
| shohin_id | shohin_mei      | hanbai_tanka | shiire_tanka |
+-----------+-----------------+--------------+--------------+
| 0005      | Pressure Cooker |         6800 |         5000 |
| 0003      | Dress Shirt     |         4000 |         2800 |
| 0004      | Kitchen Knife   |         3000 |         2800 |
| 0001      | T-shirt         |         1000 |          500 |
| 0007      | Grater          |          880 |          790 |
| 0002      | Hole Punch      |          500 |          320 |
| 0006      | Fork            |          500 |         NULL |
| 0008      | Ballpoint Pen   |          100 |         NULL |
+-----------+-----------------+--------------+--------------+
8 rows in set (0.01 sec)
```

#### 複数のソートキーを指定する
- `ORDER BY`句には、複数のソートキーを指定することができる
- NULLに比較演算子は使えない
  - NULLと数値の順序付けはできない
  - NULLは「値が存在しない」ため、大小を比較することができない

```sql
mysql> SELECT shohin_id, shohin_mei, hanbai_tanka, shiire_tanka FROM Shohin ORDER BY hanbai_tanka, shohin_id;
+-----------+-----------------+--------------+--------------+
| shohin_id | shohin_mei      | hanbai_tanka | shiire_tanka |
+-----------+-----------------+--------------+--------------+
| 0008      | Ballpoint Pen   |          100 |         NULL |
| 0002      | Hole Punch      |          500 |          320 |
| 0006      | Fork            |          500 |         NULL |
| 0007      | Grater          |          880 |          790 |
| 0001      | T-shirt         |         1000 |          500 |
| 0004      | Kitchen Knife   |         3000 |         2800 |
| 0003      | Dress Shirt     |         4000 |         2800 |
| 0005      | Pressure Cooker |         6800 |         5000 |
+-----------+-----------------+--------------+--------------+
8 rows in set (0.01 sec)
```

#### ソートキーに表示用の別名を使う
- `ORDER BY`句では、表示用の別名を使ってソートキーを指定することができる
  - `SELECT`句でつけた別名を`ORDER BY`句で使うことができる

```sql
mysql> SELECT shohin_id AS id, shohin_mei, hanbai_tanka AS ht, shiire_tanka FROM Shohin ORDER BY ht, id;
+------+-----------------+------+--------------+
| id   | shohin_mei      | ht   | shiire_tanka |
+------+-----------------+------+--------------+
| 0008 | Ballpoint Pen   |  100 |         NULL |
| 0002 | Hole Punch      |  500 |          320 |
| 0006 | Fork            |  500 |         NULL |
| 0007 | Grater          |  880 |          790 |
| 0001 | T-shirt         | 1000 |          500 |
| 0004 | Kitchen Knife   | 3000 |         2800 |
| 0003 | Dress Shirt     | 4000 |         2800 |
| 0005 | Pressure Cooker | 6800 |         5000 |
+------+-----------------+------+--------------+
8 rows in set (0.00 sec)
```
- SELECT文の内部的な実行順序
  - `FROM`句→`WHERE`句→`GROUP BY`句→`HAVING`句→`SELECT`句→`ORDER BY`句
  - `SELECT`句の位置：`GROUP BY`句よりも後で、`ORDER BY`句より前

#### ORDER BY句に使える列
- `SELECT`句に含まれていない列や集約関数も使える

```sql
mysql> SELECT shohin_mei, hanbai_tanka, shiire_tanka FROM Shohin ORDER BY shohin_id;
+-----------------+--------------+--------------+
| shohin_mei      | hanbai_tanka | shiire_tanka |
+-----------------+--------------+--------------+
| T-shirt         |         1000 |          500 |
| Hole Punch      |          500 |          320 |
| Dress Shirt     |         4000 |         2800 |
| Kitchen Knife   |         3000 |         2800 |
| Pressure Cooker |         6800 |         5000 |
| Fork            |          500 |         NULL |
| Grater          |          880 |          790 |
| Ballpoint Pen   |          100 |         NULL |
+-----------------+--------------+--------------+
8 rows in set (0.00 sec)
              
mysql> SELECT shohin_bunrui, COUNT(*) FROM Shohin GROUP BY shohin_bunrui ORDER BY COUNT(*);
+------------------+----------+
| shohin_bunrui    | COUNT(*) |
+------------------+----------+
| Clothing         |        2 |
| Office Supplies  |        2 |
| Kitchen Supplies |        4 |
+------------------+----------+
3 rows in set (0.00 sec)

mysql> SELECT shohin_bunrui, COUNT(*) FROM Shohin GROUP BY shohin_bunrui ORDER BY COUNT(*) DESC;
+------------------+----------+
| shohin_bunrui    | COUNT(*) |
+------------------+----------+
| Kitchen Supplies |        4 |
| Clothing         |        2 |
| Office Supplies  |        2 |
+------------------+----------+
3 rows in set (0.01 sec)
```

### 練習問題を解いてみる
- 3.1 - 3.3を解いてみた内容を掲載
```sql
3-1.
-- SUM関数の引数に文字列型の列を指定している
-- GROUP BY句の前にWHERE句を書くべき
-- GROUP BY句で指定していない項目をSELECTに記述している
mysql> SELECT shohin_id, SUM(shohin_mei) FROM Shohin GROUP BY shohin_bunrui WHERE torokubi > '2009-09-01';
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'WHERE torokubi > '2009-09-01'' at line 1


3.2.
mysql> SELECT shohin_bunrui, SUM(hanbai_tanka) AS sum, SUM(shiire_tanka) AS sum FROM Shohin GROUP BY shohin_bunrui HAVING SUM(hanbai_tanka) > SUM(shiire_tanka) * 1.5;
+-----------------+------+------+
| shohin_bunrui   | sum  | sum  |
+-----------------+------+------+
| Clothing        | 5000 | 3300 |
| Office Supplies |  600 |  320 |
+-----------------+------+------+
2 rows in set (0.01 sec)
          
3-3.
mysql> SELECT shohin_id, shohin_mei, shohin_bunrui, hanbai_tanka, shiire_tanka, torokubi FROM Shohin ORDER BY torokubi DESC, hanbai_tanka;
+-----------+-----------------+------------------+--------------+--------------+------------+
| shohin_id | shohin_mei      | shohin_bunrui    | hanbai_tanka | shiire_tanka | torokubi   |
+-----------+-----------------+------------------+--------------+--------------+------------+
| 0008      | Ballpoint Pen   | Office Supplies  |          100 |         NULL | 2009-11-11 |
| 0006      | Fork            | Kitchen Supplies |          500 |         NULL | 2009-09-20 |
| 0001      | T-shirt         | Clothing         |         1000 |          500 | 2009-09-20 |
| 0004      | Kitchen Knife   | Kitchen Supplies |         3000 |         2800 | 2009-09-20 |
| 0002      | Hole Punch      | Office Supplies  |          500 |          320 | 2009-09-11 |
| 0005      | Pressure Cooker | Kitchen Supplies |         6800 |         5000 | 2009-01-15 |
| 0007      | Grater          | Kitchen Supplies |          880 |          790 | 2008-04-28 |
| 0003      | Dress Shirt     | Clothing         |         4000 |         2800 | NULL       |
+-----------+-----------------+------------------+--------------+--------------+------------+
8 rows in set (0.00 sec)
```


### まとめ
- 本記事では「**第3章：集約と並び替え**」3-3: 集約した結果に条件を指定する, 3-4: 検索結果を並び替える についてまとめました！

## 参考
- [SQL 第2版 ゼロからはじめるデーエベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)
