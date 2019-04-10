# Garbage collection

## Finalizers

在彻底删除某个资源之前，需要确保其finalizers列表为空。我们可以通过finalizers来清理和这个资源相关的其他资源。关于Finalizers的具体例子可见：[https://book.kubebuilder.io/beyond_basics/using_finalizers.html](https://book.kubebuilder.io/beyond_basics/using_finalizers.html)。

需要注意的是，对于pod而言，如果pod的deletion timestamp设置后，即使设置了finalizers，kubelet也会去停止pod的容器，关注这个问题的可见[issue 76360: Let kubelet respect pod's finalizers](https://github.com/kubernetes/kubernetes/issues/76360)。

## 参考资料

* Garbage collection: https://github.com/kubernetes/community/blob/master/contributors/design-proposals/api-machinery/garbage-collection.md