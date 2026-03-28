### Поставить VPN
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
27872
### Сгенерированные параметры для подключения к админке VPN
═══════════════════════════════════════════
     Panel Installation Complete!
═══════════════════════════════════════════
Username:    kbBrlPI6Ul
Password:    oggEsjnxpp
Port:        27872
WebBasePath: N22Vn4o5bAKpYkoho1
Access URL:  https://45.11.24.196:27872/N22Vn4o5bAKpYkoho1
═══════════════════════════════════════════
### Посмотреть занятые порты
ss -tlnp
### Открыть порты
ufw allow 27872/tcp
ufw allow 443/tcp

### Как поставить
1. Скачать приложение отсюда https://hiddify.com/ (для android/ios), вот это для macos v2box
2. Сканировать QR код

# Proxy socks5
### Ставим прокси на сервер
apt install dante-server -y
### Узнаем имя сетвеого интерфейса
ip a | grep -E "^[0-9]+:" | awk '{print $2}' | tr -d ':'
### Прописываем конфиг
```
cat > /etc/danted.conf << 'EOF'
logoutput: /var/log/danted.log

internal: eth0 port = 3113
external: eth0

clientmethod: none
socksmethod: username

user.privileged: root
user.notprivileged: nobody

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: error
}

socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: error
}
EOF
```
### Создать пользователя и пароль для него
useradd -r -s /bin/false brand_new_socks
passwd brand_new_socks
Pc6SvZkYv2

### Запуск и открытие порта
systemctl restart danted
systemctl enable danted
ufw allow 3113/tcp

### Эндпоинт с кредами для подключения
https://t.me/socks?server=45.11.24.196&port=3113&user=brand_new_socks&pass=Pc6SvZkYv2