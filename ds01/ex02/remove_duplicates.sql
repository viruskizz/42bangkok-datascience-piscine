CREATE OR REPLACE FUNCTION get_duplicated_count()
RETURNS INTEGER
LANGUAGE plpgsql AS $$
DECLARE
   count_result INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO count_result
    FROM (
        SELECT event_time, event_type, product_id, count(event_time)
        FROM customers
        GROUP BY event_time, event_type, product_id
        HAVING count(event_time) > 1
    );
    RETURN count_result;
END;
$$;

-- Remove Duplicated Row
CREATE OR REPLACE PROCEDURE remove_duplicates(table_name VARCHAR) AS $$
DECLARE
    iteration INTEGER := 0;
    rows_deleted INTEGER := 0;
    total_deleted INTEGER := 0;
BEGIN
    RAISE NOTICE 'Start to remove all duplicated';
    LOOP
        EXECUTE format(
            $f$
            WITH duplicates AS (
                SELECT ctid
                FROM (
                    SELECT ctid,
                           ROW_NUMBER() OVER (
                               PARTITION BY product_id, event_type, event_time
                               ORDER BY event_time
                           ) AS row_num
                    FROM %I
                ) sub
                WHERE row_num > 1
                LIMIT 500
            )
            DELETE FROM %I
            WHERE ctid IN (SELECT ctid FROM duplicates)
            $f$, table_name, table_name
        );
        GET DIAGNOSTICS rows_deleted = ROW_COUNT;

        iteration := iteration + 1;
        total_deleted := total_deleted + rows_deleted;
        RAISE NOTICE '[%] removed % > % total', iteration, rows_deleted, total_deleted;
        -- EXIT WHEN iteration = 10;
        EXIT WHEN rows_deleted = 0;
    END LOOP;
    RAISE NOTICE 'Removed all duplicated';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE remove_closeto(table_name VARCHAR) AS $$
DECLARE
    iteration INTEGER := 0;
    rows_deleted INTEGER := 0;
    total_deleted INTEGER := 0;
BEGIN
    LOOP
        WITH to_delete AS (
            SELECT a.ctid
            FROM customers a
            JOIN customers b
              ON a.ctid <> b.ctid
              AND a.product_id = b.product_id
              AND a.event_type = b.event_type
              AND b.event_time = a.event_time + INTERVAL '1 second' -- Faster than epoch
            LIMIT 200
        )
        DELETE FROM customers
        WHERE ctid IN (SELECT ctid FROM to_delete);

        GET DIAGNOSTICS rows_deleted = ROW_COUNT;

        iteration := iteration + 1;
        total_deleted := total_deleted + rows_deleted;
        RAISE NOTICE '[%] removed % > % total', iteration, rows_deleted, total_deleted;
        -- EXIT WHEN iteration = 3;
        EXIT WHEN rows_deleted = 0;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL remove_duplicates('customers');
CALL remove_closeto('customers');
-- SELECT get_duplicated_count();