# CPU

## 1. 软限制

cpu share

```
cpu.shares
contains an integer value that specifies a relative share of CPU time available to the tasks in a cgroup. For example, tasks in two cgroups that have cpu.shares set to 100 will receive equal CPU time, but tasks in a cgroup that has cpu.shares set to 200 receive twice the CPU time of tasks in a cgroup where cpu.shares is set to 100. The value specified in the cpu.shares file must be 2 or higher.
```

注：

* cpu.shares是一个相对值，同一层次的cgroup之前会按照cpu.shares值共享cpu。

* cpu.sharess值最小为2，所以kubelet给best effort pod的cpu.shares设置的值为2。

## 2. 硬限制

### 2.1 通过cfs_period_us和cfs_quota_us限制

https://www.kernel.org/doc/Documentation/scheduler/sched-bwc.txt

```
cpu.cfs_quota_us: the total available run-time within a period (in microseconds)
cpu.cfs_period_us: the length of a period (in microseconds)
cpu.stat: exports throttling statistics [explained further below]

The default values are:
	cpu.cfs_period_us=100ms
	cpu.cfs_quota=-1

A value of -1 for cpu.cfs_quota_us indicates that the group does not have any
bandwidth restriction in place, such a group is described as an unconstrained
bandwidth group.  This represents the traditional work-conserving behavior for
CFS.
```

注：

- 每个cgroup下的period值可以不一样

- 如果cpu.cfs_period_us值太小，且进程太多，可能影响程序的性能

  ```
   - cpu.cfs_period_us: The duration in microseconds of each scheduler period, for
   bandwidth decisions. This defaults to 100000us or 100ms. Larger periods will
   improve throughput at the expense of latency, since the scheduler will be able
   to sustain a cpu-bound workload for longer. The opposite of true for smaller
   periods. Note that this only affects non-RT tasks that are scheduled by the
   CFS scheduler.
  ```

例：

* 限制只能使用0.2个cpu，则可设置：cpu.cfs_period_us=100ms, cpu.cfs_quota=20ms
* 限制可以使用2个cpu，则可设置：cpu.cfs_period_us=100ms, cpu.cfs_quota=200ms

### 2.2 通过cpuset限制

```
Cpusets provide a mechanism for assigning a set of CPUs and Memory Nodes to a set of tasks.  
```

通过cpuset可以限制进程运行在哪些cpu和mem上（cpuset.cpus用于设置cpu，cpuset.mems用于设置内存），通过以下命令`cat /proc/$PID/stats`可以查看进程的cpuset情况，例：

```
$ cat /proc/self/status | grep allowed
Cpus_allowed:	f
Cpus_allowed_list:	0-3
Mems_allowed:	00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000001
Mems_allowed_list:	0
```

简单的测试用例：

```
mount -t cgroup -ocpuset cpuset /sys/fs/cgroup/cpuset
cd /sys/fs/cgroup/cpuset
mkdir test
cd test
/bin/echo 2-3 > cpuset.cpus
/bin/echo 1 > cpuset.mems   # 如果没有这一步，echo tasks时将会报错：
                            # echo: write error: no space left on device
/bin/echo $$ > tasks
sh
# The subshell 'sh' is now running in cpuset test
# The next line should display '/test'
cat /proc/self/cpuset
```

## 3. Kubelet中的cpu管理

Cpu manager: https://kubernetes.io/blog/2018/07/24/feature-highlight-cpu-manager/

https://github.com/kubernetes/community/blob/master/contributors/design-proposals/node/cpu-manager.md

https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/#cpu-management-policies

## 4. 参考资料

* CFS Bandwidth Control: https://www.kernel.org/doc/Documentation/scheduler/sched-bwc.txt
* cpushare: https://kernel.googlesource.com/pub/scm/linux/kernel/git/glommer/memcg/+/cpu_stat/Documentation/cgroups/cpu.txt
* cpuset: https://www.kernel.org/doc/Documentation/cgroup-v1/cpusets.txt