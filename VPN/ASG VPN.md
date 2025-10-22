# MAC
`scutil --dns` - в терминале выдаст DNS сервера на которые настроены

`10.115` - это ip dns сервера АСГ
`192.168` - это ip моего роутера

ЕСТЕСТВЕННО ИХ НУЖНО ДОПИСАТЬ

Настроено должно быть так

```bash
DNS configuration (for scoped queries)

resolver #1
  nameserver[0] : 10.115.**.*
  nameserver[1] : 192.168.*.*
  if_index : 11 (en0)
  flags    : Scoped, Request A records
  reach    : 0x00000002 (Reachable)

resolver #2
  nameserver[0] : 10.115.**.*
  if_index : 20 (ipsec0)
  flags    : Scoped, Request A records
  reach    : 0x00000003 (Reachable,Transient Connection)
```

Как это сделать:
В параметрах VPN прописать следующее
![[Pasted image 20251022131413.png]]
![[Pasted image 20251022131318.png]]

# Полезные команды для работы с BASH

`scutil --dns` - получить конфигурацию настройки dns для mac
`ping -c 3 serverts217.OVP.RU` - проверить доступность до хоста
`nslookup redmine.ovp.ru` - узнать ip адрес и определеятся ли он
