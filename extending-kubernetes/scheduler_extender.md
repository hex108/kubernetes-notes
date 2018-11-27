# Scheduler extender

可以使用scheduler extender扩展scheduler，但要注意的是，目前是以http的方式进行扩展的，这会**影响scheduler的性能**，后面使用[新的scheduler framework](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/scheduling/scheduling-framework.md)后，以plugin方式改进后可能会好点。

Scheduler extender的编写规范见: https://github.com/kubernetes/community/blob/master/contributors/design-proposals/scheduling/scheduler_extender.md

编写extender时可参考样例：https://github.com/everpeace/k8s-scheduler-extender-example。