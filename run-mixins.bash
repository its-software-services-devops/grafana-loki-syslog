#!/bin/bash

go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
echo "$HOME/go/bin" >> "$GITHUB_PATH"

WORKDIR=$(pwd)

# === Loki Dashboards ===
JSONNET_FILE=loki-dashboards.jsonnet
git clone https://github.com/grafana/loki.git
cd loki/production/loki-mixin
cp ${WORKDIR}/${JSONNET_FILE} .
jb install
jsonnet -J vendor ${JSONNET_FILE} -m ${WORKDIR}/dashboards/generals
cd ${WORKDIR}

# === Cert Manager ===
JSONNET_FILE=lib/dashboards.jsonnet
git clone https://gitlab.com/uneeq-oss/cert-manager-mixin.git
cd cert-manager-mixin
jsonnet ${JSONNET_FILE} -m ${WORKDIR}/dashboards/generals
