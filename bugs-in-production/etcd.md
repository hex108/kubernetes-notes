# ETCD相关问题

## ETCD IO太高

某集群etcd io太高，导致SSD使用太猛。通过iotop观察到etcd的写速率是20M/s，最终原因是boltdb相关问题，在etcd 3.3版本已解决，临时解决方案是对etcd定期进行defrag操作（比如：加一个crontab）。详细原因见：https://github.com/coreos/etcd/issues/8565。