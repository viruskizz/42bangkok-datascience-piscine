#!/bin/bash
# EX03
psql -h localhost\
    -d $POSTGRES_DB\
    -U $POSTGRES_USER \
    -f ds00/ex03/automatic_table.sql \
    -v dirpath=/usr/src/app/ds00/assets/customer/

# EX04
psql -h localhost\
    -d $POSTGRES_DB\
    -U $POSTGRES_USER \
    -f ds00/ex04/items_table.sql \
    -v dirpath=/usr/src/app/ds00/assets/item/