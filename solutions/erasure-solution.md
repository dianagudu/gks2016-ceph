Solution for erasure coding exercise
====================================

Experiment with fault tolerance by comparing what happens when one vs two OSDs
break:

* get the list of OSDs where object *ecfile* is placed

        gks@ceph-5:~$ ceph osd map ecpool ecfile
        osdmap e142 pool 'ecpool' (14) object 'ecfile' -> pg 14.5a3c29d8 (14.18) -> up ([2,1,3], p2) acting ([2,1,3], p2)

* to avoid automatic recovery from starting immediately after an OSD fails, set noout flag so that an OSD is not marked out whenever it is down:

        ceph osd set noout

* stop one OSD that holds the object

        gks@ceph-2:~$ sudo systemctl stop cephosd@1

* try to dowload the object from the Ceph cluster using *rados get*

        rados -p ecpool get ecfile obj-fail1
        diff ecfile obj-fail1

* stop a second OSD that holds the object

        gks@ceph-3:~$ sudo systemctl stop cephosd@2
    
* try to download the object again

        rados -p ecpool get ecfile obj-fail2

What do you observe?

    Downloading the file worked when 1 OSD broke down, but was hanging when the second OSD failed.

Can you explain why this happens?

    Due to our chosen ec profile (m=1), only one failure is tolerated.
    Increasing m would improve reliability.

* After this exercise, unset the noout flag:

        ceph osd unset noout

