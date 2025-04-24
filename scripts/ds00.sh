#!/bin/bash
# Ex02
psql -h localhost\
    -d $POSTGRES_DB\
    -U $POSTGRES_USER \
    -f ds00/ex02/table.sql

# Ex03
psql -h localhost\
    -d $POSTGRES_DB\
    -U $POSTGRES_USER \
    -f ex03/automatic_table.sql \
    -v dirpath=/usr/src/app/ds00/assets/customer/

# Ex04
psql -h localhost\
    -d $POSTGRES_DB\
    -U $POSTGRES_USER \
    -f ex04/items_table.sql \
    -v dirpath=/usr/src/app/ds00/assets/item/
