# 各组件参数配置调优

**对于生产环境，组件参数的配置很重要，以下参数对于大集群性能优化也会有很大帮助。**

## 1. API Server参数

* 设置单独的etcd集群存储event事件

  Event事件太多，会影响etcd性能。通过参数`--etcd-servers-overrides stringSlice`可以将event存储到单独的集群，同时，该参数也支持将其他的资源类型存储到不同的etcd集群。

  > Etcd is used for two distinct cluster purposes - cluster state and event processing. These have different i/o characteristics. It is important to scalability testing efforts that the iops provided by the servers to etcd be consistent and protected. These leads to two requirements:
  >
  > - Split etcd: Two different etcd clusters for events and cluster state (note: this is currently the GKE production default as well).
  > - Dedicated separate IOPS for the etcd clusters on each control plane node. On a bare metal install this could look like a dedicated SSD. This requires a more specific configuration per provider. Config table below.

* --max-requests-inflight, --max-mutating-requests-inflight

  控制给定时间内apiserver的连接数，--max-requests-inflight 默认值为400，--max-mutating-requests-inflight 默认值为200。

* –target-ram-mb

  内存配置选项和node数量的关系，单位是MB：--target-ram-mb=node_nums * 60

* 给API Server配置足够的资源，主要是CPU、内存资源

## 2. Controller参数

* --kube-api-qps, —kube-api-burst

  控制scheduler向apiserver发送请求的数量，太小会导致调度性能下降。

* --controller

  禁用不需要的 controller：kubernetes v1.14 中已有 35 个 controller，默认启动所有 controller，可以禁用不需要的 controller。

* --concurrent_XXX

  调整 controller 同步资源的周期：避免过多的资源同步导致集群资源的消耗，所有带有--concurrent 前缀的参数，例：

  ```
  --concurrent-replicaset-syncs int32     Default: 5
  The number of replica sets that are allowed to sync concurrently. Larger number = more responsive replica management, but more CPU (and network) load
  ```

## 3. Scheduler参数

* [percentageOfNodesToScore](https://kubernetes.io/docs/concepts/configuration/scheduler-perf-tuning/#percentage-of-nodes-to-score)

  Scheduler为pod分配kubelet节点的过程可以分为两个阶段：predicates（筛选出满足pod各种硬性条件，如：资源大小）和priorities（给通过pridicates选出的节点打分，选出最优的节点）。对于大集群（1000+）来说，preidcates和pritories这两个过程可能消耗很长时间，为了提高调度性能，我们可以减少选出的满足条件的节点的数量，通过`percentageOfNodesToScore`设置predicates需要选出的节点数。缺点是：这样可能导致调度结果不是全局最优的，但一般没什么问题。

* --kube-api-qps, —kube-api-burst

  控制scheduler向apiserver发送请求的数量，太小会导致调度性能下降（bind等也会受影响）。

## 4. Kubelet

kubelet各参数解释：https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/

* 并发pull image

  --serialize-image-pulls=false，虽然官方默认为true，但设置为fale后能并发pull image增加并发度，container更快被拉起，并且docker 1.9+版本已解决该问题。但是如果docker daemon 版本小于1.9，且使用 aufs 存储则不能改动该选项。

  ```
  --serialize-image-pulls
  Pull images one at a time. We recommend *not* changing the default value on nodes that run docker daemon with version < 1.9 or an Aufs storage backend. Issue #10959 has more details. (default true)
  ```

* --cgroups-per-qos=true

  https://github.com/kubernetes/community/blob/master/contributors/design-proposals/node/pod-resource-management.md

  使用新的cgroup结构：BestEffort、Burstable、Guaranteed的pod分开放在不同的目录下，每个pod都有属于自己的目录结构。有如下好处：

  ```
  1. Enforce QoS classes on the node.
  2. Simplify resource accounting at the pod level.
  3. Allow containers in a pod to share slack resources within its pod cgroup. For example, a Burstable pod has two containers, where one container makes a CPU request and the other container does not. The latter container should get CPU time not used by the former container. Today, it must compete for scare resources at the node level across all BestEffort containers.
  4. Ability to charge per container overhead to the pod instead of the node. This overhead is container runtime specific. For example, `docker` has an associated `containerd-shim` process that is created for each container which should be charged to the pod.
  5. Ability to charge any memory usage of memory-backed volumes to the pod when an individual container exits instead of the node.
  ```

* NodeLease

  1.16版本默认值是true。

  在大规模场景下，大量 node 的心跳汇报严重影响了 node 的watch，apiserver 处理心跳请求也需要非常大的开销。而开启nodeLease 之后，kubelet 会使用非常轻量的 nodeLease 对象 (0.1 KB) 更新请求替换老的 Update Node Status 方式，这会大大减轻 apiserver 的负担。

* WatchBookmark

  1.16版本默认值是true。

  kubernetes v1.15 支持 bookmark 机制，bookmark 主要作用是只将特定的事件发送给客户端，从而避免增加apiserver 的负载。bookmark 的核心思想概括起来就是在client 与 server 之间保持一个“心跳”， 即使队列中无 client 需要感知的更新，reflector 内部的版本号也需要及时的更新。该特性能大大提高 Kube-apiserver 的 List/Watch 性能。


## 5. ETCD参数

## 6. Docker参数

* 控制每个container日志文件（stdout/stderr）大小

  `--log-opt max-size=XXX --log-opt max-file=XXX`

  例：`--log-opt max-size=10M --log-opt max-file=3`，每个stdout/stderr最多只有10M，最多保存3个（文件会回滚）。

## 7. Linux内核参数

## 8. 参考资料

* kube-apiserver参数: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/
* kube-controller-manager参数: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/
* kubelet参数: https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/
* sig-scalability: https://github.com/kubernetes/community/tree/master/sig-scalability
* Kubernetes Scalability thresholds: https://github.com/kubernetes/community/blob/master/sig-scalability/configs-and-limits/thresholds.md
* Scalability Testing/Analysis Environment and Goals: https://github.com/kubernetes/community/blob/master/sig-scalability/configs-and-limits/provider-configs.md
* ETCD tunning: https://etcd.io/docs/v3.4.0/tuning/
* 一年时间打造全球最大规模之一的Kubernetes集群，蚂蚁金服怎么做到的？https://mp.weixin.qq.com/s/bJrMNxKMn89TzmpEyIZrRg