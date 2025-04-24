
-- Create Table
CREATE OR REPLACE PROCEDURE remove_duplicates(table_name VARCHAR) AS $$
DECLARE
    iteration INTEGER := 0;
    rows_deleted INTEGER := 0;
    total_deleted INTEGER := 0;
BEGIN
    RAISE NOTICE 'Start to remove all duplicated';
    LOOP
        WITH duplicates AS (
            SELECT ctid
            FROM (
                SELECT
                    ctid,
                    ROW_NUMBER() OVER (
                        PARTITION BY product_id, event_type, event_time
                        ORDER BY event_time
                    ) AS row_num
                FROM customers
            ) sub
            WHERE row_num > 1
            LIMIT 10
        )
        DELETE FROM customers
        WHERE ctid IN (SELECT ctid FROM duplicates);
        GET DIAGNOSTICS rows_deleted = ROW_COUNT;

        iteration = iteration + 1;
        total_delete = total_delete + rows_deleted
        RAISE NOTICE '[%] % > %', iteration, rows_deleted, total_deleted;
        EXIT WHEN iteration = 10;
    END LOOP;
    RAISE NOTICE 'Removed all duplicated';
END; $$ LANGUAGE plpgsql;

CALL remove_duplicates('customers')

-- SELECT 
--     a.event_time as a_event_time,
--     b.event_time as b_event_time,
--     a.product_id as product_id,
--     a.event_type as event_type
-- FROM customers as a
-- LEFT JOIN customers as b
--     ON a.product_id = b.product_id
--     AND a.event_type = b.event_type
--     AND a.event_time = b.event_time
-- WHERE EXTRACT(EPOCH FROM a.event_time - b.event_time) = 1
-- LIMIT 1000;

-- CREATE OR REPLACE FUNCTION count_dup() RETURNS INTEGER AS $$
-- DECLARE
--     count_result INTEGER;
-- BEGIN
    -- SELECT
    --     COUNT(*)
    -- FROM customers as a
    -- LEFT JOIN customers as b
    --     ON a.product_id = b.product_id
    --     AND a.event_type = b.event_type
    -- WHERE EXTRACT(EPOCH FROM a.event_time - b.event_time) = 0;
--     INTO count_result;

--     RETURN count_result;
-- END; $$ LANGUAGE plpgsql;

-- SELECT count_dup();

