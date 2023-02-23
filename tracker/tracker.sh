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
elif pgrep -x papyrus_node > /dev/null
then
    PNAME="papyrus_node"
else
    echo "No node is currently running."
    exit 1
fi

if [ ! -f "tracker.log" ];
then
	echo -e "\t\t%CPU\t%MEM\tkb_RD/s\t\tkb_WR/s\t\tSNT/s\t\tRCD/s\t\tPID\tPROCESS" > tracker.log
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

if [ ! -f "data.tmp" ]
then
	sudo nethogs -t -c 2  > data.tmp
fi

if cat data.tmp | grep ${PNAME} > /dev/null
then
	DATA_SENT=$(cat data.tmp | grep ${PNAME} | awk '{print $2}')
	DATA_RECEIVED=$(cat data.tmp | grep ${PNAME} | awk '{print $3}')
	rm data.tmp
else
	DATA_SENT=$(echo -n "0")
	DATA_RECEIVED=$(echo -n "0")
	rm data.tmp
fi

round() {
  printf "%.${2}f" "${1}"
}

ROUND_DATA_SENT=$(round ${DATA_SENT} 2)
ROUND_DATA_RECEIVED=$(round ${DATA_RECEIVED} 2)

echo -e "$(date +%X)\t${CPU_USAGE}\t${RAM_USAGE}\t${RD_USAGE}\t\t${WR_USAGE}\t\t${ROUND_DATA_SENT}\t\t${ROUND_DATA_RECEIVED}\t\t$(pidof ${PNAME})\t${PNAME}" >> tracker.log
cat tracker.log
