#!/bin/bash

## attack 1
## create bench pool, start writing to it and then stop one of the OSDs
## you will have some undersized+degraded PGs because the PG creation didn't
#finish before the OSD went down, with some PGs only being on 1 OSD
## FIX: restart OSD
##      ssh root@ceph-$1-3 'systemctl start ceph-osd@2'
## arguments: userid
function attack1 {
    echo -n 'Running attack #1 on cluster belonging to user '$1'...'
    # on ceph-5
    ssh -o StrictHostKeyChecking=no root@ceph-$1-5 -q -f 'ceph osd pool create bench 32; rados bench -p bench 10 write --no-cleanup' 2> /dev/null
    # on ceph-3
    ssh -o StrictHostKeyChecking=no root@ceph-$1-3 -q 'systemctl stop ceph-osd@2' 2> /dev/null
    echo '[done]'
}

## attack 2
## change replication level to something higher that the CRUSH rules allows
## first set the newly created crush ruleset for pool data
## change size of data pool to 3
## it will be impossible to replicate 3 times across racks, since we only have
#2 racks
## possible FIXes:
# * change ruleset to replicate across OSDs
# * change pool size to lower (2)
#   ceh osd pool set data size 2
# * add another rack (then add more OSDs or move existing OSDs to this rack)
## arguments: userid
function attack2 {
    echo -n 'Running attack #2 on cluster belonging to user '$1'...'
    # on ceph-5
    ssh -o StrictHostKeyChecking=no root@ceph-$1-5 -q '
        ceph osd pool set data crush_ruleset 1;
        ceph osd pool set data size 3 
    ' 2> /dev/null
    echo '[done]'
}

## attack 3
## add firewall rules to drop all packages except ssh
## FIX: (on ceph-$1-1
# * make inpput/output policies accept again
#   sudo iptables -P INPUT ACCEPT
#   sudo iptables -P OUTPUT ACCEPT
# * flush al rules
#   sudo iptables -F
## arguments: userid
function attack3 {
    echo -n 'Running attack #3 on cluster belonging to user '$1'...'
    # on ceph-1 monitor
    ssh -o StrictHostKeyChecking=no root@ceph-$1-1 -q '
        sudo iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT;
        sudo iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED,RELATED -j ACCEPT;
        sudo iptables -P INPUT DROP;
        sudo iptables -P OUTPUT DROP
    ' 2> /dev/null
    echo '[done]'
}

## attack4
## unfound objects
## the following sequence is executed:
# * we do some writes
# * during writing, osd 1 goes down
# * the other osds handle some writes alone
# * osd 1 comes up
# * osd 1 repeers with the other osds, and the missing objects are queued for
# recovery
# * before the new objects are copied, another osd goes down (osd 2)
## FIX
## arguments: userid
function attack4 {
    echo -n 'Running attack #4 on cluster belonging to user '$1'...'
    ssh -o StrictHostKeyChecking=no root@ceph-$1-5 -q -f '
        ceph osd pool create bench 32;
        rados bench -p bench 10 write --no-cleanup
    ' 2> /dev/null
    ssh -o StrictHostKeyChecking=no root@ceph-$1-2 -q '
        sudo systemctl stop ceph-osd@1
    ' 2> /dev/null
    sleep 3
    ssh -o StrictHostKeyChecking=no root@ceph-$1-2 -q '
        sudo systemctl start ceph-osd@1
    ' 2> /dev/null
    ssh -o StrictHostKeyChecking=no root@ceph-$1-3 -q '
        sudo systemctl stop ceph-osd@2
    ' 2> /dev/null
    echo '[done]'
}

## attack 5
## osd goes down and up repeteadly
# FIX:
# * sudo systemctl enable ceph-osd@0.service
# * sudo systemctl start ceph-osd@0
## arguments: userid
function attack5 {
    echo -n 'Running attack #5 on cluster belonging to user '$1'...'
    ssh -o StrictHostKeyChecking=no root@ceph-$1-1 -q '
        sudo systemctl stop ceph-osd@0;
        sudo systemctl start ceph-osd@0;
        sudo systemctl stop ceph-osd@0;
        sudo systemctl start ceph-osd@0;
        sudo systemctl stop ceph-osd@0;
        sudo systemctl start ceph-osd@0
    ' 2> /dev/null
    echo '[done]'
}

# list of users for attack1
users_attack_1='2 7 12'
# list of users for attack2
users_attack_2='3 8 13'
# list of users for attack3
users_attack_3='4 9 14'
# list of users for attack4
users_attack_4='5 10 15'
# list of users for attack5
users_attack_5='6 11 16'

for user in users_attack_1; do
    attack1 $user
done
for user in users_attack_2; do
    attack2 $user
done
for user in users_attack_3; do
    attack3 $user
done
for user in users_attack_4; do
    attack4 $user
done
for user in users_attack_5; do
    attack5 $user
done
