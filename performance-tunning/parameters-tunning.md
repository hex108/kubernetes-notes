# 大集群参数调优

## 1. Apiserver参数

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

## 2. Controller参数

* --kube-api-qps, —kube-api-burst

  控制scheduler向apiserver发送请求的数量，太小会导致调度性能下降。

* --controller

  禁用不需要的 controller：kubernetes v1.14 中已有 35 个 controller，默认启动所有 controller，可以禁用不需要的 controller。

* --concurrent_XXX

  调整 controller 同步资源的周期：避免过多的资源同步导致集群资源的消耗，所有带有
   --concurrent 前缀的参数，例：

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

* NodeLease

  1.16版本默认值是true。

  在大规模场景下，大量 node 的心跳汇报严重影响了 node 的watch，apiserver 处理心跳请求也需要非常大的开销。而开启nodeLease 之后，kubelet 会使用非常轻量的 nodeLease 对象 (0.1 KB) 更新请求替换老的 Update Node Status 方式，这会大大减轻 apiserver 的负担。

* WatchBookmark

  1.16版本默认值是true。

  kubernetes v1.15 支持 bookmark 机制，bookmark 主要作用是只将特定的事件发送给客户端，从而避免增加apiserver 的负载。bookmark 的核心思想概括起来就是在client 与 server 之间保持一个“心跳”， 即使队列中无 client 需要感知的更新，reflector 内部的版本号也需要及时的更新。该特性能大大提高 Kube-apiserver 的 List/Watch 性能。

* --serialize-image-pulls

  该选项配置串行拉取镜像，默认值时true，配置为false可以增加并发度。但是如果docker daemon 版本小于1.9，且使用 aufs 存储则不能改动该选项。

## 5. ETCD参数

## 6. Linux内核参数

## 7. 参考资料

* kube-apiserver参数: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/
* kube-controller-manager参数: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/
* kubelet参数: https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/
* sig-scalability: https://github.com/kubernetes/community/tree/master/sig-scalability
* Kubernetes Scalability thresholds: https://github.com/kubernetes/community/blob/master/sig-scalability/configs-and-limits/thresholds.md
* Scalability Testing/Analysis Environment and Goals: https://github.com/kubernetes/community/blob/master/sig-scalability/configs-and-limits/provider-configs.md
* ETCD tunning: https://etcd.io/docs/v3.4.0/tuning/