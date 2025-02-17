# Отчет по лабораторной работе 4

### Шипилов Дементий, ИП-215

## Балансировка нагрузки *nginx*

Для распределения нагрузки между бэкенд-серверами с использованием фронтенд-сервера *nginx*, необходимо в конфигурационном файле объявить бекенд-сервера, между которыми необходима балансировка нагрузки и метод распределения нагрузки. Например:

```properties
upstream web-address {
    server 10.10.10.1;
    server 10.10.10.2;
    ...
}

server {
    location / {
        proxy_pass http://web-address;
    }
}
```

| Алгоритм | Способ активации | Плюсы | Минусы |
|---|---|---|---|
| Round Robin | Используется, если инной алгоритм не указан | Хорошо масштабируется, равномерно распределяет нагрузку между приложениями и не нагружает систему | Не учитывает разную производительность серверов и текущую загрузку приложений. |
| Least Connections | Указание алгоритма для списка серверов `upstream web_address { least_conn; ... }` | Распределяет нагрузку на приложения с наименьшим количеством активных соединений | Может привести к неравномерному распределению нагрузки при большом количестве медленных клиентов |
| Weighted Round Robin | Указание веса для каждого сервера `server 10.10.10.1 weight=1;` | Даёт возможность задавать различные веса для серверов, отражающие их производительность | Не учитывает текущую загрузку приложений и требуется ручная настройка весов |
| Weighted Least Connections | Указание алгоритма в списке серверов и веса каждого сервера | Учитывает разную производительность серверов, опираясь на количество активных соединений и распределяет нагрузку пропорционально весам и количеству соединений | Требуется ручная настройка весов |
| IP Hash | Указание алгоритма `upstream web_address { least_conn; ... }` | Привязывает клиента к определенному IP-адресу и обеспечивает сохранение состояния сеанса клиента на одном сервере | Не учитывает текущую загрузку приложений, не учитывает производительность серверов и может привести к неравномерному распределению нагрузки при большом количестве клиентов с одинаковым IP-адресом |

> Для автоматического управления распределением клиентов между серверами, в случае падения одного из них, можно установить параметры `max_fails` и `fail_timeout`, отвечающие за *количество пропущенных ответов на запрос* и *время, за которое необходимо, чтобы запросы не были удовлетворены* соответственно.

## Балансировка нагрузки *traefik*

Для распределения нагрузки с использованием *traefik* необходимо, при инициализации контейнера, с помощью команд *docker-compose*, установить необходимые флаги, отвечающие за настройки конфигурации обратного прокси.

> В случае, когда автоматическое объявление новых контейнеров в сети отключено, при этом их нужно объявить, необходимо в файле *docker-compose* добавить метки, указывающие *traefik*, что нужно сделать с этими контейнерами.
> 
> ```yaml
> labels:
>   # Проксирование через Traefik
>   - "traefik.enable=true"
>   # Объявление веб-адреса контейнера
>   - "traefik.http.routers.web.rule=Host(`web-address`)"
>   # Объявление разрешенных точек входа
>   - "traefik.http.routers.web.entrypoints=http"
> ```

*P.S.: traefik* поддерживает только алгоритм *Round Robin*.

## Балансировка нагрузки *lvs/ipvs*

Для распределения нагрузки с использованием *ipvsadm*, использующем модули ядра Linux `ip_vs`, необходимо активировать необходимые модули ядра, настроить службу[[1]](https://www.server-world.info/en/note?os=Ubuntu_16.04&p=lvs&f=1), фаерволы на бэкенд-серверах и сохранить настройки конфигурации балансировщика нагрузки.

Для балансировщика нагрузки (фронтенда):

```shell
# Активация модулей ядра Linux
echo ip_vs >> /etc/modules-load.d/modules.conf
echo ip_vs_rr >> /etc/modules-load.d/modules.conf
echo ip_vs_wrr >> /etc/modules-load.d/modules.conf
echo ip_vs_sh >> /etc/modules-load.d/modules.conf

# Активация перенаправления запросов на бэкенд-сервера
echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf

# Установка администратора Linux Virtual Server
apt install -y ipvsadm

# Настройка демона ipvsadm
echo 'AUTO="true"' > /etc/default/ipvsadm
echo 'DAEMON="master"' >> /etc/default/ipvsadm
echo 'IFACE="enp0s8"' >> /etc/default/ipvsadm

# Активация автозапуска демона ipvsadm
systemctl enable ipvsadm.service

# Создание виртуального сервиса на VIP и добавление бэкенд-серверов
# в балансировщик нагрузки
ipvsadm -A -t 10.10.10.100:80 -s rr
ipvsadm -a -t 10.10.10.100:80 -r 10.10.10.20:80 -g
ipvsadm -a -t 10.10.10.100:80 -r 10.10.10.30:80 -g

# Сохранение конфигурации балансировки нагрузки
ipvsadm-save > /etc/ipvsadm.rules
```

Для бэкенд-серверов:

```shell
# Деактивация ответов на ARP-запросы для VIP
echo net.ipv4.conf.lo.arp_ignore = 1 >> /etc/sysctl.conf
echo net.ipv4.conf.lo.arp_announce = 2 >> /etc/sysctl.conf
echo net.ipv4.conf.all.arp_ignore = 1 >> /etc/sysctl.conf
echo net.ipv4.conf.all.arp_announce = 2 >> /etc/sysctl.conf

# Активация возвращения пакетов с бэкенд-серверов клиентам
iptables -t nat -A PREROUTING -d 10.10.10.100 -j REDIRECT

# Уствновка демона сохранения конфигурации фаервола после перезапуска сервера
apt install -y iptables-persistent
```
