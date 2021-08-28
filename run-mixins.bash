#!/bin/bash

go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
echo "$HOME/go/bin" >> "$GITHUB_PATH"

WORKDIR=$(pwd)

# === Loki Dashboards ===
JSONNET_FILE=loki-dashboard.jsonnet
git clone https://github.com/grafana/loki.git
cd loki/production/loki-mixin
cp ${WORKDIR}/${JSONNET_FILE} .
jb install
jsonnet -J vendor ${JSONNET_FILE} -m ${WORKDIR}/dashboard/generals
cd ${WORKDIR}
