Reliability Exercises
=====================

## Probability of disk failures

Assume that we have a Ceph cluster with 1000 OSDs (1 disk per OSD). Given a
disk's independent annual failure probability of 5% and assuming there are no
correlated failures, calculate the following:

  * the probability that all disks work continuously for 2 years
  * the probability that after 2 years, half of the disks will still work
  * the probability that at least one disk will fail after 2 years
  * the probability that all disks have failed after 2 years

## Redundancy for data durability

Having seen that failures in a large storage system are inevitable, let's now
use replication or erasure codes to mitigate these issues.

We want to calculate the level of redundancy needed to ensure a 99.99999999% data durability, equivalent to a probability of
data loss as small as 10^-8.

Assume that we have again a Ceph cluster with 1000 OSDs. We make the following assumptions:

  * a disk has an independent annual probability of failure of 5%
  * all failures are independent
  * it takes approximately 1 hour to recover from the loss of an OSD (this
    depends on many factors, such as amount of data stored, network
    performance, various Ceph settings)
  * any OSD participates in 100 placement groups (this is sometimes called a
    declustering factor; recall the [PG calculator](operate.md)!)

Let's first calculate the probability of data loss when we use a replication
level of 2:

  * calculate the probability of a disk failing in a 1 hour interval
  * calculate the probability that another disk fails before the first disk is
    recovered
  * calculate the probability that a PG is lost

Now use the same procedure to find the required replication level to ensure
data durability of 99.99999999%.

### Bonus

Use the same procedure to calculate the k and m values needed when using only
erasure coded pools, in order to ensure the same reliability.

[Finally: Troubleshooting challenge >>>](troubleshooting.md)
