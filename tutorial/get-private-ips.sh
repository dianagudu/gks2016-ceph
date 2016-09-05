#!/bin/bash

sudo apt-get install sshpass
ip1=`sshpass -f password ssh -o StrictHostKeyChecking=no <public IP ceph-1> "sudo ifconfig eth0 | grep 'inet addr' | awk -F'[ :]' '{print \\$13}'"`
ip2=`sshpass -f password ssh -o StrictHostKeyChecking=no <public IP ceph-2> "sudo ifconfig eth0 | grep 'inet addr' | awk -F'[ :]' '{print \\$13}'"`
ip3=`sshpass -f password ssh -o StrictHostKeyChecking=no <public IP ceph-3> "sudo ifconfig eth0 | grep 'inet addr' | awk -F'[ :]' '{print \\$13}'"`
ip4=`sshpass -f password ssh -o StrictHostKeyChecking=no <public IP ceph-4> "sudo ifconfig eth0 | grep 'inet addr' | awk -F'[ :]' '{print \\$13}'"`
ip5=`sshpass -f password ssh -o StrictHostKeyChecking=no <public IP ceph-5> "sudo ifconfig eth0 | grep 'inet addr' | awk -F'[ :]' '{print \\$13}'"`

studentid=`cat studentid`
echo $ip1 ceph-${studentid}-1 | sudo tee -a /etc/hosts 
echo $ip2 ceph-${studentid}-2 | sudo tee -a /etc/hosts 
echo $ip3 ceph-${studentid}-3 | sudo tee -a /etc/hosts 
echo $ip4 ceph-${studentid}-4 | sudo tee -a /etc/hosts 
echo $ip5 ceph-${studentid}-5 | sudo tee -a /etc/hosts 
