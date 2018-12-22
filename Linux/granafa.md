granafa 系统监控
```yml
version: '2'

services:
 influxdbData:
  image: busybox
  volumes:
    - ./data/influxdb:/data

 influxdb:
  image: tutum/influxdb:0.9
  restart: always
  environment:
    - PRE_CREATE_DB=cadvisor
  ports:
    - "8083:8083"
    - "8086:8086"
  expose:
    - "8090"
    - "8099"
  volumes_from:
    - "influxdbData"

 cadvisor:
  image: google/cadvisor
  links:
    - influxdb:influxsrv
  command: -storage_driver=influxdb -storage_driver_db=cadvisor -storage_driver_host=influxsrv:8086
  restart: always
  ports:
    - "8080:8080"
  volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:rw
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro

 grafana:
    image: grafana/grafana:5.3.2
    restart: always
    ports:
      - 30001:3000
    links:
    - influxdb:influxsrv
    user: "472"
    environment:
      - "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource"
      - "GF_SECURITY_ADMIN_PASSWORD=3564423"
      - HTTP_USER=admin
      - HTTP_PASS=admin
      - INFLUXDB_HOST=influxsrv
      - INFLUXDB_PORT=8086
      - INFLUXDB_NAME=cadvisor
      - INFLUXDB_USER=root
      - INFLUXDB_PASS=root
```
配置链接：https://www.brianchristner.io/how-to-setup-docker-monitoring/