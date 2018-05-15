create user audit_mgt identified by welcome1 default tablespace users temporary tablespace temp;
grant connect, create session, audit_admin,create synonym,create procedure to audit_mgt;

create user audit_reader identified by welcome1 default tablespace users temporary tablespace temp;
grant connect, create session, audit_viewer,create synonym to audit_reader;
