


## 2. 必ずわかるウィンドウ関数
```sql
-- 商品テーブルを商品IDの昇順にソートして、各商品についてIDの2つ前までの商品を含む価格の移動平均
select shohin_id,
       shohin_mei,
       hanbai_tanka,
       AVG(hanbai_tanka) over (order by shohin_id rows between 2 preceding and current row) as moving_avg
from Shohin;
```
