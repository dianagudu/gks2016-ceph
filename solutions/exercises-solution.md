Solutions for Reliability Exercises
===================================

## Probability of disk failures

  * the probability that all disks work continuously for 2 years

- probability of one disk working continuously for one year = 1 - annual failure
probability = 0.95
- probability of one disk working continuously for two years = 0.95 * 0.95 =
0.9025
- probability of all disks working continuously for two years = 0.9025^1000 =
  2.8e-45

  * the probability that after 2 years, half of the disks will still work

- similarly: 0.9025^500 = 5.291e-23

  * the probability that at least one disk will fail after 2 years

- 1 - probability that all disks will work after 2 years = 1 - 2.8e-45 = 1

  * the probability that all disks have failed after 2 years

- the probability of one disk failing after 2 years: 1 - the probability of
  the disk working continuously for two years = 1 - 0.9025 = 0.0975
- the probability that ALL disk fail after 2 years = 0.0975^1000 = 0

Failure is inevitable.

## Redundancy for data durability

Given:

  * independent annual probability of failure of 5% per disk
  * 1 hour recovery time
  * 100 PGs per OSD

For 2 replicas, calculate:

  * the probability of a disk failing in a 1 hour interval

- divide the annual rate by the number of hours in a year: 0.05/8760 = 5.7e-6

  * the probability that another disk fails before the first disk is recovered

- the same: 5.7e-6

  * the probability that a PG is lost

- the initial OSD participates in 100 PGs, so the chance that the second
  failed disk was in the same PG as the first disk and thus both replicas are
lost is 5.7e-6*100 = 5.7e-4

Now use the same procedure to find the required replication level to ensure
data durability of 99.99999999%.

- assuming n replicas, the probability that n-1 disks fail in the next hour
  while the first disk is recovering is: (5.7e-6)^(n-1)
- the probability of data loss is: (5.7e-6)^(n-1)*100
- this probability must be lower than 10^-8
- 5.7^(n-1) * 10^(-6n+8) <= 10^-8
- We find that n=3

### Bonus

Use the same procedure to calculate the k and m values needed when using only
erasure coded pools, in order to ensure the same reliability.
