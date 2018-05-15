create or replace package unified_audit_mgt as 

    g_retain_days_in_db constant number := 7; -- how many days of data to keep in the db

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
    PROCEDURE log_action(
        p_ref_cursor    OUT SYS_REFCURSOR, 
        p_message       IN varchar2);
    
    procedure purge_audit_logs(
        p_latest_splunk_date in timestamp);
        
    procedure purge_audit_logs(
        p_ref_cursor    OUT SYS_REFCURSOR,
        p_latest_splunk_date in timestamp);
  

end unified_audit_mgt;