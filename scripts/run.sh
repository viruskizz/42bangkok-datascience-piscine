#!/bin/bash
run_psql () {
    FILE=$1
    psql -h localhost \
         -d $POSTGRES_DB \
         -U $POSTGRES_USER \
         -f $FILE $@
}

run_psql $@