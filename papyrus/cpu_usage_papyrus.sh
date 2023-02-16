#!/bin/bash

PNAME="papyrus_node"
LOG_FILE="log_papyrus_cpu.txt"

echo "$(date) :: $PNAME[$(pidof ${PNAME})] $(ps -C ${PNAME} -o %cpu | tail -1)%" >> $LOG_FILE
