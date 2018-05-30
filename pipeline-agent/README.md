## Pipeline for deploying the "agent" deployment for Prometheus components to monitor PCF

### Prepare UAA Clients

There are 3 UAA clients to be created for corresponding exporters, in Job of `create-uaa-clients`:
- PAS UAA client for `firehose_exporter`: firehose_exporter/((uaa_client_firehose_exporter_secret))
- PAS UAA client for `cf_exporter`: cf_exporter/((uaa_client_cf_exporter_secret))
- BOSH UAA client for `bosh_exporter`: bosh_exporter/((uaa_client_bosh_exporter_secret))

If Concourse is integrated for credential management, perform similar commands like belows before running the pipeline:
```
$ credhub generate -n /concourse/main/uaa_client_firehose_exporter_secret -t password
$ credhub generate -n /concourse/main/uaa_client_cf_exporter_secret -t password
$ credhub generate -n /concourse/main/uaa_client_bosh_exporter_secret -t password
```
> Note: 
> - change the team `main` above to your team name; and/or 
> - add pipeline name after team name to make these variables dedicated for pipeline 


### Install "Agent" Prometheus Manually

Assuming [`prometheus-boshrelease`](https://github.com/bosh-prometheus/prometheus-boshrelease.git) has been cloned at folder of `../prometheus-boshrelease`.
```
$ bosh int ../prometheus-boshrelease/manifests/prometheus.yml \
      -o ../prometheus-boshrelease/manifests/operators/monitor-bosh.yml \
      -o ../prometheus-boshrelease/manifests/operators/enable-bosh-uaa.yml \
      -o ../prometheus-boshrelease/manifests/operators/monitor-cf.yml \
      -o ../prometheus-boshrelease/manifests/operators/monitor-node.yml \
      -o ops-files/prometheus_job.yml \
      -o ops-files/remove-alertmanager.yml \
      -o ops-files/remove-grafana.yml \
      -o ops-files/remove-nginx.yml \
      -o ops-files/colocate_database.yml \
      -o ops-files/colocate_firehose_exporter.yml \
      -o ops-files/local_cf_exporter.yml
```


### Set Pipline

Assuming there is already a "target" called `gcp`.
```
$ fly -t gcp login -k
$ fly -t gcp set-pipeline -p promethues-agent \
    -c pipeline-agent/pipeline.yml \
    -l pipeline-agent/_params.yml
```