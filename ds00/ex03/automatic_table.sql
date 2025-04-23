-- Create Table
CREATE OR REPLACE PROCEDURE create_table(table_name VARCHAR) AS $$
BEGIN
    RAISE NOTICE 'Creating Table %', table_name;
    EXECUTE format('DROP TABLE IF EXISTS %I', table_name);
    EXECUTE format('
        CREATE TABLE %I (
            event_time TIMESTAMP NOT NULL,
            event_type VARCHAR,
            product_id INTEGER,
            price REAL,
            user_id INTEGER,
            user_session UUID
        )', table_name);
    RAISE NOTICE '% Table created', table_name;
    EXECUTE format('SELECT * FROM %I', table_name);
END; $$ LANGUAGE plpgsql;

-- Import Items
CREATE OR REPLACE PROCEDURE import_items(table_name TEXT, filename TEXT) AS $$
DECLARE
    count INTEGER;
    columns TEXT := 'event_time, event_type, product_id, price, user_id, user_session';
BEGIN
    RAISE NOTICE 'Importing data from %s file to %s', filename, table_name;
    EXECUTE format('
        COPY %I(%s) FROM %L DELIMITER '','' csv HEADER
        ', table_name, columns, filename);
    EXECUTE format('SELECT COUNT(event_time) FROM %I', table_name) into count;
    RAISE NOTICE '% has been imported', count;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE main(dirpath TEXT) AS $$
DECLARE
    filename TEXT;
    fullname TEXT;
    table_name TEXT;
BEGIN
    RAISE NOTICE 'Listing directory: %', dirpath;
    FOR filename IN SELECT * FROM pg_ls_dir(dirpath)
    LOOP
        IF filename ~ '\.csv$' THEN
            table_name := regexp_replace(filename, '\.csv$', '', 'g');
            fullname := CONCAT(dirpath, filename);
            CALL create_table(table_name);
            CALL import_items(table_name, fullname);
            EXECUTE format('SELECT * from %I LIMIT 10', table_name);
        ELSE
            RAISE WARNING '% is not .csv file', filename;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL main(:'dirpath');