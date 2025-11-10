Пример настройки
https://habr.com/ru/companies/flant/articles/523510/?code=d895b61fbf334b70b974a65771358068&state=o8ig82vZzwtujzdMZS9vSJzO&hl=ru

### Пример настроек для создания коннектора который я настраивал

Endpoint к которому нужно обратиться

```url
http://localhost:8083/connectors
```

Контент запроса

```json
{  
  "name": "postgres-backend-debezium-connector",  
  "config": {  
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",  
    "plugin.name": "pgoutput",  
    "database.hostname": "postgres",  
    "database.port": "5432",  
    "database.user": "airflow",  
    "database.password": "airflow",  
    "database.dbname": "backend",  
    "topic.prefix": "pg_dev",  
    "table.include.list": "public.*",  
    "heartbeat.interval.ms": "5000",  
    "slot.name": "dbname_debezium",  
    "publication.name": "dbname_publication",  
    "transforms": "AddPrefix",  
    "transforms.AddPrefix.type": "org.apache.kafka.connect.transforms.RegexRouter",  
    "transforms.AddPrefix.regex": "pg_dev\\.public\\.(.*)",  
    "transforms.AddPrefix.replacement": "data.cdc.dbname_$1",  
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",  
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",  
    "key.converter.schemas.enable": "false",  
    "value.converter.schemas.enable": "false",  
    "include.schema.changes": "false",  
    "snapshot.mode": "initial"  
  }  
}
```



- **name**: уникальное имя коннектора в Kafka Connect.
    
- **connector.class**: класс коннектора Debezium для PostgreSQL (`io.debezium.connector.postgresql.PostgresConnector`).
    
- **plugin.name**: логический репликационный плагин PostgreSQL (`pgoutput`), используемый для чтения WAL.
    
- **database.hostname**: хост PostgreSQL для подключения (например, `localhost` или имя Docker-сервиса).
    
- **database.port**: порт PostgreSQL (по умолчанию `5432`).
    
- **database.user**: имя пользователя для подключения к PostgreSQL.
    
- **database.password**: пароль пользователя для подключения.
    
- **topic.prefix**: имя базы данных PostgreSQL для отслеживания изменений.
    
- **database.server.name**: логический идентификатор сервера, используется в качестве префикса топиков и для namespace сообщений.
    
- **table.include.list**: список таблиц для отслеживания изменений (можно использовать wildcard, например `public.*`).
    
- **slot.name**: имя логического replication slot в PostgreSQL, через который Debezium читает WAL.
    
- **publication.name**: имя публикации PostgreSQL, содержащей таблицы для CDC.
    
- **heartbeat.interval.ms**: интервал отправки heartbeat-сообщений в Kafka (в миллисекундах), чтобы отслеживать живость коннектора.
    
- **transforms**: список трансформаций сообщений, применяемых к топикам или данным (например, `AddPrefix`).
    
- **transforms.AddPrefix.type**: тип трансформации, здесь `RegexRouter` для изменения имени топиков по регулярному выражению.
    
- **transforms.AddPrefix.regex**: регулярное выражение для сопоставления исходного имени топика.
    
- **transforms.AddPrefix.replacement**: строка для замены имени топика после применения регулярного выражения.
    
- **key.converter**: конвертер ключа сообщений Kafka (например, `JsonConverter`).
    
- **value.converter**: конвертер значения сообщений Kafka (например, `JsonConverter`).
    
- **key.converter.schemas.enable**: включает или отключает схемы для ключа (`false` — схемы не использовать).
    
- **value.converter.schemas.enable**: включает или отключает схемы для значения (`false` — схемы не использовать).
    
- **include.schema.changes**: указывает, включать ли изменения схемы в поток данных (`false` — не включать).
    
- **snapshot.mode**: режим начального снимка базы данных (`initial` — сделать snapshot при первом запуске).

### Список коннекторов

```url
http://localhost:8083/connectors
```

### Статус коннектора

```url
http://localhost:8083/connectors/postgres-backend-debezium-connector/status
```