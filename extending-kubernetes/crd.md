# 使用CustomResourceDefinition(CRD)扩展Kubernetes

## 自动化工具

* [Kubebuilder](https://github.com/kubernetes-sigs/kubebuilder)

  Kubebuilder is a framework for building Kubernetes APIs using [custom resource definitions (CRDs)](https://kubernetes.io/docs/tasks/access-kubernetes-api/extend-api-custom-resource-definitions).

  **Note:** kubebuilder does not exist as an example to *copy-paste*, but instead provides powerful libraries and tools to simplify building and publishing Kubernetes APIs from scratch.

* [metacontroller](https://github.com/GoogleCloudPlatform/metacontroller)

  Metacontroller is an add-on for Kubernetes that makes it easy to write and deploy [custom controllers](https://kubernetes.io/docs/concepts/api-extension/custom-resources/#custom-controllers) in the form of [simple scripts](https://metacontroller.app/).

* [operator-sdk](https://github.com/operator-framework/operator-sdk)

  This project is a component of the [Operator Framework](https://github.com/operator-framework), an open source toolkit to manage Kubernetes native applications, called Operators, in an effective, automated, and scalable way.

## 一些有趣的CRD/Operator

Awesome Operators in the Wild: https://github.com/operator-framework/awesome-operators


## 参考资料

* Extend the Kubernetes API with CustomResourceDefinitions: https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/

* Building an operator for Kubernetes with the sample-controller: https://itnext.io/building-an-operator-for-kubernetes-with-the-sample-controller-b4204be9ad56

* Building an operator for Kubernetes with kubebuilder: https://itnext.io/building-an-operator-for-kubernetes-with-kubebuilder-17cbd3f07761
* Building an operator for Kubernetes with operator-sdk: https://itnext.io/building-an-operator-for-kubernetes-with-operator-sdk-40a029ea056