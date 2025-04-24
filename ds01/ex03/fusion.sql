CREATE OR REPLACE PROCEDURE add_column(tb VARCHAR, col VARCHAR, tp VARCHAR) AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = tb AND column_name = col
    ) THEN
        RAISE NOTICE '% added to %', col, tb;
        EXECUTE format('ALTER TABLE %I ADD COLUMN %I %s', tb, col, tp);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Merge Tables
CREATE OR REPLACE PROCEDURE merge_customer_item() AS $$
DECLARE
    src_table TEXT := 'item';
    tgt_table TEXT := 'customers';
    row_count INTEGER;
BEGIN
    RAISE NOTICE 'Merging % to %', src_table, tgt_table;
    EXECUTE format('
        MERGE INTO %I tgt
        USING (
            SELECT * FROM %I
            WHERE category_id IS NOT NULL
            AND category_code IS NOT NULL
            AND brand IS NOT NULL 
        ) src
        ON tgt.product_id = src.product_id
        WHEN MATCHED THEN
            UPDATE SET
                category_id = src.category_id,
                category_code = src.category_code,
                brand = src.brand
        ', tgt_table, src_table);

    GET DIAGNOSTICS row_count = ROW_COUNT;
    RAISE NOTICE '% has been merged to %', row_count, tgt_table;
END; $$ LANGUAGE plpgsql;

CALL add_column('customers', 'category_id', 'BIGINT');
CALL add_column('customers', 'category_code', 'VARCHAR');
CALL add_column('customers', 'brand', 'VARCHAR');
CALL merge_customer_item();