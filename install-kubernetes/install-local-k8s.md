# 开发与测试环境

## 1. 编译

编译全部组件：

`make`

编译某个组件：

`make all WHAT=$(COMPNAME_NAME)`

例：编译kubelet：`make all WHAT=cmd/kubelet`

## 2. 本地节点运行kubernetes集群

`hack/local-up-cluster.sh`

**注：运行`hack/local-up-cluster.sh`时要确保没有设置proxy(`env | grep -i proxy`)，否则会有一些莫名其妙的错误（比如：DNS pod启动有问题），我的mac上增加了命令`proxy_off`关掉proxy。**

## 3. 运行集成测试

https://github.com/kubernetes/community/blob/master/contributors/devel/sig-testing/integration-tests.md

- The following invocation will run all integration tests: `make test-integration`
- The following invocation will run a specific test with the verbose flag set:`make test-integration WHAT=./test/integration/pods GOFLAGS="-v" KUBE_TEST_ARGS="-run ^TestPodUpdateActiveDeadlineSeconds$"`, e.g. `make test-integration WHAT=./staging/src/k8s.io/apiextensions-apiserver/test/integration/ GOFLAGS="-v" KUBE_TEST_ARGS="-run TestEtcdStorage"`

## 4. 参考资料

- Testing guide: https://github.com/kubernetes/community/blob/master/contributors/devel/testing.md