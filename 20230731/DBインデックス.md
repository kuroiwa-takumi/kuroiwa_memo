# DBにおけるインデックスの動作検証：複合インデックスと各カラムへの個別インデックス付与時の違い

## 概要
-  あるテーブルにインデックスを付与したと思った場合、あるクエリの実行で複数のカラムに対してインデックスを効かせたいと思った場合、以下の2つの選択肢が考えられる

### 選択肢
- ① Where句で指定するそれぞれのカラムに対して、個別のインデックスを付与する
- ② WHere句で指定するそれぞれのカラムに対して、複合インデックスを付与する

```sql
-- columnAとcolumnBに対してインデックスを効かせたい
SELECT * FROM Table WHERE columnA = ? AND columnB = ?;
```

↑それぞれの選択肢をそれぞれ試して、
- パフォーマンスにどのくらい差があるのか(意図した通り、インデックスは適用されるのか)を具体的に確認していく
- いずれの場合もインデックスが効くのか？効かないのか？効く場合、内部的な動きに違いがあるか？

色々試してみた結果をまとめてます。

## 環境
色々なRDBの挙動をみたかったので、複数のDBで検証してみました。

- SQLServer
- MySQL
- PostgresSQL
  - Dockerにて構築

## 準備
- テスト用のテーブルを用意、データをinsertするSQL文を生成する

```sql
-- 研修時に作成したテーブル
CREATE TABLE TMyGoodsList (
    mglMyGoodsListID INT NOT NULL IDENTITY(1,1),
    mglGoodsID INT NOT NULL,
    mglShopID INT NOT NULL,
    mglGoodsName NVARCHAR(200) NOT NULL,
    mglRegistDT DATETIME NOT NULL DEFAULT '1900/01/01 00:00:00',
    mglModifyDT DATETIME NULL,
    CONSTRAINT PK_TMyGoodsList_1 PRIMARY KEY CLUSTERED (mglMyGoodsListID)
);
-- PKeyにはインデックスが自動的に作成される
```
- テスト用insertデータ作成用shell作成
    - 5万件ほど用意してDBに投入

```shell
#!/bin/bash
for i in {1..50000}
do
  echo "INSERT INTO TMyGoodsList (mglGoodsID, mglShopID, mglGoodsName, mglRegistDT ) VALUES ('${i}','${i}','商品名${i}',GETDATE())"
done > insert.sql
```
## 検証
- 検証①：Where句で指定するそれぞれのカラムに対して、個別のインデックスを付与する
    - インデックス作成: `mglGoodsID`と `mglShopID`にそれぞれインデックスを付与

```sql
-- mglGoodsID
CREATE INDEX IDX_GOODS_ID
    ON TMyGoodsList ([mglGoodsID])
GO

DROP INDEX IDX_GOODS_ID
    ON [TMyGoodsList]
GO

-- mglShopID
CREATE INDEX IDX_SHOP_ID
    ON TMyGoodsList ([mglShopID])
GO

DROP INDEX IDX_SHOP_ID
    ON [TMyGoodsList]
GO
```
- SQLを実行
```sql
SELECT * FROM TMyGoodsList
WHERE mglShopID = 197 AND mglShopID = 58719577;
```
