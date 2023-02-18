#!/bin/bash

PNAME="juno"
LOG_FILE="log_juno_cpu.txt"

echo "$(date) :: $PNAME[$(pidof ${PNAME})] $(ps -C ${PNAME} -o %cpu | tail -1)%" >> $LOG_FILE
