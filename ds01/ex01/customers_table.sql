-- Create Table
CREATE OR REPLACE PROCEDURE create_table(table_name VARCHAR) AS $$
BEGIN
    RAISE NOTICE 'Creating Table %', table_name;
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
    -- EXECUTE format('
    --     CREATE INDEX idx_customers_event_time ON %I(event_time)
    -- ', table_name)
    RAISE NOTICE '% Table created', table_name;
    EXECUTE format('SELECT * FROM %I', table_name);
END; $$ LANGUAGE plpgsql;

-- Merge Tables
CREATE OR REPLACE PROCEDURE merge_tables(source_pattern VARCHAR, target_table VARCHAR) AS $$
DECLARE
    tb RECORD;
    count INTEGER;
BEGIN
    FOR tb IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname='public'
            AND tablename LIKE source_pattern
            AND tablename != target_table
    LOOP
        RAISE NOTICE 'Merging %s to %s', tb.tablename, target_table;
        EXECUTE format('INSERT INTO %I SELECT * FROM %I', target_table, tb.tablename);
    END LOOP;
    EXECUTE format('SELECT COUNT(product_id) FROM %I', target_table) into count;
    RAISE NOTICE '% has been merged to %s', count, target_table;
END; $$ LANGUAGE plpgsql;

-- Main
CALL create_table('customers');
CALL merge_tables('data_%', 'customers');