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

# === Strimzi Kafka ===
git clone https://github.com/strimzi/strimzi-kafka-operator.git
cd strimzi-kafka-operator/examples/metrics/grafana-dashboards
cp strimzi-kafka-exporter.json ${WORKDIR}/dashboards/generals
cp strimzi-kafka.json ${WORKDIR}/dashboards/generals
cp strimzi-operators.json ${WORKDIR}/dashboards/generals
cp strimzi-zookeeper.json ${WORKDIR}/dashboards/generals


# === Verification ===
rm ${WORKDIR}/dashboards/generals/dummy.txt
ls -lrt ${WORKDIR}/dashboards/generals
