# 参数调优

## Scheduler参数

* [percentageOfNodesToScore](https://kubernetes.io/docs/concepts/configuration/scheduler-perf-tuning/#percentage-of-nodes-to-score)

  Scheduler为pod分配kubelet节点的过程可以分为两个阶段：predicates（筛选出满足pod各种硬性条件，如：资源大小）和priorities（给通过pridicates选出的节点打分，选出最优的节点）。对于大集群（1000+）来说，preidcates和pritories这两个过程可能消耗很长时间，为了提高调度性能，我们可以减少选出的满足条件的节点的数量，通过`percentageOfNodesToScore`设置predicates需要选出的节点数。缺点是：这样可能导致调度结果不是全局最优的，但一般没什么问题。

* --kube-api-qps, —kube-api-burst

  控制scheduler向apiserver发送请求的数量，太小会导致调度性能下降（bind等也会受影响）。

  注：controller也需要调整这两个参数。