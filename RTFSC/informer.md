# Informer

[What's the right resync period value for informers?](https://groups.google.com/forum/#!msg/kubernetes-sig-api-machinery/PbSCXdLDno0/hEG1YykvDQAJ)

> The resync period does more to compensate for problems in the controller code than to compensate for missed watch event.  We have had very few "I missed an event bug" (I can think of one in recent memory), but we have had many controllers which use the resync as a big "try again" button.

> A resync is different than a relist.  The resync plays back all the events held in the informer cache.  A relist hits the API server to re-get all the data.

> Since we introduced the rate limited work queue a few releases ago, the need to wait for a resync to retry has largely disappeared since an error during processing gets requeued on an incrementing delay.

> Think of the resync as insurance.  You probably want it set more than a few minutes, less than a few hours.  If you're using requeuing correctly and avoiding panics, you aren't likely to benefit from rescanning all the data very often.