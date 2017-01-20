-- Sysmetric Stats - 60 second interval
select INST_ID,
  END_TIME,
  METRIC_NAME,
  round(VALUE,1) value,
  METRIC_UNIT
FROM sys.GV_$SYSMETRIC
-- group_id = 3 will return 15 second interval stats, but there are less of them
where group_id = 2
and metric_name in ('Host CPU Utilization (%)','CPU Usage Per Sec','Host CPU Usage Per Sec','Average Active Sessions','Database Time Per Sec',
 'Executions Per Sec','Hard Parse Count Per Sec','Logical Reads Per Sec','Logons Per Sec',
 'Physical Read Total Bytes Per Sec','Physical Read Total IO Requests Per Sec','Physical Reads Per Sec','Physical Write Total Bytes Per Sec',
 'Redo Generated Per Sec','User Commits Per Sec','Current Logons Count','DB Block Gets Per Sec','DB Block Changes Per Sec',
 'Database Wait Time Ratio','Database CPU Time Ratio','SQL Service Response Time','Background Time Per Sec',
 'Physical Write Total IO Requests Per Sec','Physical Writes Per Sec','Physical Writes Direct Per Sec','Physical Writes Direct Lobs Per Sec',
 'Physical Reads Direct Per Sec','Physical Reads Direct Lobs Per Sec',
 'GC CR Block Received Per Second','GC Current Block Received Per Second','Global Cache Average CR Get Time','Global Cache Average Current Get Time',
 'Global Cache Blocks Corrupted','Global Cache Blocks Lost',
 'Active Parallel Sessions','Active Serial Sessions','Average Synchronous Single-Block Read Latency',
 'Response Time Per Txn','SQL Service Response Time'
    )
