#!/bin/bash

run_psql () {
    FILE=$1
    psql -h localhost \
         -d $POSTGRES_DB \
         -U $POSTGRES_USER \
         -f $FILE $@
}

run_psql ds03/assets/prepare.sql \
    -v table=test_knight \
    -v filename=/usr/src/app/ds03/assets/Test_knight.csv

run_psql ds03/assets/prepare.sql \
    -v table=train_knight \
    -v filename=/usr/src/app/ds03/assets/Train_knight.csv
