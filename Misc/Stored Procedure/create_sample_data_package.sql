drop table sample_data_temp;

CREATE GLOBAL TEMPORARY TABLE sample_data_temp (
  id            NUMBER,
  created_on    date,
  random_number number
)
on commit preserve rows;

create or replace package sample_pkg as
    TYPE sample_data_tbl is table of sample_data%ROWTYPE;
    TYPE refcur_t IS REF CURSOR RETURN sample_data%ROWTYPE;

    function get_sample_data(p_min_id IN NUMBER) return sample_data_tbl
      pipelined;

    function get_sample_data_dml(p_min_id IN NUMBER) return sample_data_tbl
      pipelined;

    function get_sample_data_ref_cur(p IN refcur_t) return sample_data_tbl
      pipelined;
end;
/

create or replace package body sample_pkg as
  function get_sample_data(p_min_id IN NUMBER) return sample_data_tbl
    PIPELINED as
    cursor sample_data_cur is
      SELECT * FROM sample_data where id > p_min_id order by id asc;
  begin
    for current_row in sample_data_cur loop
      pipe row(current_row);
    end loop;
  end get_sample_data;

  function get_sample_data_dml(p_min_id IN NUMBER) return sample_data_tbl
    PIPELINED as
    PRAGMA AUTONOMOUS_TRANSACTION;
    cursor sample_data_cur is
      SELECT * FROM sample_data_temp where id > p_min_id order by id asc;
  begin
    execute immediate 'delete from sample_data_temp';
    insert into sample_data_temp select * from sample_data where id > p_min_id;
    -- other DML here
    commit;

    for current_row in sample_data_cur loop
      pipe row(current_row);
    end loop;

    return;
  end get_sample_data_dml;


  function get_sample_data_ref_cur(p IN refcur_t) return sample_data_tbl
    PIPELINED is
    in_rec p%rowtype;

  begin
    loop
        FETCH p INTO in_rec;  -- input row
        EXIT WHEN p%NOTFOUND;
        pipe row(in_rec);
    end loop;
    close p;
    return;
  end get_sample_data_ref_cur;

end sample_pkg;
/

-- SELECT * from TABLE( sample_pkg.get_sample_data(100));

-- SELECT * from TABLE( sample_pkg.get_sample_data_dml(100));

-- SELECT * from TABLE( sample_pkg.get_sample_data_ref_cur(
--    cursor(select * from sample_data where id > 100))
--    );


-- | dbxquery connection="splunk_test_db12" query="SELECT * from TABLE( sample_pkg.get_sample_data(100))"
-- | dbxquery connection="splunk_test_db12" query="SELECT * from TABLE( sample_pkg.get_sample_data_dml(100))"
-- | dbxquery connection="splunk_test_db12" query="SELECT * from TABLE( sample_pkg.get_sample_data_ref_cur(cursor(select * from sample_data where id > 100)))"
