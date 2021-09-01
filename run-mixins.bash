#!/bin/bash

go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
echo "$HOME/go/bin" >> "$GITHUB_PATH"

SED_PATTERN='s#${DS_PROMETHEUS}#Prometheus-Platform#g'
WORKDIR=$(pwd)
DASHBOARDS_DIR=${WORKDIR}/dashboards/generals

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
cd ${WORKDIR}

# === Strimzi Kafka ===
git clone https://github.com/strimzi/strimzi-kafka-operator.git
cd strimzi-kafka-operator/examples/metrics/grafana-dashboards
SED_FONTSIZE_PATTERN='s#200%#50%#g'
export FILE=strimzi-kafka-exporter.json; sed -i ${SED_PATTERN} ${FILE};
export FILE=strimzi-kafka-exporter.json; sed -i ${SED_FONTSIZE_PATTERN} ${FILE}; cp ${FILE} ${DASHBOARDS_DIR}
export FILE=strimzi-kafka.json; sed -i ${SED_PATTERN} ${FILE}; cp ${FILE} ${DASHBOARDS_DIR}
export FILE=strimzi-operators.json; sed -i ${SED_PATTERN} ${FILE}; cp ${FILE} ${DASHBOARDS_DIR}
export FILE=strimzi-zookeeper.json; sed -i ${SED_PATTERN} ${FILE}; cp ${FILE} ${DASHBOARDS_DIR}
cd ${WORKDIR}

# === MinIO Object Storage ===
curl -LO https://raw.githubusercontent.com/minio/minio/master/docs/metrics/prometheus/grafana/minio-overview.json
export FILE=minio-overview.json; sed -i ${SED_PATTERN} ${FILE}; cp ${FILE} ${DASHBOARDS_DIR}
cd ${WORKDIR}

# === Verification ===
rm ${WORKDIR}/dashboards/generals/dummy.txt
ls -lrt ${WORKDIR}/dashboards/generals
