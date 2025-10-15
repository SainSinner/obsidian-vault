1. создаем папку в linux, можно назвать graylog-docker
2. в, ранее созданную папку, скачиваем версию open .env.example и .env.example [https://github.com/Graylog2/docker-compose](https://github.com/Graylog2/docker-compose)
3. создаем из .env.example .env
4. для environment GRAYLOG_PASSWORD_SECRET генерируем значение через команду в linux `pwgen -N 1 -s 96`
5. для environment GRAYLOG_ROOT_PASSWORD_SHA2 генерируем значение через команду в linux `echo -n парольДляAdminУчеткиПодКОторойБудемЗаходитьВИнтерфейс | shasum -a 256`
6. убираем кавычки у GRAYLOG_ROOT_PASSWORD_SHA2 и сохраняем .env
7. в консоли ubuntu заходим в `cd graylog-docker`
8. запускаем `docker compose -f docker-compose.yml up -d`
9. ждем когда все прогрузиться и в консоли первой ноды будут строчки ниже, username & password нужно использовать при первом входе по [http://localhost:9000](http://localhost:9000)  
```
2024-06-26 15:40:41 ========================================================================================================
    2024-06-26 15:40:41 
    2024-06-26 15:40:41 It seems you are starting Graylog for the first time. To set up a fresh install, a setup interface has
    2024-06-26 15:40:41 been started. You must log in to it to perform the initial configuration and continue.
    2024-06-26 15:40:41 
    2024-06-26 15:40:41 Initial configuration is accessible at 0.0.0.0:9000, with username 'admin' and password 'oYLstRIANl'.
    2024-06-26 15:40:41 Try clicking on http://admin:oYLstRIANl@0.0.0.0:9000
    2024-06-26 15:40:41 
    2024-06-26 15:40:41 ========================================================================================================
    
```
10. Далее происходит настройка, на все соглашаемся
11. После того как все погрузится появиться возможность войти под аккаунтом `admin` и пароль для него необходимо использовать тот который был на месте `парольДляAdminУчеткиПодКОторойБудемЗаходитьВИнтерфейс`