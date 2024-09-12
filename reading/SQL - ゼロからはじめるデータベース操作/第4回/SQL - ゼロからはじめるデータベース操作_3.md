## 概要
- 本記事は[SQL 第2版 ゼロからはじめるデータベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)で学んだ内容をまとめたものです。
  - 前回は「**第2章：検索の基本**」2-2: 算術演算子と比較演算, 2-3: 論理演算子 で学んだ内容をまとめました：[SQL 第2版 ゼロからはじめるデータベース操作 アウトプット（第3回）](https://qiita.com/takumi_links/items/cb6cb79c0dfb79c73f08)
  - 今回は「**第3章：集約と並び替え**」3-1: テーブルを集約して検索する, 3-2: テーブルをグループに切り分ける　についてまとめていきます
  - 第3章もボリュームがあったので、複数回に分けてまとめていきます

### 集約関数
- SQLには集計用の関数が多く用意されている
  - 集約：**複数行を1つの行にまとめること**
  - 集約関数：**複数行のデータを1つのデータにまとめる関数**


- 集約関数の種類は以下（テーブルで）

| 関数 | 意味                    |
| --- |-----------------------|
| COUNT | テーブルのレコード数（行数）を数える    |
| SUM | テーブルの**数値列**の合計値を求める  |
| AVG | テーブルの**数値列**の平均値を求める  |
| MAX | テーブルの任意の列のデータの最大値を求める |
| MIN | テーブルの任意の列のデータの最小値を求める               |

#### COUNT
- `COUNT`の注意点
  - テーブル全行を数える=NULLを含む行数：`COUNT(*)`
  - NULL以外の行を数える：`COUNT(列名)`

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

mysql> SELECT COUNT(*) FROM Shohin;
+----------+
| COUNT(*) |
+----------+
|        8 |
+----------+
1 row in set (0.02 sec)

mysql> SELECT COUNT(shiire_tanka) FROM Shohin;
+---------------------+
| COUNT(shiire_tanka) |
+---------------------+
|                   6 |
+---------------------+
1 row in set (0.00 sec)


mysql> SELECT shohin_mei, shohin_bunrui FROM Shohin WHERE hanbai_tanka <> 500;
+-----------------+------------------+
| shohin_mei      | shohin_bunrui    |
+-----------------+------------------+
| T-shirt         | Clothing         |
| Dress Shirt     | Clothing         |
| Kitchen Knife   | Kitchen Supplies |
| Pressure Cooker | Kitchen Supplies |
| Grater          | Kitchen Supplies |
| Ballpoint Pen   | Office Supplies  |
+-----------------+------------------+
6 rows in set (0.01 sec)

mysql> SELECT shohin_mei, shohin_bunrui, hanbai_tanka FROM Shohin WHERE hanbai_tanka >= 1000;
+-----------------+------------------+--------------+
| shohin_mei      | shohin_bunrui    | hanbai_tanka |
+-----------------+------------------+--------------+
| T-shirt         | Clothing         |         1000 |
| Dress Shirt     | Clothing         |         4000 |
| Kitchen Knife   | Kitchen Supplies |         3000 |
| Pressure Cooker | Kitchen Supplies |         6800 |
+-----------------+------------------+--------------+
4 rows in set (0.00 sec)
```

#### SUM
- `SUM`の注意点
  - NULLを含む行は、合計値には含まれない
  - **NULLは何個あっても全て無視される**

```sql
mysql> SELECT SUM(hanbai_tanka), SUM(shiire_tanka) FROM Shohin;
+-------------------+-------------------+
| SUM(hanbai_tanka) | SUM(shiire_tanka) |
+-------------------+-------------------+
|             16780 |             12210 |
+-------------------+-------------------+
1 row in set (0.01 sec)
```

#### AVG
- `AVG` = (値の合計) / (値の個数)
- `AVG`の注意点
  - NULLを含む行は、平均値には含まれない
  - **NULLは何個あっても全て無視される**

```sql
mysql> SELECT AVG(hanbai_tanka), AVG(shiire_tanka) FROM Shohin;
+-------------------+-------------------+
| AVG(hanbai_tanka) | AVG(shiire_tanka) |
+-------------------+-------------------+
|         2097.5000 |         2035.0000 |
+-------------------+-------------------+
1 row in set (0.01 sec)
```

#### MAX/MIN
- `MAX`：最大値を求める, maximum(最大値)
- `MIN`：最小値を求める, minimum(最小値)


- 順序がつけられるデータであれば、最大値と最小値を求めることができる
  - 数値型、文字列型、日付型など
  - `SUM`と`AVG`は数値型の列にしか使えないが、`MAX`と`MIN`は**数値型以外の列にも使える**

```sql
mysql> SELECT MAX(hanbai_tanka), MIN(shiire_tanka) FROM Shohin;
+-------------------+-------------------+
| MAX(hanbai_tanka) | MIN(shiire_tanka) |
+-------------------+-------------------+
|              6800 |               320 |
+-------------------+-------------------+
1 row in set (0.01 sec)
             
mysql> SELECT MAX(torokubi), MIN(torokubi) FROM Shohin;
+---------------+---------------+
| MAX(torokubi) | MIN(torokubi) |
+---------------+---------------+
| 2009-11-11    | 2008-04-28    |
+---------------+---------------+
1 row in set (0.00 sec)
```

#### DISTINCT
- `distinct`：重複するデータを除いて、異なるデータのみを取り出す


- ex) 商品分類の個数を数える
  - 値の種類を数えたい時は、`COUNT(DISTINCT 列名)`を使う
```sql
mysql> SELECT COUNT(DISTINCT shohin_bunrui) FROM Shohin;
+-------------------------------+
| COUNT(DISTINCT shohin_bunrui) |
+-------------------------------+
|                             3 |
+-------------------------------+
1 row in set (0.02 sec)
```

### GROUP BY句
- めちゃ重要！！
  - `GROUP BY`句：**テーブルをカットするナイフ**である
  - テーブルをいくつかのグループに切り分けて集約する
  - 句の記述順序：`SELECT`句→`FROM`句→`WHERE`句→`GROUP BY`句


- ex) 商品分類**ごと**の個数を数える
  - 商品分類ごとにグループ分けして、グループごとの個数を数える


- `GROUP BY`句に指定する列のことを**集約キー**や**グループ化列**と呼ぶ
  - テーブルをどう切り分けるか指定するための重要な列
```sql
mysql> SELECT shohin_bunrui, COUNT(*) FROM Shohin GROUP BY shohin_bunrui;
+------------------+----------+
| shohin_bunrui    | COUNT(*) |
+------------------+----------+
| Clothing         |        2 |
| Office Supplies  |        2 |
| Kitchen Supplies |        4 |
+------------------+----------+
3 rows in set (0.00 sec)
```
- 集約キーにNULLが含まれる場合、「NULL」というグループに分類される

```sql
mysql> SELECT shiire_tanka, COUNT(*) FROM Shohin GROUP BY shiire_tanka;
+--------------+----------+
| shiire_tanka | COUNT(*) |
+--------------+----------+
|          500 |        1 |
|          320 |        1 |
|         2800 |        2 |
|         5000 |        1 |
|         NULL |        2 |
|          790 |        1 |
+--------------+----------+
6 rows in set (0.00 sec)
```
- `WHERE`句で条件を指定してから`GROUP BY`句を使う
  - `WHERE`句で指定した条件で先にデータが絞り込まれてから、`GROUP BY`句でグループ化する
  - `FROM`→`WHERE`→`GROUP BY`→`SELECT`の順で実行される

```sql
mysql> SELECT shiire_tanka, COUNT(*) FROM Shohin WHERE shohin_bunrui = 'Clothing' GROUP BY shiire_tanka;
+--------------+----------+
| shiire_tanka | COUNT(*) |
+--------------+----------+
|          500 |        1 |
|         2800 |        1 |
+--------------+----------+
2 rows in set (0.00 sec)
```

### 集約関数とGROUP BY句の組み合わせで気を付けること
- 注意点①：SELECT句には余計な列を書かない！
  - 集約関数を使った場合、SELECTに指定できるのは以下3つ
  - **定数、集約関数、GROUP BY句に指定した列（集約キー）**

```sql
mysql> SELECT shohin_mei, shiire_tanka  FROM Shohin WHERE shohin_bunrui = 'Clothing';
+-------------+--------------+
| shohin_mei  | shiire_tanka |
+-------------+--------------+
| T-shirt     |          500 |
| Dress Shirt |         2800 |
+-------------+--------------+
2 rows in set (0.00 sec)

mysql> SELECT shohin_mei, shiire_tanka, COUNT(*) FROM Shohin WHERE shohin_bunrui = 'Clothing' GROUP BY shiire_tanka;
ERROR 1055 (42000): Expression #1 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'sample_db.Shohin.shohin_mei' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
```

- 注意点②：GROUP BY句に別名の列名は指定しない！
  - `SELECT`句では、列に別名をつけることができるが、`GROUP BY`句では別名を使うことは推奨されない
  - MySQL8.0以降では、`GROUP BY`句に別名の列名を使うことができる！

```sql
mysql> SELECT shiire_tanka AS 'tanka', COUNT(*) FROM Shohin WHERE shohin_bunrui = 'Clothing' GROUP BY tanka;
+-------+----------+
| tanka | COUNT(*) |
+-------+----------+
|   500 |        1 |
|  2800 |        1 |
+-------+----------+
2 rows in set (0.00 sec)
```

- 注意点③：`GROUP BY`句は結果の順序を保証しない
  - `GROUP BY`句を使うと、結果の順序が保証されない、ランダムに並び替えられる
  - 並び順を指定したいときは、`ORDER BY`句を使う

```sql
mysql> SELECT shiire_tanka AS 'tanka', COUNT(*) FROM Shohin WHERE shohin_bunrui = 'Clothing' GROUP BY tanka;
+-------+----------+
| tanka | COUNT(*) |
+-------+----------+
|   500 |        1 |
|  2800 |        1 |
+-------+----------+
2 rows in set (0.00 sec)
```

- 注意点④：集約関数を書く場所は`SELECT`句と`HAVING`句と`ORDER BY`句のみ
  - `WHERE`句では集約関数を使うことができない

```sql
mysql> SELECT shiire_tanka, COUNT(*) FROM Shohin GROUP BY shiire_tanka Having COUNT(*) > 1;
+--------------+----------+
| shiire_tanka | COUNT(*) |
+--------------+----------+
|         2800 |        2 |
|         NULL |        2 |
+--------------+----------+
2 rows in set (0.00 sec)

mysql> SELECT shiire_tanka, COUNT(*) FROM Shohin GROUP BY shiire_tanka ORDER BY COUNT(*) desc;
+--------------+----------+
| shiire_tanka | COUNT(*) |
+--------------+----------+
|         2800 |        2 |
|         NULL |        2 |
|          500 |        1 |
|          320 |        1 |
|         5000 |        1 |
|          790 |        1 |
+--------------+----------+
6 rows in set (0.01 sec)
```

#### DISTINCTとGROUP BY句で同じ結果を得る
```sql
mysql> SELECT shohin_bunrui FROM Shohin GROUP BY shohin_bunrui;
+------------------+
| shohin_bunrui    |
+------------------+
| Clothing         |
| Office Supplies  |
| Kitchen Supplies |
+------------------+
3 rows in set (0.00 sec)

mysql> SELECT DISTINCT shohin_bunrui FROM Shohin;
+------------------+
| shohin_bunrui    |
+------------------+
| Clothing         |
| Office Supplies  |
| Kitchen Supplies |
+------------------+
3 rows in set (0.00 sec)
```

### まとめ
- 本記事では「「**第3章：集約と並び替え**」3-1: テーブルを集約して検索する, 3-2: テーブルをグループに切り分ける についてまとめました！

## 参考
- [SQL 第2版 ゼロからはじめるデーエベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)
