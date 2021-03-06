# Cgroup

## 1. 基本操作

* Mount cgroup

  ```
  mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
  mount -t cgroup -o devices cgroup /sys/fs/cgroup/devices
  mount -t cgroup -o memory cgroup /sys/fs/cgroup/memory
  mount -t cgroup -o cpuset cgroup /sys/fs/cgroup/cpuset
  mount -t cgroup -o freezer cgroup /sys/fs/cgroup/freezer
  mount -t cgroup -o net_cls cgroup /sys/fs/cgroup/net_cls
  mount -t cgroup -o blkio cgroup /sys/fs/cgroup/blkio
  mount -t cgroup -o cpu,cpuacct cgroup /sys/fs/cgroup/cpu,cpuacct
  ```

  注：

  * Cgroup v1 named hierarchies

    > mount -t cgroup -o none,name=somename none /some/mount/point
    >
    > Multiple instances of such hierarchies can be mounted; each hierarchy must have a unique name.  The only purpose of such hierarchies is to track processes.  (See the discussion of release notification below.) An example of this is the name=systemd cgroup hierarchy that is used by systemd(1) to track services and user sessions.

  * mount -t cgroup -o cpuset none /cpuset 中 none的作用

    > Certain filesystems aren't associated with a physical `device` (such as a partition or network share, which is what is expected at that point in the `mount` command) and it is/was customary to use `none` for these.

* 向task中增加pid

  每次只能echo一个pid到task里

  ```
  Attaching processes
  -----------------------
  
  # /bin/echo PID > tasks
  
  Note that it is PID, not PIDs. You can only attach ONE task at a time.
  If you have several tasks to attach, you have to do it one after another:
  
  # /bin/echo PID1 > tasks
  # /bin/echo PID2 > tasks
  	...
  # /bin/echo PIDn > tasks
  ```

* 向task中减少pid

  如果想把一个pid从某个cgroup task里移除，可以将它echo到另一个(比如：根cgroup)下即可，因为每个pid都必须属于某个cgroup管理。

## 参考资料

* Cgroup(from Linux Programmer's Manual): http://man7.org/linux/man-pages/man7/cgroups.7.html
* https://www.kernel.org/doc/Documentation/cgroup-v1/
* https://www.kernel.org/doc/Documentation/cgroup-v2.txt
* RedHat RESOURCE MANAGEMENT GUIDE: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/resource_management_guide/
* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/resource_management_guide/
* Understanding the new control groups API: https://lwn.net/Articles/679786/
* What does 'none' mean in “mount -t cgroup -o cpuset none /cpuset”: https://stackoverflow.com/questions/29674879/what-does-none-mean-in-mount-t-cgroup-o-cpuset-none-cpuset
