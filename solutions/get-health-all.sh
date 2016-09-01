#!/bin/bash

function print_health {
    echo -n "[cluster $1]..."
    ssh -o StrictHostKeyChecking=no root@ceph-$1-5 'ceph health'
}

for userid in `seq 1 21`; do
    print_health $userid
done
