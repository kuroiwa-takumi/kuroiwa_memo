set statistics time on

--Memberテーブルのクラスタ化インデックスの構造を確認
DECLARE @DB_ID int, @OBJECT_ID int
set @DB_ID = DB_ID('MyTuningDB_Small')
set @OBJECT_ID = OBJECT_ID('Member')

SELECT
    index_id
     ,index_type_desc
     ,index_depth
     ,index_level
     ,page_count
     ,record_count
FROM sys.dm_db_index_physical_stats (@DB_ID, @OBJECT_ID, NULL , NULL, 'DETAILED') as A
         JOIN sys.objects as B on A.object_id = B.object_id
ORDER BY index_id, index_level;

--インデックスで使用しているページIDリストを取得
DBCC IND(MyTuningDB_Small, Member, 1)

DBCC TRACEON(3604)
--rootノードのページ
DBCC PAGE(MyTuningDB_Small, 1, 102542, 3) WITH TABLERESULTS

DBCC TRACEON(3604)
--branchノードのページ
DBCC PAGE(MyTuningDB_Small, 1, 180665, 3) WITH TABLERESULTS

DBCC TRACEON(3604)
--leafノードのページ
DBCC PAGE(MyTuningDB_Small, 1, 180770, 3) WITH TABLERESULTS

-- 付加列インデックス
CREATE NONCLUSTERED INDEX [IX_Member_LoginName] ON [dbo].[Member]
(
	[LoginName] ASC
) INCLUDE (RegistDate)

-- 複合インデックス
CREATE NONCLUSTERED INDEX [IX_Member_Sei_PrefectureID]ON [dbo].[Member]
(
	[Sei] ASC,
	[PrefectureID] ASC
)

--インデックス作成時に指定したカラムの両方が検索条件に含まれる
SELECT COUNT(*) FROM Member WHERE Sei = 'Adena' AND PrefectureID = 1

--インデックス作成時に指定した「先頭のカラム」が検索条件に含まれる
SELECT COUNT(*) FROM Member WHERE Sei = 'Adena'

--インデックス作成時に指定したカラムは含むが、「先頭のカラム」が検索条件に含まれていない
SELECT COUNT(*) FROM Member WHERE PrefectureID = 1

--クエリ①
SELECT LoginName, RegistDate, Sei FROM Member WHERE LoginName = 'b1'

--クエリ②
SELECT LoginName, RegistDate FROM Member WHERE LoginName = 'Tawny265167'

--クエリ②をカバーしているカバリングインデックス
CREATE NONCLUSTERED INDEX [IX_Member_LoginName] ON [dbo].[Member]
([LoginName] ASC) INCLUDE (RegistDate)
SELECT LoginName, RegistDate FROM Member WHERE LoginName = 'Tawny265167'

SELECT LoginName, RegistDate, Sei FROM Member WHERE LoginName = 'Tawny265167'

