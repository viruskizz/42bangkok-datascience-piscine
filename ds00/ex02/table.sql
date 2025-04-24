DO $$
DECLARE
    filename TEXT := '/usr/src/app/ds00/assets/customer/data_2022_dec.csv';
    table_name TEXT := 'data_2022_dec';
    columns TEXT := 'event_time, event_type, product_id, price, user_id, user_session';
    count INTEGER;
BEGIN
    EXECUTE format('DROP TABLE IF EXISTS %I', table_name);
    EXECUTE format('
        CREATE TABLE %I (
            event_time TIMESTAMPTZ NOT NULL,
            event_type VARCHAR,
            product_id INTEGER,
            price REAL,
            user_id INTEGER,
            user_session UUID
        )', table_name);
    RAISE NOTICE '% Table created', table_name;
    EXECUTE format('
        COPY %I(%s) FROM %L DELIMITER '','' csv HEADER
    ', table_name, columns, filename);
    EXECUTE format('SELECT COUNT(event_time) FROM %I', table_name) into count;
    RAISE NOTICE '% has been imported', count;
END
$$;