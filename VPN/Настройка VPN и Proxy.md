Актуальный прокси-сервер с портом к которому стучаться
```
45.11.24.196:3128
```

**Сейчас настроен сервер Outline на моем немецком VPS, для подключения Outline Manager к нему, нужно использовать следующий JSON**
```json
{
"apiUrl":"https://45.11.24.196:46096/L0o2JcPBiQSM0SZoGgAZbQ",
"certSha256":"9BB647AE8AB5CB71623447358033CEE74069B8963D39488B67E37383B48F00D6"
}
```

**На сайте ниже параметры виртуального сервера**
https://ruvds.com/ru-rub/my/servers
ниже вариант выгоднее по деньгам
https://my.adminvps.ru/aff.php?aff=28572

Команды из bash
```
sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh)"
apt update
apt upgrade
apt install squid
nano /etc/squid/squid.conf
```
**строки ниже добавить в файл squid.conf (ВАЖНО ПОНИМАТЬ ЧТО ПЕРВЫЕ 2 СТРОКИ УКАЗЫВАЮТ С КАКОГО IP МОЖНО ПОДКЛЮЧАТЬСЯ)
калькулятор ip https://www.ipaddressguide.com/cidr, /16 обозначает, что последние 2 октета являются пластичными (wildcard-символами)
```
acl allowed_ips src 195.14.0.0/16
acl allowed_ips src 77.223.0.0/16
acl allowed_ips src 193.0.0.0/16
acl allowed_ips src 195.14.0.0/16
#	http_access allow allowed_ips
http_access allow allowed_ips
http_access deny all

# Максимальное число файловых дескрипторов (в 2 раза меньше системного лимита)
max_filedescriptors 5000

# Лимит одновременных подключений (защита от перегрузки)
# maxconn 100

# чистим кэш
cache_swap_high 95
cache_swap_low 80
```
![[Pasted image 20250427114933.png]]

Рестарт squid и чек статуса
```
systemctl restart squid
systemctl status squid
```

Чистим логи и перезапускаем quid
```
truncate -s 0 "/var/log/squid/access.log.1"
truncate -s 0 "/var/log/squid/access.log"
truncate -s 0 "/var/log/squid/cache.log"
truncate -s 0 "/var/log/squid/cache.log.1"
systemctl restart squid
systemctl status squid
```