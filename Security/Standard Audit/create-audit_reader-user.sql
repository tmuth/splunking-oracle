-- USER SQL
CREATE USER audit_reader IDENTIFIED BY welcome1
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS
ALTER USER audit_reader QUOTA UNLIMITED ON USERS;

-- ROLES
GRANT "CONNECT" TO audit_reader ;

-- SYSTEM PRIVILEGES
GRANT CREATE SESSION TO audit_reader ;

grant select on dba_audit_trail,dba_common_audit_trail to audit_reader;
