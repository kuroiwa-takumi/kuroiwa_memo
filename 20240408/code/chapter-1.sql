set
statistics time on

select a.MemberID, Sei, Mei, Email
from Member a
         join MemberEMail b on a.MemberID = b.MemberID
where LoginName = 'Tawny265167';

-- check Member.LoginName selectivity
select top 10 count(*)
from Member
group by LoginName
having count (*) > 1
order by count (*) desc;

-- create index
create index Ix_Member_LoginName on Member (LoginName) include (Sei, Mei);
