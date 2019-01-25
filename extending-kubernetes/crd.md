# 使用CustomResourceDefinition(CRD)扩展Kubernetes

## 1. 简介

* CRD简单的例子

  https://kubernetes.io/docs/tasks/access-kubernetes-api/extend-api-custom-resource-definitions/

* 写一个controller处理CRD

  https://github.com/kubernetes/sample-controller

  sample-controller: 放在go/src/k8s.io目录下

  https://github.com/kubernetes/community/blob/master/contributors/devel/controllers.md

* 关于subresource(status/scale)及category

  https://blog.openshift.com/kubernetes-custom-resources-grow-up-in-v1-10/

  如果想生成UpdateStatus/UpdateScale/..之类的方法，需要在CRD数据结构上加上一些tag：

  ```
  Similar to how an UpdateStatus() method exists for the status subresource, we can generate the GetScale() and UpdateScale() methods for the scale subresource by adding the following tags on the Database type.
  ```

  使用`scale` subresource可以很方便地实现自动扩缩容。

* [CRD validation](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#validation)

  可以通过 [OpenAPI v3 schema](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md#schemaObject)对custom resource(CR)进行校验，否则如果用户创建的CR包含有不合规则的字段，就会导致CRD相应的controller没法正常工作，比如：不能正常list这些CR（解析时会出错）。

  如果CRD里要校验的字段太多，可以考虑下面两种方式：

  * 使用[validatingadmissionwebhook](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#validatingadmissionwebhook)进行校验

  * 利用工具自动生成OpenAPI schema

    https://github.com/ant31/crd-validation

    官方也有相应的issue追踪https://github.com/kubernetes/kubernetes/issues/62323，但还没没完成。

## 2. 实现

- ETCD存储

  CRD存储在etcd上的路径与deployment、pod等核心资源的存储位置不一样，它的路径为：`root / resource.Group + "/" + resource.Resource`（见`staging/src/k8s.io/apiextensions-apiserver/pkg/apisever/customresource_handler.go`#574，注：在project里搜索“ResourcePrefix”可以搜到其他resource的存储路径）。

  注： tapp为/registry/gaia/tapps/default/example-tapp。为了平滑升级，兼容以前的版本，我们需要修改tapp的存储路径。

## 3. 自动化工具

* [Kubebuilder](https://github.com/kubernetes-sigs/kubebuilder)

  Kubebuilder is a framework for building Kubernetes APIs using [custom resource definitions (CRDs)](https://kubernetes.io/docs/tasks/access-kubernetes-api/extend-api-custom-resource-definitions).

  **Note:** kubebuilder does not exist as an example to *copy-paste*, but instead provides powerful libraries and tools to simplify building and publishing Kubernetes APIs from scratch.

* [metacontroller](https://github.com/GoogleCloudPlatform/metacontroller)

  Metacontroller is an add-on for Kubernetes that makes it easy to write and deploy [custom controllers](https://kubernetes.io/docs/concepts/api-extension/custom-resources/#custom-controllers) in the form of [simple scripts](https://metacontroller.app/).

* [operator-sdk](https://github.com/operator-framework/operator-sdk)

  This project is a component of the [Operator Framework](https://github.com/operator-framework), an open source toolkit to manage Kubernetes native applications, called Operators, in an effective, automated, and scalable way.

## 4. 一些有趣的CRD/Operator

Awesome Operators in the Wild: https://github.com/operator-framework/awesome-operators


## 5. 参考资料

* Extend the Kubernetes API with CustomResourceDefinitions: https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/

* Building an operator for Kubernetes with the sample-controller: https://itnext.io/building-an-operator-for-kubernetes-with-the-sample-controller-b4204be9ad56

* Building an operator for Kubernetes with kubebuilder: https://itnext.io/building-an-operator-for-kubernetes-with-kubebuilder-17cbd3f07761
* Building an operator for Kubernetes with operator-sdk: https://itnext.io/building-an-operator-for-kubernetes-with-operator-sdk-40a029ea056