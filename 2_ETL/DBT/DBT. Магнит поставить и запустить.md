Для Windows
1. Зайти в папку в которой хотим чтобы было создано окружение
2. python -m venv .dbt_env
3. активируем для СMD .dbt_env\Scripts\activate.bat lдля PowerShell .dbt_env\Scripts\Activate.ps1
4. Устанавливаем необходимые библиотеки (сначала проваливаемся в 
   `cd C:\users\grekhov_sk\khd-2.0\airflow_etl\dags\magn\generator_dbt_model`
   затем
   `python -m pip install -r requirements.txt`
5.  (в первый раз) Создать .env по расположению `C:\users\grekhov_sk\khd-2.0\airflow_etl\dags\magn\generator_dbt_model\.env` со следующим контентом
DWH20_IMPALA_HOST=impala-tenant-hr.lh-tst.corp.tander.ru
DWH20_IMPALA_PORT=21050
DWH20_IMPALA_USER=my_login
DWH20_IMPALA_PASS=my_password
 6. Создать profiles.yml по расположению `C:\users\grekhov_sk\khd-2.0\airflow_etl\dags\magn\generator_dbt_model\dwh20_test\profiles.yml` со следующим контентом
dwh20:
  target: test
  outputs:
    test:
      type: impala
      host: impala-tenant-hr.lh-tst.corp.tander.ru
      port: 21050
      schema: default
      threads: 1
      auth_type: ldap
      username: my_login
      password: my_password
      use_http_transport: false
      use_ssl: true
      AllowSelfSignedCerts: 1
      retries: 1
      usage_tracking: false
      send_anonymous_usage_stats: false
7. Проверяем рабочую директорию и запускаем проверку
```bash

cd "C:/users/grekhov_sk/khd-2.0/airflow_etl/dags/magn/generator_dbt_model"

dbt debug --profiles-dir ./dwh20_test --project-dir ./dwh20_test

```
Должно выдать примерно следующее
```
(.dbt_env) PS C:\users\grekhov_sk\khd-2.0\airflow_etl\dags\magn\generator_dbt_model> dbt debug --profiles-dir ./dwh20_test --project-dir ./dwh20_test
11:53:59  Running with dbt=1.9.8
11:53:59  dbt version: 1.9.8
11:53:59  python version: 3.12.4
11:53:59  python path: C:\Users\grekhov_sk\.dbt_env\Scripts\python.exe
11:53:59  os info: Windows-11-10.0.22631-SP0
11:54:00  Using profiles dir at ./dwh20_test
11:54:00  Using profiles.yml file at ./dwh20_test\profiles.yml
11:54:00  Using dbt_project.yml file at dwh20_test\dbt_project.yml
11:54:00  adapter type: impala
11:54:00  adapter version: 1.9.0
11:54:00  Configuration:
11:54:00    profiles.yml file [OK found and valid]
11:54:00    dbt_project.yml file [OK found and valid]
11:54:00  Required dependencies:
11:54:00   - git [OK found]

11:54:00  Connection:
11:54:00    host: impala-tenant-hr.lh-tst.corp.tander.ru
11:54:00    port: 21050
11:54:00    schema: default
11:54:00    username: grekhov_sk
11:54:00  Registered adapter: impala=1.9.0
WARNING:thrift.transport.sslcompat:using legacy validation callback
C:\Users\grekhov_sk\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
  self._context = ssl.SSLContext(ssl_version)
11:54:03    Connection test: [OK connection ok]

11:54:03  All checks passed!
```