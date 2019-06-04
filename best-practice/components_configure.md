# 各组件推荐参数配置

## Kubernetes

### Kubelet

kubelet各参数解释：https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/

* 并发pull image

  --serialize-image-pulls=false，虽然官方默认为true，但设置为fale后能并发pull image，container更快被拉起，并且docker 1.9+版本已解决该问题。

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

## ETCD

## Docker

* 控制每个container日志文件（stdout/stderr）大小

  `--log-opt max-size=XXX --log-opt max-file=XXX`

  例：`--log-opt max-size=10M --log-opt max-file=3`，每个stdout/stderr最多只有10M，最多保存3个（文件会回滚）。