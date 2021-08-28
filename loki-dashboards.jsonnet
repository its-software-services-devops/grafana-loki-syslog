local utils = import 'mixin-utils/utils.libsonnet';
local fields = ["loki-chunks.json", "loki-operational.json", "loki-reads.json", "loki-writes.json"];
local dashboards = (import 'mixin.libsonnet').grafanaDashboards {
    'loki-operational.json'+: {
        showMultiCluster:: false,
        clusterLabel:: 'seubpong',

        matchers:: {
            cortexgateway+: [utils.selector.re('job', 'loki-syslog-query-frontend|loki-syslog-distributor')],
            distributor+: [utils.selector.re('job', 'loki-syslog-distributor')],
            ingester+: [utils.selector.re('job', 'loki-syslog-ingester')],
            querier+: [utils.selector.re('job', 'loki-syslog-querier')],
        },
    },

    'loki-chunks.json'+: {
        showMultiCluster:: false,

        matchers:: {
            ingester: [utils.selector.re('job', 'loki-syslog-ingester')],
        },        
    },

    'loki-reads.json'+: {
        showMultiCluster:: false,

        matchers:: {
            cortexgateway: [utils.selector.re('job', 'loki-syslog-query-frontend|loki-syslog-distributor')],
            queryFrontend: [utils.selector.re('job', 'loki-syslog-query-frontend')],
            querier: [utils.selector.re('job', 'loki-syslog-querier')],
            ingester: [utils.selector.re('job', 'loki-syslog-ingester')],
            querierOrIndexGateway: [utils.selector.re('job', 'loki-syslog-querier')],
        },
    },

    'loki-writes.json'+: {
        showMultiCluster:: false,

        matchers:: {
            cortexgateway: [utils.selector.re('job', 'loki-syslog-query-frontend|loki-syslog-distributor')],
            distributor: [utils.selector.re('job', 'loki-syslog-distributor')],
            ingester: [utils.selector.re('job', 'loki-syslog-ingester')],
        },
    },
};
{
    [name]: dashboards[name]
    for name in fields
}