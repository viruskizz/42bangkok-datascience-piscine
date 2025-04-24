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

