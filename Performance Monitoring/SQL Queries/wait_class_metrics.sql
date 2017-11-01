with cpus AS
    (SELECT inst_id,
         sum(value) cpu_count
    FROM gv$parameter
    WHERE name='cpu_count'
    GROUP BY  inst_id)
SELECT a.*,
         c.cpu_count
FROM
    (SELECT m.BEGIN_TIME,
         m.inst_id,
         n.wait_class,
         round(m.time_waited/m.INTSIZE_CSEC,
         3) AAS
    FROM gv$waitclassmetric m, gv$system_wait_class n
    WHERE m.wait_class_id=n.wait_class_id
            AND n.wait_class != 'Idle'
    UNION
    select begin_time,inst_id,'DB CPU' wait_class, round(value/100,3) AAS
    FROM gv$sysmetric
    WHERE metric_name='CPU Usage Per Sec'
            AND group_id=2) a, cpus c
WHERE a.inst_id = c.inst_id
        AND BEGIN_TIME > ?
ORDER BY  BEGIN_TIME
