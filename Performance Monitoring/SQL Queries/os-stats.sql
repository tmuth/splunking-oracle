-- Operating System Statistics
SELECT INST_ID,
  STAT_NAME,
  round(VALUE,2) VALUE,
  --COMMENTS,
  CUMULATIVE
FROM sys.GV_$OSSTAT
order by inst_id, stat_name
