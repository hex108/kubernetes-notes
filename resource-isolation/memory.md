## MEM

- 主动evication

- 通过oom score作最后的保险

  Another OOM killer rewrite: http://lwn.net/Articles/391222/

- 问题

  内存是不可压缩资源，如何保证高优先级（比如：Guranted）的pod在需要内存时能申请到资源呢？

  看看`qos-reserved`怎么实现的：https://github.com/kubernetes/kubernetes/pull/62509

  为bustable和best effort的pod设置memory limit，公式如下：

  ```
  ROOT/burstable/memory.limit_in_bytes = 
      Node.Allocatable - {(summation of memory requests of `Guaranteed` pods)*(reservePercent / 100)}
  ROOT/besteffort/memory.limit_in_bytes = 
      Node.Allocatable - {(summation of memory requests of all `Guaranteed` and `Burstable` pods)*(reservePercent / 100)}
  ```

