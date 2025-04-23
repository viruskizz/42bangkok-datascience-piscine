#!/bin/bash
psql -h localhost \
    -d $POSTGRES_DB \
    -U $POSTGRES_USER