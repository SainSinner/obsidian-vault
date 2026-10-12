### Поставить VPN
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
27872
### Сгенерированные параметры для подключения к админке VPN
═══════════════════════════════════════════

     Panel Installation Complete!         

═══════════════════════════════════════════

Username:    SE0HRUXJj6

Password:    P1RZGDklRN

Port:        27872

WebBasePath: 8dyTDbdjnq2ujnRXWC

Database:    SQLite (/etc/x-ui/x-ui.db)

Access URL:  https://194.87.239.123:27872/8dyTDbdjnq2ujnRXWC

API Token:   reLktOMzjzFuJtNCSC3JcfgNOblpFCvwTcmWR3KuWbP47ay3

═══════════════════════════════════════════
### Посмотреть занятые порты
ss -tlnp
### Открыть порты
ufw allow 27872/tcp
ufw allow 443/tcp
ufw allow 80/tcp

### Как поставить
1. Скачать приложение отсюда https://hiddify.com/ (для android), вот это для macos v2box, для iphone скачать следующие приложения
https://apps.apple.com/kz/app/hiddify-proxy-vpn/id6596777532 Hiddify Proxy & VPN (этот использовать с включенным WARP, это можно сделать внутри приложения)
https://apps.apple.com/kz/app/vpn-mango-v2ray/id6751106608 VPN - Mango V2ray
2. Сканировать QR код
