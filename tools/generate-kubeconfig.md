# 生成特定权限和配额的kubeconfig

## 1. 步骤

**注：所有步骤的一键生成脚本可以在[generate_kubeconfig.sh](https://gist.github.com/hex108/12c8c104f17a5189e14da621147daf84)下载**。

*  找到一台可以访问集群apiserver并且对集群有admin操作权限的机器，以下的操作是直接在master节点上进行的。

* 创建namespace，并在该namespace时创建一个service account

  ```
  # kubectl create namespace test-user-ns
  namespace/test-user-ns created
  # cat service_account.yaml 
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: test-user
  # kubectl create -f ./service_account.yaml -n test-user-ns
  serviceaccount/test-user created
  ```

* 获取该service account对应的secret

  ```
  # kubectl describe serviceAccounts test-user -n test-user-ns
  Name:                test-user
  Namespace:           default
  Labels:              <none>
  Annotations:         <none>
  Image pull secrets:  <none>
  Mountable secrets:   test-user-token-5q46v
  Tokens:              test-user-token-5q46v
  Events:              <none>
  ```

* 获取secret对应的token

  ```
  # kubectl describe secret test-user-token-5q46v -n test-user-ns
  ```

* 获取集群信息，并存到cluster-cert.txt文件里。

  ```
  # kubectl config view --flatten --minify > cluster-cert.txt
  ```

* 用以上信息按照下面的格式生成kubeconfig

  ```
  apiVersion: v1
  kind: Config
  users:
  - name: test-user
    user:
      token: {TOKEN content of the service account}  
  clusters:
  - cluster:
      certificate-authority-data: {certificate-authority-data from cluster-cert.txt}
      server: https://{YOUR_SERVER_IP}:6443
    name: {YOUR_CLUSTER_NAME}
  contexts:
  - context:
      cluster: {YOUR_CLUSTER_NAME}
      user: test-user
    name: test-user-context
  current-context: test-user-context
  ```

* 权限控制

  创建一个新的namepsace和role，并通过rbac控制上面生成的service account只能访问该namespace里的资源。

  ```
  # cat role.yaml 
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: Role
  metadata:
    name: test-user-role
    namespace: test-user-ns # Should be namespace you are granting access to
  rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: RoleBinding
  metadata:
    name: test-user-rolebinding
    namespace: test-user-ns # Should be namespace you are granting access to
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: Role
    name: test-user-role # Should match name of Role
  subjects:
  - namespace: test-user-ns
    kind: ServiceAccount
    name: test-user # Should match service account name, above
  # kubectl create -f ./role.yaml 
  role.rbac.authorization.k8s.io/test-user-role created
  rolebinding.rbac.authorization.k8s.io/test-user-rolebinding created
  ```

* 为新建的namespace设置quota

  ```
  # cat quota.yaml 
  apiVersion: v1
  kind: List
  items:
  - apiVersion: v1
    kind: ResourceQuota
    metadata:
      name: quota
    spec:
      hard:
        cpu: "20"    # CPU
        memory: 10Gi  # 内存
        pods: "50"  # pod数
  # kubectl create -f ./quota.yaml -n test-user-ns
  resourcequota/quota created
  ```

## 2. 参考资料

* Creating a kubeconfig file for a self-hosted Kubernetes cluster: http://docs.shippable.com/deploy/tutorial/create-kubeconfig-for-self-hosted-kubernetes-cluster/

* Kubernetes: Creating Service Accounts and Kubeconfigs: https://docs.armory.io/spinnaker-install-admin-guides/manual-service-account/

* Resource Quotas: https://kubernetes.io/docs/concepts/policy/resource-quotas/


