Airflow Spark Provider 
# SparkSubmitOperator

**Самый главный и самый часто используемый.**
### **Что делает**

Запускает Spark приложение через `spark-submit`.  
То есть Airflow = просто wrapper над `spark-submit`.

### Применение

Когда у тебя есть:

- Spark job в виде `.py`, `.jar`, `.R`
    
- Spark структурированный код (ETL-пайплайны, трансформации)
    
- Приложения для Spark Standalone / YARN / Mesos / Kubernetes
    

### Пример

``` python
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator  run_spark = SparkSubmitOperator(     task_id='process_orders',     application='/usr/local/spark/apps/orders_job.py',     conn_id='spark_default',     executor_memory='2g',     driver_memory='1g',     total_executor_cores=4 )
```

### Где используется

В **95% случаев**, когда:

- запускаешь ETL / batch job
    
- обрабатываешь большие данные
    
- вызываешь .py/.jar на Spark-кластере
# SparkJDBCOperator

**Запускает Spark SQL через JDBC на базе Spark Thrift Server.**

### Что делает

Отправляет SQL-запрос в Spark **через JDBC**, как в обычную БД.

То есть ты подключаешься к:

- Spark Thrift Server
    
- HiveServer2 (если он работает через Spark)
    

И запускаешь SQL.
# SparkSqlOperator

**Запускает Spark SQL через spark-sql CLI.**

### Что делает

Выполняет SQL команду через утилиту:

`spark-sql -e "SELECT * FROM table"`

то есть Airflow вызывает спарк через командную строку.

# Сравнение трёх операторов

| Оператор                | Что делает                       | Когда использовать                 | Плюсы              | Минусы                            |
| ----------------------- | -------------------------------- | ---------------------------------- | ------------------ | --------------------------------- |
| **SparkSubmitOperator** | Запуск Spark-приложения (py/jar) | ETL, трансформации, большие задачи | максимально мощный | требует кластер и настройки       |
| **SparkJDBCOperator**   | SQL через Spark Thrift Server    | лёгкие SQL, интерактивные запросы  | как обычный SQL    | слаб для ETL, нужен Thrift Server |
| **SparkSqlOperator**    | `spark-sql` CLI                  | DDL, Hive метастор                 | простой            | ограниченный SQL                  |