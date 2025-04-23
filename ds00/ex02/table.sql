DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    event_time TIMESTAMP NOT NULL,
    event_type VARCHAR,
    product_id INTEGER,
    price REAL,
    user_id INTEGER,
    user_session VARCHAR
);
SELECT * from customers;

COPY customers(event_time, event_type, product_id, price, user_id, user_session)
    FROM '/usr/src/app/ds00/assets/customer/data_2022_dec.csv' DELIMITER ',' csv HEADER;

SELECT * from customers ORDER BY id DESC LIMIT 1;