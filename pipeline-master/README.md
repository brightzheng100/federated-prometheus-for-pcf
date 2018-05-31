## Pipeline for Provisioning the "Master" Deployment for Prometheus Components

### Install "Master" Prometheus Manually

Assuming
1. [`prometheus-boshrelease`](https://github.com/bosh-prometheus/prometheus-boshrelease.git) has been cloned at folder of `../prometheus-boshrelease`;
2. There is a BOSH Director and the alias is `lite`

Then you can deploy it like this:
```
$ bosh -e lite -d prometheus-agent ../prometheus-boshrelease/manifests/prometheus.yml \
      -o ops-files/prometheus_job.yml \
      -o ops-files/remove-alertmanager.yml \
      -o ops-files/remove-grafana.yml \
      -o ops-files/remove-nginx.yml \
      -o ops-files/colocate_database.yml \
      -o ops-files/colocate_firehose_exporter.yml \
      -o ops-files/local_cf_exporter.yml
```

### Set Up Pipline

Assuming there is already a "target" called `lite`.
```
$ fly -t lite login -k
$ fly -t lite set-pipeline -p promethues-agent \
    -c pipeline-agent/pipeline.yml \
    -l _agent-params.yml
```