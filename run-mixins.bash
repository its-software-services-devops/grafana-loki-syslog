#!/bin/bash

go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
echo "$HOME/go/bin" >> "$GITHUB_PATH"

WORKDIR=$(pwd)
DASHBOARDs_DIR=${WORKDIR}/dashboards/generals

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

SED_PATTERN='s#${DS_PROMETHEUS}#Prometheus-Platform#g'

export FILE=strimzi-kafka-exporter.json; sed -i ${SED_PATTERN} ${FILE}; cp ${FILE} ${DASHBOARDs_DIR}
export FILE=strimzi-kafka.json; sed -i ${SED_PATTERN} ${FILE}; cp ${FILE} ${DASHBOARDs_DIR}
export FILE=strimzi-operators.json; sed -i ${SED_PATTERN} ${FILE}; cp ${FILE} ${DASHBOARDs_DIR}
export FILE=strimzi-zookeeper.json; sed -i ${SED_PATTERN} ${FILE}; cp ${FILE} ${DASHBOARDs_DIR}

sed -i "s#\$\{DS_PROMETHEUS\}#Prometheus-Platform#g" 
# === Verification ===
rm ${WORKDIR}/dashboards/generals/dummy.txt
ls -lrt ${WORKDIR}/dashboards/generals
