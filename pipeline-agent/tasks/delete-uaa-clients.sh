#!/bin/bash
set -e

TMPDIR=${TMPDIR:-/tmp}
TMPFILE=$(mktemp "$TMPDIR/runtime-config.XXXXXX")

root_dir=$(cd "$(dirname "$0")/.." && pwd)

source ${root_dir}/tasks/common.sh

login_to_cf_uaa

echo "Deleting Prometheus UAA firehose_exporter Client..."
uaac client delete firehose_exporter

echo "Deleting Prometheus UAA cf_exporter Client..."
uaac client delete cf_exporter

login_to_bosh_uaa

echo "Deleting Prometheus BOSH UAA bosh_exporter Client ..."
uaac client delete bosh_exporter