# Scheduler

## 1. 配置使用多个scheduler

https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/

## 2. 优化

- Equivalence class based scheduling in Kubernetes

  https://github.com/kubernetes/community/blob/master/contributors/design-proposals/scheduling/scheduler-equivalence-class.md

## 3. 性能测试

性能测试命令：

a. [Scheduler Performance Test](https://github.com/kubernetes/kubernetes/tree/master/test/integration/scheduler_perf)

```
# In Kubernetes root path
make generated_files

cd test/integration/scheduler_perf
./test-performance.sh
```

b. make

```
make test-integration WHAT=./test/integration/scheduler_perf GOFLAGS="-v=1" KUBE_TEST_VMODULE="''" KUBE_TEST_ARGS="-run=xxx -bench=BenchmarkScheduling"
```

c. [Scheduler Benchmarking](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-scheduling/scheduler_benchmarking.md)

## 4. 其他调度器

* [Nomad](https://github.com/hashicorp/nomad)

  调度原理：[Scheduling in Nomad](https://www.nomadproject.io/docs/internals/scheduling/scheduling.html)

## 5. 公开的调度数据

* Google: https://github.com/google/cluster-data
* Alibaba: https://github.com/alibaba/clusterdata/