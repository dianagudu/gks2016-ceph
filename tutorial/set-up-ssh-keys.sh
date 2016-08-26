#!/bin/bash

ssh-keygen -t rsa -f .ssh/id_rsa -N ''

studentid=`cat studentid`

sshpass -f password ssh-copy-id -o StrictHostKeyChecking=no gks@ceph-${studentid}-1
sshpass -f password ssh-copy-id -o StrictHostKeyChecking=no gks@ceph-${studentid}-2
sshpass -f password ssh-copy-id -o StrictHostKeyChecking=no gks@ceph-${studentid}-3
sshpass -f password ssh-copy-id -o StrictHostKeyChecking=no gks@ceph-${studentid}-4
sshpass -f password ssh-copy-id -o StrictHostKeyChecking=no gks@ceph-${studentid}-5
