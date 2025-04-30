CREATE OR REPLACE FUNCTION get_duplicated_count()
RETURNS INTEGER
LANGUAGE plpgsql AS $$
DECLARE
   count_result INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO count_result
  FROM (
    SELECT t1.ctid
    FROM customers t1, customers t2
    WHERE  t1.ctid < t2.ctid
      AND  t1.event_time = t2.event_time
      AND  t1.event_type = t2.event_type
      AND  t1.product_id = t2.product_id
  );
  RETURN count_result;
END;
$$;

CREATE OR REPLACE FUNCTION get_closeto_count()
RETURNS INTEGER
LANGUAGE plpgsql AS $$
DECLARE
  count_result INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO count_result
  FROM (
    SELECT t1.ctid
    FROM customers t2
    JOIN customers t1
      ON t1.ctid <> t2.ctid
        AND t1.product_id = t2.product_id
        AND t1.event_type = t2.event_type
        AND  t2.event_time = t1.event_time + INTERVAL '1 second'
    ORDER BY t1.event_time ASC
  );
  RETURN count_result;
END;
$$;

CREATE OR REPLACE PROCEDURE remove_duplicates(table_name VARCHAR) AS $$
DECLARE
    dup_count INTEGER := 0;
    rows_deleted INTEGER := 0;
BEGIN
  RAISE NOTICE 'Removing all duplicates will take approximately 1 minute.';
  EXECUTE format(
    $f$
    DELETE FROM %I t1 USING %I t2
    WHERE t1.ctid < t2.ctid
      AND  t1.event_time = t2.event_time
      AND  t1.event_type = t2.event_type
      AND  t1.product_id = t2.product_id
    $f$, table_name, table_name
  );
  GET DIAGNOSTICS rows_deleted = ROW_COUNT;

  RAISE NOTICE 'Removed all duplicated % rows', rows_deleted;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE remove_closetoes(table_name VARCHAR) AS $$
DECLARE
  dup_count INTEGER := 0;
  rows_deleted INTEGER := 0;
BEGIN
  RAISE NOTICE 'Removing all clostoes will take approximately 1 minute.';
  EXECUTE format(
    $f$
    DELETE FROM %I t2 USING %I t1
    WHERE t1.ctid < t2.ctid
      AND  t1.event_type = t2.event_type
      AND  t1.product_id = t2.product_id
      AND  t2.event_time = t1.event_time + INTERVAL '1 second'
    $f$, table_name, table_name
  );
  GET DIAGNOSTICS rows_deleted = ROW_COUNT;

  RAISE NOTICE 'Removed all closetoes % rows', rows_deleted;
END;
$$ LANGUAGE plpgsql;

SELECT get_duplicated_count();
CALL remove_duplicates('customers');
SELECT get_closeto_count();
CALL remove_closetoes('customers');