-- Average Active Sessions - 60 second interval
-- This requires a license for the Oracle Diagnostic Pack and
-- only works on Enterprise Edition.
-- This is slightly modified from a query from http://datavirtualizer.com/ash-masters/
with AAS_WAIT as (
           select
              begin_time, end_time,class, sum(AAS) AAS
              from (
                 select
                 n.wait_class class,
                 sum(round(m.time_waited/m.INTSIZE_CSEC,3))  AAS,
                 min(BEGIN_TIME) over (partition by decode(n.wait_class,'User I/O','User I/O', 'Commit','Commit', 'Wait')) begin_time ,
                 min(END_TIME) over (partition by decode(n.wait_class,'User I/O','User I/O', 'Commit','Commit', 'Wait')) end_time
           from  gv$waitclassmetric  m,
                 gv$system_wait_class n
           where m.wait_class_id=n.wait_class_id
             and n.wait_class != 'Idle'
                                 and n.inst_id = m.inst_id
           group by  n.wait_class, BEGIN_TIME, END_TIME
           order by begin_time
         )
         group by class, begin_time, end_time
),
CORES as (
   select cpu_core_count from dba_cpu_usage_statistics where timestamp= (select max(timestamp) from dba_cpu_usage_statistics)
),
AASSTAT as (
    select *
      from (
    select  BEGIN_TIME,
        END_TIME,
       ( decode(sign(CPU_OS-CPU_ORA_CONSUMED), -1, 0, (CPU_OS - CPU_ORA_CONSUMED )) +
       CPU_ORA_CONSUMED +
        decode(sign(CPU_ORA_DEMAND-CPU_ORA_CONSUMED), -1, 0, (CPU_ORA_DEMAND - CPU_ORA_CONSUMED ))) CPU_TOTAL,
       decode(sign(CPU_OS-CPU_ORA_CONSUMED), -1, 0, (CPU_OS - CPU_ORA_CONSUMED )) CPU_OS,
       CPU_ORA_CONSUMED CPU_ORA,
       decode(sign(CPU_ORA_DEMAND-CPU_ORA_CONSUMED), -1, 0, (CPU_ORA_DEMAND - CPU_ORA_CONSUMED )) CPU_ORA_WAIT
       from(
    select
          min(BEGIN_TIME) BEGIN_TIME,
       max(END_TIME) END_TIME,
       sum(decode(CLASS,'CPU_ORA_CONSUMED',AAS,0)) CPU_ORA_CONSUMED,
       sum(decode(CLASS,'CPU_ORA_DEMAND'  ,AAS,0)) CPU_ORA_DEMAND,
       sum(decode(CLASS,'CPU_OS'          ,AAS,0)) CPU_OS
       from
             (select 'CPU_ORA_CONSUMED'                                     CLASS,
                    round(sum(value)/100,3)                                     AAS,
                 min(BEGIN_TIME) begin_time,
                 max(END_TIME) end_time
             from gv$sysmetric
             where metric_name='CPU Usage Per Sec'
               and group_id=2
            group by metric_name
          union
           select 'CPU_OS'                                                CLASS ,
                    round((prcnt.busy*parameter.cpu_count)/100,3)          AAS,
                 BEGIN_TIME ,
                 END_TIME
            from
              ( select sum(value) busy, min(BEGIN_TIME) begin_time,max(END_TIME) end_time from gv$sysmetric where metric_name='Host CPU Utilization (%)' and group_id=2 ) prcnt,
              ( select sum(value) cpu_count from gv$parameter where name='cpu_count' )  parameter
          union
             select
               'CPU_ORA_DEMAND'                                            CLASS,
               nvl(round( sum(decode(session_state,'ON CPU',1,0))/60,2),0) AAS,
               cast(min(SAMPLE_TIME) as date) BEGIN_TIME ,
               cast(max(SAMPLE_TIME) as date) END_TIME
             from gv$active_session_history ash
              where SAMPLE_TIME >= (select min(BEGIN_TIME) begin_time from gv$sysmetric where metric_name='CPU Usage Per Sec' and group_id=2 )
               and SAMPLE_TIME < (select max(END_TIME) end_time from gv$sysmetric where metric_name='CPU Usage Per Sec' and group_id=2 )
               )
            )
          )
          unpivot ( aas for class in (CPU_TOTAL,cpu_os,cpu_ora,cpu_ora_wait))
)
select x.* from(
select a.*  from aasstat A
UNION ALL
SELECT w.* from aas_wait w
union all
select d.begin_time,d.end_time, 'CPU Cores' CLASS, c.cpu_core_count AAS from ( select * from aasstat where rownum = 1) d, cores c
) x
