-- https://docs.oracle.com/database/121/DBSEG/audit_config.htm#DBSEG1025
CREATE AUDIT POLICY all_actions_soe_cust_pol
 ACTIONS ALL ON soe.customers;

AUDIT POLICY all_actions_soe_cust_pol ;

-- AUDIT POLICY all_actions_soe_cust_pol by foo;

-- NOAUDIT POLICY all_actions_soe_cust_pol;
-- NOAUDIT POLICY all_actions_soe_cust_pol BY foo;
