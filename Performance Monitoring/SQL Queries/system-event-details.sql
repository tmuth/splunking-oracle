-- System event by wait_class including details. 
SELECT inst_id,
        wait_class,event,
         SUM(time_waited) time_waited
FROM gv$system_event
WHERE wait_class != 'Idle'
GROUP BY  inst_id,wait_class,event
UNION
SELECT inst_id,
         'CPU' wait_class,'CPU' event,value/10000 time_waited
FROM gV$sys_time_model
WHERE stat_name = 'DB CPU'
