DO $$
DECLARE
    rows_deleted INT;
BEGIN
    LOOP
        WITH to_delete AS (
            SELECT a.ctid
            FROM customers a
            JOIN customers b
              ON a.ctid <> b.ctid
              AND a.product_id = b.product_id
              AND a.event_type = b.event_type
              AND EXTRACT(EPOCH FROM b.event_time - a.event_time) = 1
            LIMIT 500
        )
        DELETE FROM customers
        WHERE ctid IN (SELECT ctid FROM to_delete);

        GET DIAGNOSTICS rows_deleted = ROW_COUNT;
        RAISE NOTICE 'Deleted % rows', rows_deleted;

        EXIT WHEN rows_deleted = 0;
    END LOOP;
END
$$;

-- Backup
-- DO $$
-- DECLARE
--     rows_deleted INT;
-- BEGIN
--     LOOP
--         -- Delete up to 500 rows at a time
--         DELETE FROM customers a
--         USING customers b
--         WHERE a.ctid <> b.ctid
--           AND a.product_id = b.product_id
--           AND a.event_type = b.event_type
--           AND EXTRACT(EPOCH FROM b.event_time - a.event_time) = 1
--         LIMIT 500;

--         GET DIAGNOSTICS rows_deleted = ROW_COUNT;
--         RAISE NOTICE 'Deleted % rows', rows_deleted;

--         EXIT WHEN rows_deleted = 0;
--     END LOOP;
-- END
-- $$;