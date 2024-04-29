## 第1章：CASE式のススメ

- ENDを忘れない
- ELSEを忘れない

### CASE式

```sql
CASE sex
  WHEN '1' THEN '男性'
  WHEN '2' THEN '女性'
  ELSE '不明'
END

CASE WHEN sex = '1' THEN '男性'
     WHEN sex = '2' THEN '女性'
     ELSE '不明'
END
```

- 既存のコード体系を新しい体系に変換して集計する
  - SELECT句でつけた列の別名を使って、GROUP BY句で集計する
```sql
SELECT CASE pref_name
         WHEN '徳島' THEN '四国'
         WHEN '香川' THEN '四国'
         WHEN '愛媛' THEN '四国'
         WHEN '高知' THEN '四国'
         WHEN '福岡' THEN '九州'
         WHEN '佐賀' THEN '九州'
         WHEN '長崎' THEN '九州'
         ELSE 'その他' END AS district,
       SUM(population)
FROM PopTbl
GROUP BY district;
```

## 第3章：自己結合

### 順序対と非順序対

- 順序対
    - (a, b) ≠ (b, a)
    - 順序が違えば別の組み合わせ
- 非順序対
    - {a, b} = {b, a}
    - 順序が違っても同じ組み合わせ

- 3の２乗の組み合わせ

```sql
-- 重複順列
mysql
>
select P1.name as name_1, P2.name as name_2
from Products P1
         cross join Products P2;
+-----------+-----------+
| name_1    | name_2    |
+-----------+-----------+
| バナナ | みかん |
| りんご | みかん |
| みかん | みかん |
| バナナ | りんご |
| りんご | りんご |
| みかん | りんご |
| バナナ | バナナ |
| りんご | バナナ |
| みかん | バナナ |
+-----------+-----------+
9 rows in set (0.03 sec)
```

- (りんご,りんご)の組み合わせはダメ！
    - 物理的には同じストレージに格納されているが、エイリアスが異なるため別の集合として扱われる

```sql
mysql
>
select P1.name as name_1, P2.name as name_2
from Products P1
         cross join Products P2
where P1.name <> P2.name;
+-----------+-----------+
| name_1    | name_2    |
+-----------+-----------+
| バナナ | みかん |
| りんご | みかん |
| バナナ | りんご |
| みかん | りんご |
| りんご | バナナ |
| みかん | バナナ |
+-----------+-----------+
6 rows in set (0.01 sec)
```

- 組み合わせを得る
- 重複を除く
    - P1.name > P2.name
        - 文字コード順にソートして、自分より前に来る商品だけをペアの相手に選ぶ

```sql
mysql
>
select P1.name as name_1, P2.name as name_2
from Products P1
         inner join Products P2 on P1.name > P2.name
    - >;
+-----------+-----------+
| name_1    | name_2    |
+-----------+-----------+
| りんご | みかん |
| バナナ | みかん |
| バナナ | りんご |
+-----------+-----------+
3 rows in set (0.01 sec)

```

- 値段が同じ商品の組み合わせ

```sql
select distinct P1.name, P2.price
from NewProducts P1
         inner join NewProducts P2 on P1.price = P2.price and P1.name <> P2.name;
```
