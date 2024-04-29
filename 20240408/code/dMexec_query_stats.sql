-- 実験用クエリ
select count(*) from Member join MemberEMail on Member.MemberID = MemberEMail.MemberID

-- 評価用クエリ
select top (100)
    qt.text as parent_query
    ,SUBSTRING(qt.text, qs.statement_start_offset / 2, (case when qs.statement_end_offset = - 1 then LEN(CONVERT(nvarchar(MAX), qt.text)) * 2 else qs.statement_end_offset end - qs.statement_start_offset) / 2) as statement
     -- average
     ,total_worker_time / qs.execution_count / 1000 as average_cpu_time_ms
     ,total_elapsed_time / qs.execution_count / 1000 as average_duration_ms
     ,total_physical_reads / qs.execution_count / 1000 as average_physical_reads_ms
     -- execution count
     ,qs.execution_count as execution_count
     -- creation / execution time
     ,last_execution_time
     ,creation_time
     -- total
     ,total_worker_time / 1000 as total_cpu_time_ms
     ,total_elapsed_time / 1000 as total_duration_ms
     ,total_physical_reads / 1000 as total_physical_reads_ms
     -- query plan
     ,qp.query_plan
from sys.dm_exec_query_stats qs
    outer apply sys.dm_exec_sql_text(qs.sql_handle) as qt
outer apply sys.dm_exec_query_plan(plan_handle) as qp
where qt.text like '%Member%' --filtering by text
--order by parent_query, statement
order by last_execution_time desc;
