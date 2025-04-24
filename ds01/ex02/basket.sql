-- SELECT COUNT(*) FROM customers;

-- SELECT COUNT(*) FROM (
--     SELECT event_time, event_type, product_id, count(event_time)
--     FROM customers
--     GROUP BY event_time, event_type, product_id
--     HAVING count(event_time) > 1
-- );

SELECT event_time FROM (
    SELECT event_time FROM (
        SELECT
            event_time,
            ROW_NUMBER() OVER(
                PARTITION BY product_id, event_type, event_time
                ORDER BY event_time
            ) AS row_num
        FROM customers
    ) as t
    WHERE t.row_num > 1
) LIMIT 10;