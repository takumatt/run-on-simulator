#!/bin/bash

cat $1
cat $2

if [ $# -ne 2 ]; then
    echo "Usage: $CMDNAME UDID"
    exit 1
fi

exit 0

