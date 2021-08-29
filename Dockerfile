FROM grafana/grafana:7.5.10

COPY configs/dashboard-general.yaml /etc/grafana/provisioning/dashboards/
COPY dashboards/generals/* /data/dashboards/generals/
RUN ls -lrt /data/dashboards/generals/

#ENV GF_INSTALL_PLUGINS "grafana-piechart-panel, yesoreyeram-boomtable-panel, neocat-cal-heatmap-panel, marcusolsson-hourly-heatmap-panel"

USER grafana 
RUN echo $(date) > /tmp/date.txt
