create or replace package body unified_audit_mgt as

  procedure log_action(
        p_ref_cursor    out sys_refcursor, 
        p_message       in varchar2) as
  begin
    -- TODO: Implementation required for PROCEDURE UNIFIED_AUDIT_MGT.log_action
    logger.log(p_text   => p_message,
               p_scope  => 'unified_audit_mgt');
    OPEN p_ref_cursor FOR           
    SELECT p_message as messsage FROM dual;
  end log_action;
  
  procedure log_error(
        p_ref_cursor    out sys_refcursor, 
        p_message       in varchar2) as
  begin
    logger.log_error(p_text   => p_message,
               p_scope  => 'unified_audit_mgt');
    OPEN p_ref_cursor FOR           
    SELECT p_message as messsage FROM dual;
  end log_error;

  procedure purge_audit_logs(
        p_latest_splunk_date in timestamp) as
  begin
    -- TODO: Implementation required for procedure UNIFIED_AUDIT_MGT.purge_logs
    --dbms_audit_mgmt.set_last_archive_timestamp(audit_trail_type=>dbms_audit_mgmt.audit_trail_unified,last_archive_time=>sysdate-365);

    --dbms_audit_mgmt.clean_audit_trail(audit_trail_type=>dbms_audit_mgmt.audit_trail_unified,use_last_arch_timestamp=>TRUE);
    null;
    logger.log(p_text   => 'Yep, it worked.',
               p_scope  => 'unified_audit_mgt');
  end purge_audit_logs;
  
  procedure purge_audit_logs(
        p_ref_cursor    OUT SYS_REFCURSOR,
        p_latest_splunk_date in timestamp) 
  as
    l_message varchar2(2000);
    l_arch_timestamp timestamp;
  begin
  
    l_arch_timestamp := p_latest_splunk_date - g_retain_days_in_db;
    
    dbms_audit_mgmt.set_last_archive_timestamp(audit_trail_type=>dbms_audit_mgmt.audit_trail_unified,last_archive_time=>l_arch_timestamp);

    dbms_audit_mgmt.clean_audit_trail(audit_trail_type=>dbms_audit_mgmt.audit_trail_unified,use_last_arch_timestamp=>TRUE);
    
    l_message := 'Timstamp from Splunk: '||p_latest_splunk_date||'. Days to retain: '||g_retain_days_in_db;
    log_action(p_ref_cursor => p_ref_cursor,p_message => l_message);
    
  end purge_audit_logs;


end unified_audit_mgt;