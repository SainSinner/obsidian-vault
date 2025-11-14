# Настройка для создания одного представления
## Файлы для работы dbt
в  папке dbt например `dbt_click`
создаем папку `models`
в `models` создаем папку моедели `orders_stream_cur`
`orders_stream_cur.sql`
```sql
with rnk_status_order as (SELECT order_id,
                                 status,
                                 ts_data,
                                 rank() over (partition by order_id order by ts_data) as rnk
                          FROM default.orders_stream
                          where status <> '')
select
    order_id,
    status,
    toDateTime(ts_data) as ts_data,
    1 as check
from rnk_status_order
where rnk = 1
order by ts_data
```
`schema.yaml`
```yaml
version: 2

models:
  - name: orders_stream_cur
```
в папке `dbt_click` создаем следующие 2 файла
`dbt_project.yml`
```yaml
name: 'dbt_click'
version: '1.0.0'

profile: 'dbt_click'

model-paths: ["models"]

models:
  dbt_click:
    orders_stream_cur:
      +materialized: view
      +on_schema_change: ignore
      +persist_docs.relation: false
```
`profiles.yml`
```yaml
dbt_click:
  target: dev
  outputs:
    dev:
      type: clickhouse
      host: clickhouse
      port: 8123
      user: default
      password: your_password
      schema: default
      secure: False
```

## Как инициировать работу dbt
В контейнере где установлен dbt в командной строке запустить
```shell
dbt run --select orders_stream_cur
```