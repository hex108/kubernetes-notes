# Admission controller

## 1. PodPreset

修改pod神器。

- Inject Information into Pods Using a PodPreset: https://kubernetes.io/docs/tasks/inject-data-application/podpreset/
- PodPreset design proposal: https://github.com/kubernetes/community/blob/master/contributors/design-proposals/service-catalog/pod-preset.md

## 2. MutatingAdmissionWebhook

Diving into Kubernetes MutatingAdmissionWebhook: https://medium.com/ibm-cloud/diving-into-kubernetes-mutatingadmissionwebhook-6ef3c5695f74

可以根据需要自主地（要自己写webhook）修改pod。通过框架[kubewebhook](https://github.com/slok/kubewebhook)可以很方便地写一个webhook。

## 3. PodNodeSelector

```
This admission controller defaults and limits what node selectors may be used within a namespace by reading a namespace annotation and a global configuration.
```

我们可以使用它给pod自动加上`NodeSelector`，这样可以为不同namesapce的pod分配指定的机器，达到各namespace业务机器隔离的作用。这样的效果通过`MutatingAdmissionWebhook`也可以达到，但我们需要写一个AdmissionWebhook，有时间的话可以自己写一个。

具体配置如下所示：

* 为所有namespace分配机器，并用`kubectl label node NODE_NAME_XXX dedicatedNode=NAMESAPCE_XXX`命令给机器加上相应的标签，其中`dedicatedNode`为任一有意义的命名字，和下文一致就行。比如：`kubectl label node test-node dedicatedNode=demo`的意义是：将`test-node`节点分配给`demo` namespace下的pod使用。

* 给apiserver增加参数：`--admission-control=...,PodNodeSelector`和`--admission-control-config-file=/etc/kubernetes/admission-control.yaml`，其中admission-control.yaml内容如下：

  ```
  podNodeSelectorPluginConfig:
    clusterDefaultNodeSelector: "dedicatedNode=ItDoesNotExist"
  ```

  所有没有指定默认nodeSelector的namespace下的pod都会加上nodeSelector `dedicatedNode=ItDoesNotExist`，显然这些pod将不会被调度到任何机器上（标签为`dedicatedNode=ItDoesNotExist`的机器应该不存在吧:)）

* 新建namespace时，使用以下命令为namespace下的pod指定默认的nodeSelector（否则将为使用上文默认的`dedicatedNode=ItDoesNotExist`）：

  `kubectl patch namespace NAMESPACE_XXX -p '{"metadata":{"annotations":{"scheduler.alpha.kubernetes.io/node-selector":"dedicatedNode=NAMESPACE_XXX"}}}'`，例：`kubectl patch namespace demo -p '{"metadata":{"annotations":{"scheduler.alpha.kubernetes.io/node-selector":"dedicatedNode=demo"}}}'`，namespace demo下的pod将会被自动加上nodeSelector `dedicatedNode=demo`

## 4. 参考资料

* Using Admission Controllers: https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/
* Understanding and using the Kubernetes PodNodeSelector Admission Controller: https://www.mgasch.com/post/podnodesel/