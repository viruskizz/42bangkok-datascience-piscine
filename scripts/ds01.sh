#!/bin/bash
# Ex00
psql -h localhost\
    -d $POSTGRES_DB\
    -U $POSTGRES_USER \
    -f ds01/ex00/customers_table.sql