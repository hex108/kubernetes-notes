# StatefulSet

StatefulSet目前有一个问题，如果它管理的pod所在的kubelet节点挂了，StatefulSet controller没法强制删除该pod，只有下面两种情况能强制删除pod(见[Force Delete StatefulSet Pods](https://kubernetes.io/docs/tasks/run-application/force-delete-stateful-set-pod/))：

- The Node object is deleted (either by you, or by the [Node Controller](https://kubernetes.io/docs/admin/node)). 

  管理员手动delete掉node节点，但这需要人工干预，很麻烦，而且可能不及时。如果想让Node Controller delete掉node，需要给它提供信息，这通常需要和云对接([Node Controller](https://kubernetes.io/docs/concepts/architecture/nodes/)): 

  > The second is keeping the node controller’s internal list of nodes up to date with the cloud provider’s list of available machines. When running in a cloud environment, whenever a node is unhealthy, the node controller asks the cloud provider if the VM for that node is still available. If not, the node controller deletes the node from its list of nodes.

- The kubelet on the unresponsive Node starts responding, kills the Pod and removes the entry from the apiserver.

  Kubelet节点成功启动了。

- Force deletion of the Pod by the user.

  用户删除。

如果kubelet机器在较短的时间能自动恢复，当然第二种方式更好。否则：

* 公有云环境

  与node controller对接，告诉node controller kubelet所在机器的状态，决定是否delete掉这个kubelet节点。

* 非公有云环境

  很难和Node controller对接，因此最终需要人来处理。但有时候人去处理会不及时，也很麻烦。这时候，**我们可以写一些运维工具或node operator去检查机器状态（通过ssh、ping等方式），如果发现kubelet节点挂了一段时间了，就直接delete掉，这样pod就可以正常迁移了。**

## 参考资料

* Force Delete StatefulSet Pods: https://kubernetes.io/docs/tasks/run-application/force-delete-stateful-set-pod/
* Nodes: https://kubernetes.io/docs/concepts/architecture/nodes/