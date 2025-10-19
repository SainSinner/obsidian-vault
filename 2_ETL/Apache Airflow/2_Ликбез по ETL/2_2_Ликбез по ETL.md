следующая [[2_2_CRON расписание задач]]
### Введение: постановка задачи

**Задача:**

Ежедневно следует извлекать информацию из внешнего источника (например базы данных или внешнего API сервиса) и составлять отчет о выручке в различных разрезах. Данный отчет предполагается отправлять на электронную почту всей команды к 10 часам утра. После этого данные необходимо сохранять в локальной базе данных.

![](https://ucarecdn.com/18a102c0-ec22-4b00-b09e-5b0dfc3ab63d/)

Для данного курса я подготовил набор [данных](https://raw.githubusercontent.com/dm-novikov/stepik_airflow_course/main/data/data.csv) который выложен на мой GitHub, эти данные будут вам доступны при прохождении курса. 

**Практика:**

#### Решение задачи 

Давайте попробуем решить данную задачу так, будто у нас не имеется готовых инструментов. В данном случае я воспользуюсь `Python` но, разумеется, возможен выбор любого другого языка программирования. Ниже предоставлен полный код решения задачи.

```python
# Выгрузка данных с сайта
def extract_data(url):
    return pd.read_csv(url)

# Группировка данных
def transform_data(data, group, agreg):
    return data.groupby(group).agg(agreg).reset_index()

# Загрузка в базу данных
# Для тех кто не работал с pandas+sqlite
# data_frame.to_sql(...) автоматически создаст sqlite базу данных и таблицу
def load_data(data, table_name, conn=CON):
    data["insert_time"] = pd.to_datetime("now")
    data.to_sql(table_name, conn, if_exists='replace', index=False)
```

**Запуск скрипта**

```bash
if __name__ == '__main__':

    # Выгрузка
    data = extract_data(
        "https://raw.githubusercontent.com/dm-novikov/stepik_airflow_course/main/data/data.csv")

    # Трансформация данных
    data = transform_data(data,
                          group=['A', 'B', 'C'],
                          agreg={"D": sum})

    # Загрузка в таблицу
    load_data(data, "table")
```