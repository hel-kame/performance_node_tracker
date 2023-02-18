#!/bin/bash

PNAME="juno"
LOG_FILE="log_juno_ram.txt"

echo "$(date) :: $PNAME[$(pidof ${PNAME})] $(ps -C ${PNAME} -o %mem | tail -1)%" >> $LOG_FILE
