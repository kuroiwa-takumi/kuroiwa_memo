--問題：インデックスを設計してください
SELECT TOP 10 *
FROM MemberEMail
ORDER BY Email ASC

--回答：order byとキーの並び順を同じにする
create nonclustered index [Ix_MemberMail_Email] on [dbo].[MemberEmail]([Email] asc);

SELECT TOP 10 *
FROM MemberEMail
ORDER BY DeleteFlag ASC
       ,Email DESC

--回答：order byとキーの並び順を同じにする
create nonclustered index [Ix_MemberEmail_DeleteFlg_Email] on [dbo].[MemberEmail]([DeleteFlag] asc, [Email] desc)


