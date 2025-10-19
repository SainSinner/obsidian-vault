Ссылка на основную последовательность действий с комментариями
[Шаг 1 – Установка Airflow в контейнере – Stepik](https://stepik.org/lesson/559335/step/1?unit=553416)

==Установка контейнеров==

Вся сборка по этой [datanlnja/airflow-course-examples at student (github.com)](https://github.com/datanlnja/airflow-course-examples/tree/student) Для запуска всего проекта клонируйте его себе, через командную строку wsl открыть папку где расположены файлы, затем выполните следующую команду, она займется сборкой проекта и запуском.

```
sudo docker-compose build --no-cache && sudo docker-compose up -d
```

Для входа (LOGIN/PASSWORD), поля которые мы задавали в `init.sh` файле (проверьте файл самостоятельно пароль может отличаться):
###### docker-compose.yml
```yaml
version: '3'
services:
  # Постгрес база в отдельном контейнере
  postgres:
    # Устанавливаем готовый образ
    image: postgres 
    # Задаем глобальные переменные для доступа к PG
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_DB=airflow
    restart: always
    ports:
      - 5432:5432
    volumes:
      - pgdata:/var/lib/postgresql/data

  # Airflow в отдельном контейнере
  airflow:
    # Сборка из Dockerfile
    build: .
    restart: always
    # Определяет порядок запуска сервисов
    # Будем ждать postgres
    depends_on:
      - postgres
    # Пробрасываем порты
    ports:
      - 8001:8080
    # Пробрасываем папку с дагами
    volumes:
      - ./airflow/dags:/usr/local/airflow/dags
      - ./airflow/plugins:/usr/local/airflow/plugins
      - logs:/usr/local/airflow/logs

volumes:
  pgdata:
  logs:
```

###### Dockerfile
```yaml
# Возьмем за основу данный образ
# Данная команда установит уже готвоый образ с python:3.8
# После чего поверх него установит дополнительные 
# команды которые мы укажем дальше
FROM python:3.8 

# Устанавливаем домашнюю директорию внутри контейнера
# При первом запуске Airflow в каталоге $AIRFLOW_HOME
# будет создан файл airflow.cfg.
ENV AIRFLOW_HOME=/usr/local/airflow

# Airflow глобальные переменные
ARG AIRFLOW_VERSION=2.1.4

# Здесь и выше мы использовали глобальные переменные
# Они нужны чтобы не прописывать каждый раз что то в 
# config файл, это проще и гибче, синтаксис следующий
# AIRFLOW__{SECTION}__{KEY} конкретные данные нужно искать в документации

# Папка с дагами и плагинами
ENV AIRFLOW__CORE__DAGS_FOLDER=/usr/local/airflow/dags 
ENV AIRFLOW__CORE__PLUGINS_FOLDER=/usr/local/airflow/plugins

# Замени executor, сменим бд на постгрес и 
ENV AIRFLOW__CORE__EXECUTOR=LocalExecutor
ENV AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://postgres:postgres@postgres:5432/airflow"
ENV SQLALCHEMY_WARN_20=1
ENV SQLALCHEMY_SILENCE_UBER_WARNING=1

# Отключим примеры кода
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False

# Установка airflow с поддержкой всех баз данных
RUN pip install apache-airflow[postgres]==${AIRFLOW_VERSION}

# Установка визуального редактора для работы в Airflow UI
# Дополнительная настройка чтобы можно было редактировать код
# Внутри веб интерфейса
RUN pip install airflow-code-editor
RUN pip install black fs-s3fs fs-gcsfs
RUN pip install apache-airflow-providers-telegram

# Слздадим отдельную папку для нашего скрипта запуска
# Затем скопируем сам скрипт и после чего выдадим расширеные права
RUN mkdir /project
COPY scripts/ /project/scripts/
RUN chmod +x /project/scripts/init.sh

# Запускаем sh скрипт
# Начнет процесс инициализации airflow
ENTRYPOINT ["/project/scripts/init.sh"]

# Настройки airflow-code-editor
ENV AIRFLOW__CODE_EDITOR__ROOT_DIRECTORY='/usr/local/airflow'
ENV AIRFLOW__CODE_EDITOR__MOUNT='name=plugins,path=/usr/local/airflow/plugins'
```

init.sh
```bash
#!/bin/bash

# Создание БД
sleep 10
airflow db init
sleep 10

airflow users create \
          --username admin \
          --firstname admin \
          --lastname admin \
          --role Admin \
          --email admin@example.org \
          -p 12345

# Запуск шедулера и вебсервера
airflow scheduler & airflow webserver
```

==Настроить подключение докер образа к PyCharm - воспользоваться следующей статьей.== [Develop Airflow DAGs locally with PyCharm | Astronomer Documentation](https://www.astronomer.io/docs/learn/pycharm-local-dev)

Обозначение сущностей:
1. Контейнер
2. Сеть
Чтобы контейнеры не включались сразу после запуска docker:
3. Узнать id запущенных конейнеров через команду
      docker ps
4. Пройтись по каждому контейнеру командой
	docker update --restart=no <id конейнера>