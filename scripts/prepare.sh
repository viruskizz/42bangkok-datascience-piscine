#!/bin/bash

run_psql () {
    FILE=$1
    psql -h localhost \
         -d $POSTGRES_DB \
         -U $POSTGRES_USER \
         -f $FILE $@
}

run_psql ds00/ex03/automatic_table.sql  -v dirpath=/usr/src/app/ds00/assets/customer/
run_psql ds00/ex04/items_table.sql      -v dirpath=/usr/src/app/ds00/assets/item/
run_psql ds01/ex01/customers_table.sql
run_psql ds01/ex02/remove_duplicates.sql
run_psql ds01/ex03/fusion.sql
