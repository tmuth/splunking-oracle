CREATE OR REPLACE PROCEDURE ref_cur_test(
  p_ref_cursor  OUT SYS_REFCURSOR, p_var_in IN VARCHAR)
AS
BEGIN
 OPEN p_ref_cursor FOR
 SELECT 'you passed-in: '|| p_var_in out_var FROM dual;
END ref_cur_test;
/
-- test it from sqlplus / SQL Dev

set serveroutput on
DECLARE
  l_cursor  SYS_REFCURSOR;
  l_var   varchar2(255);
BEGIN
  ref_cur_test (p_var_in    => 'Foo',
          p_ref_cursor => l_cursor);

  LOOP
    FETCH l_cursor
    INTO  l_var;
    EXIT WHEN l_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(l_var);
  END LOOP;
  CLOSE l_cursor;
END;
/


-- this one takes in a timestamp data type
CREATE OR REPLACE PROCEDURE ref_cur_date_test(
  p_ref_cursor  OUT SYS_REFCURSOR, p_var_in IN timestamp)
AS
BEGIN
 OPEN p_ref_cursor FOR
 SELECT 'you passed-in: '|| p_var_in out_var FROM dual;
END ref_cur_date_test;
/
