# Nextcloud PHP troubleshooting and maintenance

Home folder:
`/var/www/html/nextcloud/`

List installed apps:
```bash
sudo -u www-data php occ app:list
```

Toggle apps:
```bash
sudo -u www-data php occ app:disable encryption
sudo -u www-data php occ app:enable privacy
```

Set audit log file:
```bash
sudo -u www-data php7.2 -f occ config:app:set admin_audit logfile --value=/var/log/nextcloud/audit.log
```

Find a string in the MySQL DB:
```bash
mysqldump --no-create-info --extended-insert=FALSE NextCloud | grep -i "LDAP"
```

Maintenance mode:
```bash
sudo -u www-data php occ maintenance:mode --off
```

Reset admin password:
```bash
sudo -u www-data php occ user:resetpassword admin
```

Apache config folders:
`conf-available`, `conf-enabled`, `mods-available`, `mods-enabled`

LDAP filters:
```text
(&(objectClass=inetOrgPerson)(seeAlso=ou=nextcloud,ou=Services,dc=domain,dc=com))
(&(&(objectClass=inetOrgPerson)(seeAlso=ou=nextcloud,ou=Services,dc=domain,dc=com))(|(uid=%uid)(|(mailPrimaryAddress=%uid)(mail=%uid))))
(&(|(objectclass=top))(|(cn=group_ID)))
```
