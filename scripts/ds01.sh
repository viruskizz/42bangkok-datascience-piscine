#!/bin/bash
# Ex01
psql -h localhost\
    -d $POSTGRES_DB\
    -U $POSTGRES_USER \
    -f ds01/ex01/customers_table.sql