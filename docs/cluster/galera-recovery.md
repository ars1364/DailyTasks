# Galera bundle not promoting as Master (Pacemaker)

Refs:
- `https://dba.stackexchange.com/questions/157500/how-to-recover-mariadb-galera-cluster-after-full-crash`
- `https://galeracluster.com/library/documentation/crash-recovery.html`

## Last known working sequence
```bash
docker exec -it $(docker ps -q -f name=gal) bash
cat /var/lib/mysql/grastate.dat
```

If `seqno = -1`:
```bash
/usr/libexec/mysqld --wsrep-recover
```

Note recovered position, then start mysqld with the recovered position:
```bash
/usr/libexec/mysqld --defaults-file=/etc/my.cnf --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mariadb/plugin --user=mysql --wsrep_on=ON --wsrep_provider=/usr/lib64/galera/libgalera_smm.so --wsrep-cluster-address=gcomm://controller-1-rack01.internalapi.localdomain,controller-2-rack02.internalapi.localdomain,controller-3-rack03.internalapi.localdomain --log-error=/var/log/mysql/mysqld.log --open-files-limit=16384 --pid-file=/var/run/mysql/mysqld.pid --socket=/var/lib/mysql/mysql.sock --port=3306 --wsrep_start_position=a14ac3b5-fa9c-11eb-bb7f-c76c9bcc711e:533267631
```

Then:
```bash
pcs resource restart galera-bundle
```

## If the above does not work
Check port 3306 on all controllers:
```bash
ss -tulpen | grep 3306
```

On a healthy node:
```bash
docker ps | grep galera
docker exec -it --user 0 <galera-bundle-docker-xx> bash
ps -aux | more
```

Find the `mysqld` command line from a healthy node.

### Solution 1
Remove `wsrep_start_position` and start mysqld on an unhealthy node:
```bash
/usr/libexec/mysqld --defaults-file=/etc/my.cnf --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mariadb/plugin --user=mysql --wsrep_on=ON --wsrep_provider=/usr/lib64/galera/libgalera_smm.so --wsrep-cluster-address=gcomm://node0.internalapi.localdomain,node1.internalapi.localdomain,node2.internalapi.localdomain --log-error=/var/log/mysql/mysqld.log --open-files-limit=16384 --pid-file=/var/run/mysql/mysqld.pid --socket=/var/lib/mysql/mysql.sock --port=3306
```

After a successful start, restart Pacemaker:
```bash
pcs resource restart galera-bundle
```

### Solution 2
Mark the healthy node as safe to bootstrap:
```bash
sed -i "/safe_to_bootstrap/s/0/1/" /var/lib/mysql/grastate.dat
```

Then on an unhealthy node:
```bash
/usr/libexec/mysqld --defaults-file=/etc/my.cnf --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib64/mariadb/plugin --user=mysql --wsrep_on=ON --wsrep_provider=/usr/lib64/galera/libgalera_smm.so --wsrep-cluster-address=gcomm://node0.internalapi.localdomain,node1.internalapi.localdomain,node2.internalapi.localdomain --log-error=/var/log/mysql/mysqld.log --open-files-limit=16384 --pid-file=/var/run/mysql/mysqld.pid --socket=/var/lib/mysql/mysql.sock --port=3306 --wsrep-recover
```

Restart Pacemaker on the unhealthy node.
