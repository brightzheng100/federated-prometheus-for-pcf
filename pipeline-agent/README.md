## Pipeline for Provisioning the "Agent" Deployment

### Prepare UAA Clients

There are 3 UAA clients to be created for corresponding exporters, in Job of `create-uaa-clients`:
- PAS UAA client for `firehose_exporter`: firehose_exporter/((uaa_client_firehose_exporter_secret))
- PAS UAA client for `cf_exporter`: cf_exporter/((uaa_client_cf_exporter_secret))
- BOSH UAA client for `bosh_exporter`: bosh_exporter/((uaa_client_bosh_exporter_secret))

> Node: using

If Concourse is integrated for credential management, perform similar commands like belows before running the pipeline:
```
$ credhub generate -n /concourse/main/uaa_client_firehose_exporter_secret -t password
$ credhub generate -n /concourse/main/uaa_client_cf_exporter_secret -t password
$ credhub generate -n /concourse/main/uaa_client_bosh_exporter_secret -t password
```
> Note: 
> - change the team `main` above to your team name; and/or 
> - add pipeline name after team name to make these variables dedicated for one specific pipeline 


### Set Up Pipline 

Assuming there is already a "target" named `gcp`.
Copy the params.yml to another file to configure parameters before flying.
```
$ cp pipeline-agent/params.yml _params-agent.yml
$ fly -t gcp login -k
$ fly -t gcp set-pipeline -p prometheus-agent \
    -c pipeline-agent/pipeline.yml \
    -l _params-agent.yml
```

Then manually trigger the pipeline tasks one by one to go through the installation process.


### Install "Agent" Prometheus Manually

Assuming
1. [`prometheus-boshrelease`](https://github.com/bosh-prometheus/prometheus-boshrelease.git) has been cloned at folder of `../prometheus-boshrelease`;
2. There is a BOSH Director and the alias is `gcp`

Then you can deploy it like this:
```
$ bosh -e gcp -d prometheus-agent ../prometheus-boshrelease/manifests/prometheus.yml \
      -o ../prometheus-boshrelease/manifests/operators/monitor-bosh.yml \
      -o ../prometheus-boshrelease/manifests/operators/enable-bosh-uaa.yml \
      -o ../prometheus-boshrelease/manifests/operators/monitor-cf.yml \
      -o ../prometheus-boshrelease/manifests/operators/monitor-node.yml \
      -o ops-files/prometheus-agent-job.yml \
      -o ops-files/remove-alertmanager.yml \
      -o ops-files/remove-grafana.yml \
      -o ops-files/remove-nginx.yml \
      -o ops-files/colocate-postgres.yml \
      -o ops-files/colocate-firehose-exporter.yml \
      -o ops-files/local-cf-exporter.yml \
      -l _params-agent.yml
```