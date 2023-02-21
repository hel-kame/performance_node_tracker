#!/bin/bash

set -eu -o pipefail
sudo -n true
test $? -eq 0 || exit 1 "You should have sudo privilege to run this script."

if pgrep -x pathfinder > /dev/null
then
    PNAME="pathfinder"
elif pgrep -x juno > /dev/null
then
    PNAME="juno"
elif pgrep -x papyrus > /dev/null
then
    PNAME="papyrus"
else
    echo "No node is currently running."
    exit 1
fi

if [ ! -f "tracker.log" ];
then
	echo -e "\t\t%CPU\t%MEM\tkb_RD/s\tkb_WR/s\tPID\tPROCESS" > tracker.log
fi

if date | grep "PM" > /dev/null
then
	CPU_USAGE=$(pidstat -u -C ${PNAME} | awk 'NR == 4 {print $9}')
	RAM_USAGE=$(pidstat -r -C ${PNAME} | awk 'NR == 4 {print $9}')
	RD_USAGE=$(pidstat -d -C ${PNAME} | awk 'NR == 4 {print $5}')
	WR_USAGE=$(pidstat -d -C ${PNAME} | awk 'NR == 4 {print $6}')
else
	CPU_USAGE=$(pidstat -u -C ${PNAME} | awk 'NR == 4 {print $8}')
	RAM_USAGE=$(pidstat -r -C ${PNAME} | awk 'NR == 4 {print $8}')
	RD_USAGE=$(pidstat -d -C ${PNAME} | awk 'NR == 4 {print $4}')
	WR_USAGE=$(pidstat -d -C ${PNAME} | awk 'NR == 4 {print $5}')
fi
	TOTAL_CPU=$(tail tracker.log -n +2 | awk '{print $3}' | paste -sd+ | bc)
	AVERAGE_CPU=$(echo ${TOTAL_CPU} / $(tail tracker.log -n +2 | wc -l) | bc)

echo -e "$(date +%X)\t${CPU_USAGE}\t${RAM_USAGE}\t${RD_USAGE}\t${WR_USAGE}\t$(pidof ${PNAME})\t${PNAME}\n" >> tracker.log
cat tracker.log
