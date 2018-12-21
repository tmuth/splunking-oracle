
-- Unified Audit Trail

-- Count of rows by day
select event_day,count(*) cnt from(
    select trunc(cast(event_timestamp as date),'dd') event_day from unified_audit_trail where event_timestamp >= (systimestamp - 30))
group by event_day
order by cnt desc nulls last;


-- Count of rows by d
select min(cnt), max(cnt), avg(cnt),stddev(cnt) from(
select event_day,count(*) cnt from(
    select trunc(cast(event_timestamp as date),'dd') event_day from unified_audit_trail where event_timestamp >= (systimestamp - 30))
group by event_day);



-- create a user to own a temp copy of the audit Trail
create user audit_sizing identified by audit_sizing default tablespace users temporary tablespace temp quota unlimited on users;
grant connect,create session,create table,unlimited tablespace, CREATE JOB, MANAGE SCHEDULER, MANAGE ANY QUEUE to audit_sizing;
grant execute on dbms_stats to audit_sizing;
grant select on sys.unified_audit_trail to audit_sizing;


-- connect audit_sizing/audit_sizing


-- create a copy of the audit table then gather stats on it to get avg row length
-- don't do this in the SYS schema.
create table unified_audit_test as select * from unified_audit_trail where event_timestamp >= (systimestamp - 30) and rownum =< 100000;

-- need "create table" and "unlimited tablespace" grants to run as non-dba
-- https://docs.oracle.com/database/121/ARPLS/d_stats.htm#ARPLS68582

exec dbms_stats.gather_table_stats(ownname => user, tabname => 'UNIFIED_AUDIT_TEST', estimate_percent = 100);

select avg_row_len avg_length_bytes from user_tables where table_name='UNIFIED_AUDIT_TEST';
