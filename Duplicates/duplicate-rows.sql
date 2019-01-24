-- This script creates some sample data in an Oracle DB to test working with duplicate rows.
-- Run as a non-DBA user that has the select grant for all_objects


alter session set nls_date_format = 'YYYY-MM-DD HH24:MI:SS';

drop table test_objects purge;

-- create a table based off of all_objects.
create table test_objects as
select sysdate - (rnum/86400) time_stamp, a.*
  from (
    select rownum rnum, owner,object_name,object_type from all_objects
) a;

-- Create 100 duplicate rows using a random sample of the 1st 40000 rows
insert into test_objects
select * from test_objects
 where rnum in(
    select round(dbms_random.value(1,40000)) the_num from dual connect by level <= 100);
commit;

-- Show all of the rows that have duplicates
select time_stamp, count(*)
  from test_objects
  group by time_stamp
  having count(*) > 1;

-- This is how you would do the delete in Oracle. delete where rowid in...
select rowid,t2.* from(
    select t.*,row_number() over (partition by time_stamp order by time_stamp) as row_number
      from test_objects t) t2
  where row_number > 1;
