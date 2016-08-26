Troubleshooting challenge
=========================

After we got everything to work, let's destroy the clusters!!

<img src="bombnag.jpg" alt="clone" width="100%;"/>
[&copy; trumanlibrary.org](http://www.trumanlibrary.org/teacher/abomb.htm)

**Idea:** I will run a script that will break something in
your Ceph cluster, possibly different for each one of you.
Try to troubleshoot the problems and fix them.

#### Troubleshooting strategies

* check the logs on each node in /var/log/ceph
* use the admin daemon sockets on each node to view and modify runtime configuration or get different statistics:

        sudo ceph --admin-daemon /var/run/ceph/ceph-osd.0.asok config show
        sudo ceph --admin-daemon /var/run/ceph/ceph-osd.0.asok config set debug_osd 1/10 # log/memory level
        sudo ceph --admin-daemon /var/run/ceph/ceph-mon.ceph-1.asok mon_status
  
* use *ceph health detail* to get more information about the problems your
  cluster is facing, e.g. IDs of degraded placement groups
* get more info on problematic PGs with:

        ceph pg <pgid> query

* explicitly list different stuck PGs with

        ceph pg dump_stuck stale     # possible cause: OSD not running
        ceph pg dump_stuck inactive  # peering problem
        ceph pg dump_stuck unclean   # unfound objects

* missing objects can be listed with

        ceph pg <pgid> list_missing

* if nothing more can be done about missing objects, it's time to let them go:

        ceph pg <pgid> mark_unfound_lost revert|delete

* similar for OSDs, if there is a catastrophic disk failure and it cannot be
  recovered:

        ceph osd lost <id>

* inconsistent PGs can be fixed with

        ceph pg repair <pgid>

Don't forget the Ceph docs at <http://docs.ceph.com/docs/master/>.

#### Bonus

If you're having too much fun troubleshooting your Ceph cluster, but you fixed
all the issues, pair up with another workshop participant to attack each
other's clusters and then try to fix the issues.
