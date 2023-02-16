#!/bin/bash

PNAME="papyrus_node"
LOG_FILE="log_papyrus_ram.txt"

echo "$(date) :: $PNAME[$(pidof ${PNAME})] $(ps -C ${PNAME} -o %mem | tail -1)%" >> $LOG_FILE
