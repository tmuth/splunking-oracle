SELECT *
FROM
  (SELECT CAST((event_timestamp at TIME zone 'UTC') AS TIMESTAMP) event_timestamp_utc,
    u.*
  FROM UNIFIED_AUDIT_TRAIL u
  )
WHERE ( EVENT_TIMESTAMP_UTC >= ? )
ORDER BY EVENT_TIMESTAMP_UTC ASC;
