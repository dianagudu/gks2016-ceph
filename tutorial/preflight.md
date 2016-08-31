Preparing the nodes
===================
We will use the ceph-deploy tool to deploy the Ceph cluster. First, we need to prepare the nodes for deployment.

To save some time, we already added the Ceph release key and repository to all
the machines, and preinstalled the Ceph packages. This was done with the
commands below:

    wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
    echo deb http://download.ceph.com/debian-jewel/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
    sudo apt-get update && sudo apt-get install ceph ceph-mds radosgw

The packages can be easily installed with ceph-deploy as well.

Connect to ceph-5, the admin node:

    ssh gks@<public ip ceph-5>

Install ceph-deploy:

    sudo apt-get install ceph-deploy

Now we need to setup passwordless ssh between the admin node and all other nodes, because the ceph-deploy tool needs to install packages without prompting for passwords.

Because of the Openstack deployment with floating IPs, we will use the private
network between the VMs for our Ceph cluster. 

* first, get the private IP of each VM by connecting to the public IP and executing:

        ifconfig

* on ceph-5, add the hostnames in /etc/hosts corresponding to these IPs:

        <private ip ceph-1>    ceph-1
        <private ip ceph-2>    ceph-2
        <private ip ceph-3>    ceph-3
        <private ip ceph-4>    ceph-4
        <private ip ceph-5>    ceph-5

**Note: Throughout this tutorial, you should use the hostnames of YOUR virtual machines.**

We will use the gks user to deploy the Ceph cluster, which already has sudo privileges without password required (root is NOT recommended):

* generate ssh keys on admin node

        ssh-keygen

* from the admin node, copy the key to each ceph node; use the passwords you received:

        ssh-copy-id gks@ceph-1
        ssh-copy-id gks@ceph-2
        ssh-copy-id gks@ceph-3
        ssh-copy-id gks@ceph-4
        ssh-copy-id gks@ceph-5

* now check that you can connect to the nodes without requiring a password or username:

        ssh ceph-1

Alternatively, we provide two scripts to make this process easier:

* [get-private-ips.sh](get-private-ips.sh?raw=true): connects to each machine using the
  public IP, gets the private IP and adds an entry in /etc/hosts
* [set-up-ssh-keys.sh](set-up-ssh-keys.sh?raw=true): creates a pair of ssh keys and
  adds the public key to each machine's authorized_hosts file

To run these scripts, you will need to save your studentid and password in files
named **studentid** and **password**, and add the public IPs you received.

**get-private-ips.sh**:

    #!/bin/bash
    
    sudo apt-get install sshpass
    ip1=`sshpass -f password ssh <public IP ceph-1> "sudo ifconfig eth0 | grep 'inet addr' | awk -F':| +' '{print \\$4}'"`
    ip2=`sshpass -f password ssh <public IP ceph-2> "sudo ifconfig eth0 | grep 'inet addr' | awk -F':| +' '{print \\$4}'"`
    ip3=`sshpass -f password ssh <public IP ceph-3> "sudo ifconfig eth0 | grep 'inet addr' | awk -F':| +' '{print \\$4}'"`
    ip4=`sshpass -f password ssh <public IP ceph-4> "sudo ifconfig eth0 | grep 'inet addr' | awk -F':| +' '{print \\$4}'"`
    ip5=`sshpass -f password ssh <public IP ceph-5> "sudo ifconfig eth0 | grep 'inet addr' | awk -F':| +' '{print \\$4}'"`
    
    studentid=`cat studentid`
    echo $ip1 ceph-${studentid}-1 | sudo tee -a /etc/hosts 
    echo $ip2 ceph-${studentid}-2 | sudo tee -a /etc/hosts 
    echo $ip3 ceph-${studentid}-3 | sudo tee -a /etc/hosts 
    echo $ip4 ceph-${studentid}-4 | sudo tee -a /etc/hosts 
    echo $ip5 ceph-${studentid}-5 | sudo tee -a /etc/hosts 

**set-up-ssh-keys.sh**:

    #!/bin/bash
    
    ssh-keygen -t rsa -f .ssh/id_rsa -N ''
    
    studentid=`cat studentid`
    
    sshpass -f password ssh-copy-id -o StrictHostKeyChecking=no gks@ceph-${studentid}-1
    sshpass -f password ssh-copy-id -o StrictHostKeyChecking=no gks@ceph-${studentid}-2
    sshpass -f password ssh-copy-id -o StrictHostKeyChecking=no gks@ceph-${studentid}-3
    sshpass -f password ssh-copy-id -o StrictHostKeyChecking=no gks@ceph-${studentid}-4
    sshpass -f password ssh-copy-id -o StrictHostKeyChecking=no gks@ceph-${studentid}-5

Next, we will learn how to deploy a Ceph cluster [>>>](deploy.md)
