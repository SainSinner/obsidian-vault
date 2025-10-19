[список хуков](https://airflow.apache.org/docs/apache-airflow/1.10.13/_api/airflow/hooks/index.html)
[Source code for airflow.providers.postgres.hooks.postgres](https://airflow.apache.org/docs/apache-airflow-providers-postgres/stable/_modules/airflow/providers/postgres/hooks/postgres.html#PostgresHook)
[Соединения и хуки в Apache Airflow: разбираем на примере SQLite](https://bigdataschool.ru/blog/connections-and-hooks-airflow.html)
### Hook и метод execute

В Airflow, `hook` и `operator` - это два ключевых понятия, используемых для создания и выполнения задач. Давайте рассмотрим эти понятия чуть более обще чем мы делали до этого с Операторами.

**Operator:**

Operator представляет собой атомарную задачу в Airflow. Оператор определяет, что именно должно быть выполнено в рамках задачи. Они могут включать в себя выполнение SQL-запросов, вызовы Python-функций, запуск Bash-скриптов и тд.

`BashOperator` используется для выполнения команд в командной строке `PythonOperator` для выполнения пользовательского Python-кода `SqlSensor` для ожидания выполнения SQL-запроса и так далее.

Давайте посмотрим как выглядит `PostgresOperator` изнутри:

```python
from airflow.models import BaseOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook


# Наследуемся от BaseOperator (базовый оператор для всех операторов)
class PostgresOperator(BaseOperator):

    # Инициализвация класса
    def __init__(self, **kwargs,) -> None:
        super().__init__(**kwargs)
        ...        
    
    # Самый важный метод класса, при исполнении кода,именно его модержимое будет выполнено
    def execute(self, context):

        # Здесь может быть что угодно, однео обычно через хуки реализуют логику работы метода

        # Создание Хука, по сути подключение к базе
        self.hook = PostgresHook(postgres_conn_id=self.postgres_conn_id, schema=self.database)
        # Вызов метода из хука, по сути исполнение кода запуска sql
        self.hook.run(self.sql, self.autocommit, parameters=self.parameters)

        # Однако вы можете спокойно запустить такой код и данный метод будет просто писать Привет
        print("Hello")
```

`execute` это основной метод оператора, он выполняется при создании таски, по сути когда задача стартует то выполняется команда

```lua
obj = PostgresOperator(...)
obj.execute()
```

Все операторы на самом деле состоят из Hook-ов, это тоже `class Python` и он по факту является контейнером для реального кода который используется оператором. Вы можете спросить зачем такое разделение, почему нельзя реализовать это в операторе? Но объяснение достаточно простое, очень часто один и тот же хук может использоваться разными Операторами, и таким образом мы просто убираем дублирование кода.

**Hook**

Hook представляет собой интерфейс для взаимодействия с внешними системами или ресурсами. Это абстракция, предоставляющая методы для работы с конкретными системами (например, базами данных, облачными сервисами, API и т.д.). Хуки в Airflow используются для организации кода который выполняет непосредственные манипуляции с данными, это еще один слой абстракции для создания удобного интерфейса работы с однотипными объектами, например базами данных.

`PostgresHook`  это один из классов для работы с базой данных PostgresSQL. Он поддерживает ряд методов для манипуляции с данными.

- get_pandas_df (возвращает _pandas.DataFrame_ наследован у _DbApiHook_)
- run (выполняет SQL запрос наследован у _DbApiHook_)
- bulk_dump (реплицирует таблицу в файл, переопределенный метод)
- bulk_load (загружает файл в базу данных)

Все методы можно посмотреть [здесь](https://airflow.apache.org/docs/apache-airflow-providers-postgres/stable/_modules/airflow/providers/postgres/hooks/postgres.html#PostgresHook)

Так как мы пытаемся избавиться от дублирования кода, то часть методов Хуков реализована в классах родителях. Для нашего оператора это будет `DbApiHook` Ниже будет метод выгрузки данных в `pandas` из базы данных.

```python
class DbApiHook(BaseHook):

    def __init__(self, *args, **kwargs):
        super().__init__()
        ...

   def get_pandas_df(self, sql, parameters=None, **kwargs):

        from pandas.io import sql as psql

        with closing(self.get_conn()) as conn:
            return psql.read_sql(sql, con=conn, params=parameters, **kwargs)
```

Если вы знакомы с ООП то данная концепция не вызовет у вас труда, если же нет, то рекомендую вам ознакомиться с ООП позднее, а сейчас просто принять как данность что в Airflow существует иерархичная структура зависимости. Мы пишем Классы с методами (по факту функции) которые затем вызывают другие классы с методами для того чтобы избежать дублирования кода.

### Пример Использования DAG с хуком и оператором переноса, для загрузки данных из удаленного источника и вставки в SQLite базы данных
```python
from airflow.models.baseoperator import BaseOperator  
from airflow.hooks.sqlite_hook import SqliteHook  
from airflow.operators.python import PythonOperator  
from airflow import DAG  
from datetime import timedelta  
from airflow.utils.dates import days_ago  
import pandas as pd  
  
  
class FileSQLiteTransferHook(SqliteHook):  
  
    def get_pandas_df(self, url_or_path, path_local):  
        """ Ваш код который читает данные из файла  
        """        # Ваш код который читает данные из файла  
        data = pd.read_csv(url_or_path)  
        data.to_csv(path_or_buf=path_local + 'get_pandas_df.csv', index=False)  
        return data  
  
    def insert_df_to_db(self, data, table_name):  
        """ Данный метод вставляет данные в БД  
            self.get_conn() это готовый метод SqliteHook для создания подключения        """        # data = self.get_pandas_df(data)  
        data.to_sql(table_name, con=self.get_conn(), if_exists='replace', index=False)  
  
    def read_data(self, table_name):  
        return print(pd.read_sql(f'SELECT * FROM "{table_name}"', con=self.get_conn()))  
  
  
class FileSQLiteTransferOperator(BaseOperator):  
  
    def __init__(self, path, path_local, table_name, **kwargs):  
        super().__init__(**kwargs)  
        self.hook = None  
        self.path = path  # Путь до файла  
        self.path_local = path_local  # Путь до личной папки  
        self.table_name = table_name  # Название таблицы в BD  
  
    def execute(self, context):  
        # Создание объекта хука  
        self.hook = FileSQLiteTransferHook()  
  
        # Ваш код вызовите метод который  
        # читает данные и затем записывает данные в БД        data = self.hook.get_pandas_df(url_or_path=self.path, path_local=self.path_local)  
        self.hook.insert_df_to_db(data=data, table_name=self.table_name)  
        self.hook.read_data(table_name=self.table_name)  
  
  
# Запуск вашего Оператора  
  
dag = DAG('555995750', schedule_interval=timedelta(days=1), start_date=days_ago(1),  
          tags=["555995750"], )  
  
t1 = FileSQLiteTransferOperator(  
    task_id='transfer_data',  
    path='https://raw.githubusercontent.com/dm-novikov/stepik_airflow_course/main/data_new/2021-01-04.csv',  
    path_local='/usr/local/airflow/dags/sandbox/555995750/',  
    table_name='test_table_555995750',  
    dag=dag)
```