## Pipeline for Provisioning the "Master" Deployment for Prometheus Components

### Install "Master" Prometheus Manually

Assuming
1. [`prometheus-boshrelease`](https://github.com/bosh-prometheus/prometheus-boshrelease.git) has been cloned at folder of `../prometheus-boshrelease`;
2. There is a BOSH Director and the alias is `lite`

Then you can deploy it like this:
```
$ bosh -e lite -d prometheus-agent ../prometheus-boshrelease/manifests/prometheus.yml \
      -o ops-files/prometheus_master_job.yml \
      -o ops-files/prometheus_master_federation.yml
```

### Set Up Pipline

Assuming there is already a "target" called `gcp`.
```
$ fly -t gcp login -k
$ fly -t gcp set-pipeline -p prometheus-master \
    -c pipeline-master/pipeline.yml \
    -l _master-params.yml
```


### How To Test?

```
$ curl -v -G --data-urlencode 'match[]={job="bosh"}' http://{prometheus-agent}:9090/federate

curl -v -G --data-urlencode 'match[]={job="bosh"}' http://104.197.73.249:9090/federate

```