SELECT *
  FROM (
        select (extended_timestamp at TIME zone 'UTC') extended_timestamp_utc, t.* 
          from dba_audit_trail t)
          -- consider adding where extended_timestamp >= (systimestamp - 30 ) if there is an index on that column 
 WHERE ( extended_timestamp_utc >= (systimestamp - 30 ))
 ORDER BY extended_timestamp_utc ASC;
