## 概要
- 本記事は[SQL 第2版 ゼロからはじめるデータベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)で学んだ内容をまとめたものです。
  - 前回は「**第2章：検索の基本**」2-1:SELECT文の基本, 2-2: 算術演算子と比較演算子（比較演算子はまだ）で学んだ内容をまとめました：[SQL 第2版 ゼロからはじめるデータベース操作 アウトプット（第2回）]()
  - 今回は「**第2章：検索の基本**」2-2: 算術演算子と比較演算, 2-3: 論理演算子 についてまとめていきます
  - 第2章が意外とボリュームがあったので、複数回に分けてまとめていきます

### 比較演算子
- 「=」のように、両辺に記述した列や値を比較する記号のことを**比較演算子**という
  - 比較演算子を使って、色々な条件式がかける
- 以上（>=）以下（<=）は不等号とイコールの書く順番に注意
  - 例）`>=`、`<=` : 必ず不等号が左側に来る、イコールが右側に来る 

| 演算子 | 意味 |
| --- | --- |
| = | 等しい |
| <> | 等しくない |
| > | より大きい |
| < | より小さい |
| >= | 以上 |
| <= | 以下 |

```sql
mysql> SELECT shohin_mei, shohin_bunrui FROM Shohin WHERE hanbai_tanka = 500;
+------------+------------------+
| shohin_mei | shohin_bunrui    |
+------------+------------------+
| Hole Punch | Office Supplies  |
| Fork       | Kitchen Supplies |
+------------+------------------+
2 rows in set (0.00 sec)

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

mysql> SELECT shohin_mei, shohin_bunrui, torokubi FROM Shohin WHERE torokubi < '2009-09-27';
+-----------------+------------------+------------+
| shohin_mei      | shohin_bunrui    | torokubi   |
+-----------------+------------------+------------+
| T-shirt         | Clothing         | 2009-09-20 |
| Hole Punch      | Office Supplies  | 2009-09-11 |
| Kitchen Knife   | Kitchen Supplies | 2009-09-20 |
| Pressure Cooker | Kitchen Supplies | 2009-01-15 |
| Fork            | Kitchen Supplies | 2009-09-20 |
| Grater          | Kitchen Supplies | 2008-04-28 |
+-----------------+------------------+------------+
6 rows in set (0.00 sec)
```

### 文字列と不等号
- Charで色々な文字を比べてみる

```sql
mysql> SELECT chr FROM Chars WHERE chr > '2';
+-----+
| chr |
+-----+
| 222 |
| 3   |
+-----+
2 rows in set (0.00 sec)
```

- 2と'2'は全くの別物
  - 2は数値、'2'は文字列
  - 文字列型の比較は**辞書順**で比較される
  - 数値の大小順序と混同してはいけない！！

- 同じ文字で始まる単語同士は、異なる文字で始まる単語よりも近い関係にある
  - '10'、'11'は'2'よりも小さいと判定される
  - '2'、'222'は'3'よりも小さいと判定される

```sql
mysql> SELECT chr FROM Chars;
+-----+
| chr |
+-----+
| 1   |
| 10  |
| 11  |
| 2   |
| 222 |
| 3   |
+-----+
6 rows in set (0.00 sec)
```

### NULLに比較演算子は使えない
- NULLが条件のデータを調べたい場合は、`IS NULL`、`IS NOT NULL`を使う
  - NULLは「値が存在しない」を意味する
  - NULLは「値が存在しない」ので、比較演算子を使っても比較できない

```sql
mysql> SELECT shohin_mei, shiire_tanka FROM Shohin WHERE shiire_tanka = 2800;
+---------------+--------------+
| shohin_mei    | shiire_tanka |
+---------------+--------------+
| Dress Shirt   |         2800 |
| Kitchen Knife |         2800 |
+---------------+--------------+
2 rows in set (0.01 sec)

mysql> SELECT shohin_mei, shiire_tanka FROM Shohin WHERE shiire_tanka <> 2800;
+-----------------+--------------+
| shohin_mei      | shiire_tanka |
+-----------------+--------------+
| T-shirt         |          500 |
| Hole Punch      |          320 |
| Pressure Cooker |         5000 |
| Grater          |          790 |
+-----------------+--------------+
4 rows in set (0.00 sec)

mysql> SELECT shohin_mei, shiire_tanka FROM Shohin WHERE shiire_tanka = NULL;
Empty set (0.00 sec)

mysql> SELECT shohin_mei, shiire_tanka FROM Shohin WHERE shiire_tanka IS NULL;
+---------------+--------------+
| shohin_mei    | shiire_tanka |
+---------------+--------------+
| Fork          |         NULL |
| Ballpoint Pen |         NULL |
+---------------+--------------+
2 rows in set (0.01 sec)

mysql> SELECT shohin_mei, shiire_tanka FROM Shohin WHERE shiire_tanka IS NOT NULL;
+-----------------+--------------+
| shohin_mei      | shiire_tanka |
+-----------------+--------------+
| T-shirt         |          500 |
| Hole Punch      |          320 |
| Dress Shirt     |         2800 |
| Kitchen Knife   |         2800 |
| Pressure Cooker |         5000 |
| Grater          |          790 |
+-----------------+--------------+
6 rows in set (0.00 sec)
```

### 論理演算子
- NOT演算子
  - 「〜ではない」という検索条件を作る
  - NOT演算子は条件式の前に書く（**NOTは単独では使わない**）
  - 条件を否定するのがNOT演算子の役割、NOTを使わなくても条件式を否定できる

例：
`SELECT shohin_mei, shohin_bunrui, hanbai_tanka FROM Shohin WHERE NOT hanbai_tanka >= 1000;`
- hanbai_tankaが1000以上ではない商品を検索
  - 1000未満の商品を検索する
  - `hanbai_tanka < 1000`と同じ意味

```sql
mysql> SELECT shohin_mei, shohin_bunrui, hanbai_tanka FROM Shohin WHERE NOT hanbai_tanka >= 1000;
+---------------+------------------+--------------+
| shohin_mei    | shohin_bunrui    | hanbai_tanka |
+---------------+------------------+--------------+
| Hole Punch    | Office Supplies  |          500 |
| Fork          | Kitchen Supplies |          500 |
| Grater        | Kitchen Supplies |          880 |
| Ballpoint Pen | Office Supplies  |          100 |
+---------------+------------------+--------------+
4 rows in set (0.01 sec)

mysql> SELECT shohin_mei, shohin_bunrui, hanbai_tanka FROM Shohin WHERE  hanbai_tanka < 1000;
+---------------+------------------+--------------+
| shohin_mei    | shohin_bunrui    | hanbai_tanka |
+---------------+------------------+--------------+
| Hole Punch    | Office Supplies  |          500 |
| Fork          | Kitchen Supplies |          500 |
| Grater        | Kitchen Supplies |          880 |
| Ballpoint Pen | Office Supplies  |          100 |
+---------------+------------------+--------------+
4 rows in set (0.00 sec)
```

#### AND演算子とOR演算子
- WHERE句では、複数の条件式を組み合わせて検索条件を指定できる
  - AND演算子やOR演算子を使って、複数の条件式を組み合わせる
- **AND演算子**
  - 両辺の検索条件が両方成立する場合に検索条件を満たす
- **OR演算子**
  - 両辺の検索条件のどちらかが成立する場合に検索条件を満たす

```sql
mysql> SELECT shohin_mei, shiire_tanka FROM Shohin WHERE shohin_bunrui = 'Kitchen Supplies' AND hanbai_tanka >= 3000;
+-----------------+--------------+
| shohin_mei      | shiire_tanka |
+-----------------+--------------+
| Kitchen Knife   |         2800 |
| Pressure Cooker |         5000 |
+-----------------+--------------+
2 rows in set (0.00 sec)

mysql> SELECT shohin_mei, shiire_tanka FROM Shohin WHERE shohin_bunrui = 'Kitchen Supplies' OR hanbai_tanka >= 3000;
+-----------------+--------------+
| shohin_mei      | shiire_tanka |
+-----------------+--------------+
| Dress Shirt     |         2800 |
| Kitchen Knife   |         2800 |
| Pressure Cooker |         5000 |
| Fork            |         NULL |
| Grater          |          790 |
+-----------------+--------------+
5 rows in set (0.00 sec)
```

- AND演算子とOR演算子を組み合わせて使うこともできる
  - 例）`WHERE shohin_bunrui = 'Kitchen Supplies' AND (hanbai_tanka >= 3000 OR shiire_tanka < 1000)`
    - 「キッチン用品で、販売単価が3000以上または仕入れ単価が1000未満の商品」を検索

- この際に、条件式を括弧`()`で囲むことで、条件式の優先順位を明確にすることができる
  - **OR演算子よりもAND演算子の方が優先される**
  - 括弧で囲むことで、条件式の優先順位を変更できる
- **ANDはORより強し。ORを優先する時は、囲い込むべし！**

```sql
mysql> SELECT shohin_mei, shohin_bunrui, torokubi FROM Shohin WHERE shohin_bunrui = 'Office Supplies' AND (torokubi = '2009-09-11' OR torokubi = '2009-09-20');
+------------+-----------------+------------+
| shohin_mei | shohin_bunrui   | torokubi   |
+------------+-----------------+------------+
| Hole Punch | Office Supplies | 2009-09-11 |
+------------+-----------------+------------+
1 row in set (0.00 sec)
```

#### 論理演算子と真理値
- AND・OR・NOT演算子は、**論理演算子**と呼ばれる
  - 論理演算子は、真理値（真：Trueか偽:Falseか）を扱う
  - SQLの場合は「不明：Unknown」も含む3値論理を扱う
    - 真理値は「真：True」、「偽：False」、「不明：Unknown」の3つの値を取る
    - 3値論理では、真理値の結果が「真」、「偽」、「不明」の3つの値を取る

### 練習問題を解いてみる
- 2.1 - 2.4を解いてみた内容を掲載
```sql
2-1.
mysql> SELECT shohin_mei, torokubi FROM Shohin WHERE torokubi >= '2009-04-28';
+---------------+------------+
| shohin_mei    | torokubi   |
+---------------+------------+
| T-shirt       | 2009-09-20 |
| Hole Punch    | 2009-09-11 |
| Kitchen Knife | 2009-09-20 |
| Fork          | 2009-09-20 |
| Ballpoint Pen | 2009-11-11 |
+---------------+------------+
5 rows in set (0.01 sec)

2.2.
mysql> SELECT * FROM Shohin WHERE shiire_tanka = NULL;
Empty set (0.01 sec)

mysql> SELECT * FROM Shohin WHERE shiire_tanka <> NULL;
Empty set (0.00 sec)

mysql> SELECT * FROM Shohin WHERE shiire_tanka > NULL;
Empty set (0.00 sec)
          
2-3.
-- 販売単価が仕入単価より500円以上高い商品を検索
mysql> SELECT shohin_mei, hanbai_tanka, shiire_tanka FROM Shohin WHERE hanbai_tanka - shiire_tanka >= 500;
+-----------------+--------------+--------------+
| shohin_mei      | hanbai_tanka | shiire_tanka |
+-----------------+--------------+--------------+
| T-shirt         |         1000 |          500 |
| Dress Shirt     |         4000 |         2800 |
| Pressure Cooker |         6800 |         5000 |
+-----------------+--------------+--------------+
3 rows in set (0.00 sec)

mysql> SELECT shohin_mei, hanbai_tanka, shiire_tanka FROM Shohin WHERE hanbai_tanka >=  shiire_tanka + 500;
+-----------------+--------------+--------------+
| shohin_mei      | hanbai_tanka | shiire_tanka |
+-----------------+--------------+--------------+
| T-shirt         |         1000 |          500 |
| Dress Shirt     |         4000 |         2800 |
| Pressure Cooker |         6800 |         5000 |
+-----------------+--------------+--------------+
3 rows in set (0.01 sec)

mysql> SELECT shohin_mei, hanbai_tanka, shiire_tanka FROM Shohin WHERE hanbai_tanka - 500 >=  shiire_tanka;
+-----------------+--------------+--------------+
| shohin_mei      | hanbai_tanka | shiire_tanka |
+-----------------+--------------+--------------+
| T-shirt         |         1000 |          500 |
| Dress Shirt     |         4000 |         2800 |
| Pressure Cooker |         6800 |         5000 |
+-----------------+--------------+--------------+
3 rows in set (0.00 sec)

2.4
-- 販売単価を10%引きにしても利益が100円より高い事務用品とキッチン用品
mysql> SELECT shohin_mei, shohin_bunrui, (hanbai_tanka * 0.9 - shiire_tanka) as 'rieki' FROM Shohin WHERE (hanbai_tanka * 0.9 - shiire_tanka) > 100 AND shohin_bunrui IN ('Office Supplies', 'Kitchen Supplies');
+-----------------+------------------+--------+
| shohin_mei      | shohin_bunrui    | rieki  |
+-----------------+------------------+--------+
| Hole Punch      | Office Supplies  |  130.0 |
| Pressure Cooker | Kitchen Supplies | 1120.0 |
+-----------------+------------------+--------+
2 rows in set (0.01 sec)
```

### まとめ
- 本記事では「**第2章：データの検索**」2-2: 算術演算子と比較演算, 2-3: 論理演算子 についてまとめました！


## 参考
- [SQL 第2版 ゼロからはじめるデーエベース操作](https://www.shoeisha.co.jp/book/detail/9784798144450)
