# Useful commands: Containers

```text
/var/log/docker
controller1 docker  php my admin
controller1 docker mariadb --> .myini --> root password
docker restart $(docker ps -a -q)
docker run -v ${PWD}/reports:/app/reports wallarm/gotestwaf --grpcPort 9000 --url=https://xx.ir
docker build . --force-rm -t gotestwaf
docker run -v /tmp:/tmp/report gotestwaf --url=https://
    wallarm/gotestwaf --url=https://xx.ir
403 Client Error: Forbidden for url: https://registry-1.docker.io/v2/
sudo podman login registry.platform.xaas.ir
sudo podman login -u <User> -p <pass> https://registry-1.docker.io/v2/
dig https://registry-1.docker.io/v2/
sudo podman login  https://registry.platform.xaas.ir
sudo podman exec --user root -it mysql  mysql -r --disable-column-names --batch -e 'select variables from mistral.environments_v2 where name = "ssh_keys";'
docker run -d -e PMA_HOST=172.20.120.11 -p 8044:80 phpmyadmin/phpmyadmin
docker run -d -e PMA_HOST=<host_internal_api> -p 8044:80 phpmyadmin/phpmyadmin
docker ps  --format "table {{.ID}}\t{{.Names}}" | ccze -A
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" | ccze -A
docker ps  --format "table {{.Names}}\t{{.Status}}"
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" -f health=unhealthy  | ccze -A
docker exec $(docker ps -q -f name=rabb) rabbitmqctl list_policies
#####cron job to execute inside docker
```