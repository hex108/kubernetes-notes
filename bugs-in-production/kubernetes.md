# Kubernetes相关问题

## Kubelet

* mount volume超时

  volume下有大量的未删除文件，导致mount volume操作过了很久才生效。最终发现是升级golang版本编译kubernetes导致的，golang lib改了remove的行为。


