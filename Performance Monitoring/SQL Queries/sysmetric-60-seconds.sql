SELECT inst_id,
  last_value(END_TIME ignore nulls) over (order by END_TIME) END_TIME,
  METRIC_NAME,
  value
FROM
  (SELECT INST_ID,
    END_TIME,
    METRIC_NAME,
    ROUND(VALUE,1) value,
    METRIC_UNIT
  FROM sys.GV_$SYSMETRIC
  WHERE group_id   = 2
  AND END_TIME > ?
  AND metric_name IN ('Host CPU Utilization (%)','CPU Usage Per Sec','Host CPU Usage Per Sec','Average Active Sessions','Database Time Per Sec', 'Executions Per Sec','Hard Parse Count Per Sec','Logical Reads Per Sec','Logons Per Sec', 'Physical Read Total Bytes Per Sec','Physical Read Total IO Requests Per Sec','Physical Reads Per Sec','Physical Write Total Bytes Per Sec', 'Redo Generated Per Sec','User Commits Per Sec','Current Logons Count','DB Block Gets Per Sec','DB Block Changes Per Sec', 'Database Wait Time Ratio','Database CPU Time Ratio','SQL Service Response Time','Background Time Per Sec', 'Physical Write Total IO Requests Per Sec','Physical Writes Per Sec','Physical Writes Direct Per Sec','Physical Writes Direct Lobs Per Sec', 'Physical Reads Direct Per Sec','Physical Reads Direct Lobs Per Sec', 'GC CR Block Received Per Second','GC Current Block Received Per Second','Global Cache Average CR Get Time','Global Cache Average Current Get Time', 'Global Cache Blocks Corrupted'
    ,'Global Cache Blocks Lost', 'Active Parallel Sessions','Active Serial Sessions','Average Synchronous Single-Block Read Latency', 'Response Time Per Txn','SQL Service Response Time' )
  UNION ALL
  SELECT inst_id,
    NULL END_TIME,
    'CPU_COUNT' metric_name,
    SUM(value) value,
    NULL metric_unit
  FROM gv$parameter
  WHERE name='cpu_count'
  GROUP BY inst_id
  )
ORDER BY END_TIME ASC
