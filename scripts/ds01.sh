#!/bin/bash
# Ex01
psql -h localhost \
    -d $POSTGRES_DB \
    -U $POSTGRES_USER \
    -f ex01/customers_table.sql

psql -h localhost \
    -d $POSTGRES_DB\
    -U $POSTGRES_USER \
    -f ex02/remove_duplicates.sql

psql -h localhost \
    -d $POSTGRES_DB \
    -U $POSTGRES_USER \
    -f ex03/fusion.sql

