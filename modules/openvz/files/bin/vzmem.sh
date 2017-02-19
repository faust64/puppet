#!/bin/sh

# Give the % of the total memory used by vm
# Example : vzmem.sh | sort -rn

for VEID in `vzlist -H -o veid`
do
    echo -n `vzcalc $VEID | tail -1 | awk '{print $2}'`
    echo -ne "\t"
    grep ^NAME= /etc/vz/conf/$VEID.conf | cut -d\" -f2
done
