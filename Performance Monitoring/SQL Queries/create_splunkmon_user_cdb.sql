CREATE USER c##splunk_monitor IDENTIFIED BY welcome1 CONTAINER=ALL
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS
ALTER USER c##splunk_monitor QUOTA UNLIMITED ON USERS;

-- ROLES
GRANT "SELECT_CATALOG_ROLE" TO c##splunk_monitor ;
GRANT "CONNECT" TO c##splunk_monitor ;
