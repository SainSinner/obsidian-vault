Для Windows
1. Если папка venv не создана, то создаем ее `python -m venv venv`
2. активируем для 
   **СMD** `venv\Scripts\activate.bat`
   **PowerShell** `venv\Scripts\Activate.ps1`
2. Устанавливаем необходимые библиотеки (сначала проваливаемся в 
   `cd C:\users\grekhov_sk\khd-2.0\airflow_etl\dags\magn\generator_dbt_model`
   затем
   `python -m pip install -r requirements.txt`
3. Проверяем рабочую директорию и запускаем проверку из папки **generator_dbt_model** `dbt debug --profiles-dir ./dwh20_test --project-dir ./dwh20_test`
   
   ==Должно выдать примерно следующее== 
   
   `(.dbt_env) PS C:\users\grekhov_sk\khd-2.0\airflow_etl\dags\magn\generator_dbt_model> dbt debug --profiles-dir ./dwh20_test --project-dir ./dwh20_test`
   `11:53:59  Running with dbt=1.9.8`
   `11:53:59  dbt version: 1.9.8`
   `11:53:59  python version: 3.12.4`
   `11:53:59  python path: C:\Users\grekhov_sk\.dbt_env\Scripts\python.exe`
   `11:53:59  os info: Windows-11-10.0.22631-SP0`
   `11:54:00  Using profiles dir at ./dwh20_test`
   `11:54:00  Using profiles.yml file at ./dwh20_test\profiles.yml`
   `11:54:00  Using dbt_project.yml file at dwh20_test\dbt_project.yml`
   `11:54:00  adapter type: impala`
   `11:54:00  adapter version: 1.9.0`
   `11:54:00  Configuration:`
   `11:54:00    profiles.yml file [OK found and valid]`
   `11:54:00    dbt_project.yml file [OK found and valid]`
   `11:54:00  Required dependencies:`
   `11:54:00   - git [OK found]`
   `11:54:00  Connection:`
   `11:54:00    host: impala-tenant-hr.lh-tst.corp.tander.ru`
   `11:54:00    port: 21050`
   `11:54:00    schema: default`
   `11:54:00    username: grekhov_sk`
   `11:54:00  Registered adapter: impala=1.9.0`
   `WARNING:thrift.transport.sslcompat:using legacy validation callback`
   `C:\Users\grekhov_sk\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated self._context = ssl.SSLContext(ssl_version)`
   `11:54:03    Connection test: [OK connection ok]`
   `11:54:03  All checks passed!`
1. Чистим кэш 
```
   Remove-Item -Recurse -Force .\khd-2.0\target
   Remove-Item -Recurse -Force .\khd-2.0\dbt_packages
```
1. Далее тестируем DBT модель начинаем с (==УКАЗАВ КОНКРЕНТУЮ МОДЕЛЬ==) `dbt compile --profiles-dir ./dwh20_test --project-dir ./dwh20_test --select "dwh20_test.hr.base_proto_dm_l1.*" --debug`
   
   ==Выдаст примерно следующее==
   
   13:31:11  Running with dbt=1.9.8
   13:31:11  running dbt with arguments {'printer_width': '80', 'indirect_selection': 'eager', 'log_cache_events': 'False', 'write_json': 'True', 'partial_parse': 'True', 'cache_selected_only': 'False', 'warn_error': 'None', 'fail_fast': 'False', 'profiles_dir': './dwh20_test', 'log_path': 'dwh20_test\\logs', 'debug': 'True', 'version_check': 'True', 'use_colors': 'True', 'use_experimental_parser': 'False', 'empty': 'False', 'quiet': 'False', 'no_print': 'None', 'log_format': 'default', 'introspect': 'True', 'warn_error_options': 'WarnErrorOptions(include=[], exclude=[])', 'static_parser': 'True', 'target_path': 'None', 'invocation_command': 'dbt compile --profiles-dir ./dwh20_test --project-dir ./dwh20_test --select t_hr_indvl_dh_tmp_final --debug', 'send_anonymous_usage_stats': 'False'}
   13:31:11  Registered adapter: impala=1.9.0
   13:31:11  checksum: 2898e47e730fa32147e5ae95c02f42c1d51b8fd2b81922b9b731f0208caf4dff, vars: {}, profile: , target: , version: 1.9.8
   13:31:20  Partial parsing enabled: 0 files deleted, 4 files added, 0 files changed.
   13:31:20  Partial parsing: added file: dwh20_test://models\hr\base_proto_dm_l1\t_hr_indvl_dh\t_hr_indvl_dh_tmp_final.sql
   13:31:20  Partial parsing: added file: dwh20_test://models\hr\base_proto_dm_l1\t_hr_indvl_dh\v_hr_indvl_dh.sql
   13:31:20  Partial parsing: added file: dwh20_test://models\hr\base_proto_dm_l1\t_hr_indvl_dh\t_hr_indvl_dh.sql
   13:31:20  Partial parsing: added file: dwh20_test://models\hr\base_proto_dm_l1\t_hr_indvl_dh\t_hr_indvl_dh.yml
   13:31:27  Wrote artifact WritableManifest to dwh20_test\target\manifest.json
   13:31:27  Wrote artifact SemanticManifest to dwh20_test\target\semantic_manifest.json
   13:31:30  Found 4145 models, 1 operation, 34 data tests, 2468 sources, 495 macros
   13:31:30  
   13:31:30  Concurrency: 1 threads (target='test')
   13:31:30  
   13:31:30  Acquiring new impala connection 'master'
   13:31:30  Acquiring new impala connection 'list_None_default'
   13:31:30  list_tables_in_relation: 
   13:31:30  Using impala connection "list_None_default"
   13:31:30  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:30  Tracker adapter: Skipping Event {'event_type': 'start_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_default"} */\n\n    show tables in default\n  ', 'profile_name': 'dwh20', 'app': 'dbt', 'dbt_version': '1.9.8', 'target_name': 'test', 'connection_name': 'list_None_default'}
   13:31:30  On list_None_default: /* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_default"} */
       show tables in default
     
   13:31:30  Opening a new connection, currently in state init
   13:31:30  Impala adapter: Using user agent: dbt/cloudera-impala-v1.9.0
   WARNING:thrift.transport.sslcompat:using legacy validation callback
   C:\users\grekhov_sk\khd-2.0\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
     self._context = ssl.SSLContext(ssl_version)
   13:31:31  Impala adapter: IMPALA VERSION ImpalaConnectionManager.impala_version
   13:31:31  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:31  Tracker adapter: Skipping Event {'event_type': 'open', 'auth': 'ldap', 'connection_state': <ConnectionState.OPEN: 'open'>, 'elapsed_time': '0.72'}
   13:31:31  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:31  Tracker adapter: Skipping Event {'event_type': 'end_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_default"} */\n\n    show tables in default\n  ', 'elapsed_time': '1.55', 'status': 'OK', 'profile_name': 'dwh20'}
   13:31:31  SQL status: OK in 1.550 seconds
   13:31:32  On list_None_default: Close
   13:31:32  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:32  Tracker adapter: Skipping Event {'event_type': 'close', 'connection_state': <ConnectionState.CLOSED: 'closed'>, 'elapsed_time': '0.17'}
   13:31:32  Re-using an available connection from the pool (formerly list_None_default, now list_None_base_proto_dm_l2)
   13:31:32  list_tables_in_relation: 
   13:31:32  Using impala connection "list_None_base_proto_dm_l2"
   13:31:32  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:32  Tracker adapter: Skipping Event {'event_type': 'start_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l2"} */\n\n    show tables in base_proto_dm_l2\n  ', 'profile_name': 'dwh20', 'app': 'dbt', 'dbt_version': '1.9.8', 'target_name': 'test', 'connection_name': 'list_None_base_proto_dm_l2'}
   13:31:32  On list_None_base_proto_dm_l2: /* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l2"} */
       show tables in base_proto_dm_l2
     
   13:31:32  Opening a new connection, currently in state closed
   13:31:32  Impala adapter: Using user agent: dbt/cloudera-impala-v1.9.0
   C:\users\grekhov_sk\khd-2.0\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
     self._context = ssl.SSLContext(ssl_version)
   13:31:32  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:32  Tracker adapter: Skipping Event {'event_type': 'open', 'auth': 'ldap', 'connection_state': <ConnectionState.OPEN: 'open'>, 'elapsed_time': '0.58'}
   13:31:33  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:33  Tracker adapter: Skipping Event {'event_type': 'end_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l2"} */\n\n    show tables in base_proto_dm_l2\n  ', 'elapsed_time': '0.87', 'status': 'OK', 'profile_name': 'dwh20'}
   13:31:33  SQL status: OK in 0.870 seconds
   13:31:33  On list_None_base_proto_dm_l2: Close
   13:31:33  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:33  Tracker adapter: Skipping Event {'event_type': 'close', 'connection_state': <ConnectionState.CLOSED: 'closed'>, 'elapsed_time': '0.16'}
   13:31:33  Re-using an available connection from the pool (formerly list_None_base_proto_dm_l2, now list_None_business_dm_hr_susm_oco_tmp)
   13:31:33  list_tables_in_relation: 
   13:31:33  Using impala connection "list_None_business_dm_hr_susm_oco_tmp"
   13:31:33  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:33  Tracker adapter: Skipping Event {'event_type': 'start_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_business_dm_hr_susm_oco_tmp"} */\n\n    show tables in business_dm_hr_susm_oco_tmp\n  ', 'profile_name': 'dwh20', 'app': 'dbt', 'dbt_version': '1.9.8', 'target_name': 'test', 'connection_name': 'list_None_business_dm_hr_susm_oco_tmp'}
   13:31:33  On list_None_business_dm_hr_susm_oco_tmp: /* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_business_dm_hr_susm_oco_tmp"} */
       show tables in business_dm_hr_susm_oco_tmp
     
   13:31:33  Opening a new connection, currently in state closed
   13:31:33  Impala adapter: Using user agent: dbt/cloudera-impala-v1.9.0
   C:\users\grekhov_sk\khd-2.0\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
     self._context = ssl.SSLContext(ssl_version)
   13:31:34  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:34  Tracker adapter: Skipping Event {'event_type': 'open', 'auth': 'ldap', 'connection_state': <ConnectionState.OPEN: 'open'>, 'elapsed_time': '0.70'}
   13:31:34  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:34  Tracker adapter: Skipping Event {'event_type': 'end_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_business_dm_hr_susm_oco_tmp"} */\n\n    show tables in business_dm_hr_susm_oco_tmp\n  ', 'elapsed_time': '0.97', 'status': 'OK', 'profile_name': 'dwh20'}
   13:31:34  SQL status: OK in 0.970 seconds
   13:31:34  On list_None_business_dm_hr_susm_oco_tmp: Close
   13:31:34  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:34  Tracker adapter: Skipping Event {'event_type': 'close', 'connection_state': <ConnectionState.CLOSED: 'closed'>, 'elapsed_time': '0.16'}
   13:31:34  Re-using an available connection from the pool (formerly list_None_business_dm_hr_susm_oco_tmp, now list_None_base_proto_dm_l2_tmp)
   13:31:34  list_tables_in_relation: 
   13:31:34  Using impala connection "list_None_base_proto_dm_l2_tmp"
   13:31:34  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:34  Tracker adapter: Skipping Event {'event_type': 'start_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l2_tmp"} */\n\n    show tables in base_proto_dm_l2_tmp\n  ', 'profile_name': 'dwh20', 'app': 'dbt', 'dbt_version': '1.9.8', 'target_name': 'test', 'connection_name': 'list_None_base_proto_dm_l2_tmp'}
   13:31:34  On list_None_base_proto_dm_l2_tmp: /* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l2_tmp"} */
       show tables in base_proto_dm_l2_tmp
     
   13:31:34  Opening a new connection, currently in state closed
   13:31:34  Impala adapter: Using user agent: dbt/cloudera-impala-v1.9.0
   C:\users\grekhov_sk\khd-2.0\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
     self._context = ssl.SSLContext(ssl_version)
   13:31:35  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:35  Tracker adapter: Skipping Event {'event_type': 'open', 'auth': 'ldap', 'connection_state': <ConnectionState.OPEN: 'open'>, 'elapsed_time': '0.62'}
   13:31:35  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:35  Tracker adapter: Skipping Event {'event_type': 'end_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l2_tmp"} */\n\n    show tables in base_proto_dm_l2_tmp\n  ', 'elapsed_time': '0.92', 'status': 'OK', 'profile_name': 'dwh20'}
   13:31:35  SQL status: OK in 0.920 seconds
   13:31:36  On list_None_base_proto_dm_l2_tmp: Close
   13:31:36  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:36  Tracker adapter: Skipping Event {'event_type': 'close', 'connection_state': <ConnectionState.CLOSED: 'closed'>, 'elapsed_time': '0.17'}
   13:31:36  Re-using an available connection from the pool (formerly list_None_base_proto_dm_l2_tmp, now list_None_base_proto_dm_l1)
   13:31:36  list_tables_in_relation: 
   13:31:36  Using impala connection "list_None_base_proto_dm_l1"
   13:31:36  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:36  Tracker adapter: Skipping Event {'event_type': 'start_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l1"} */\n\n    show tables in base_proto_dm_l1\n  ', 'profile_name': 'dwh20', 'app': 'dbt', 'dbt_version': '1.9.8', 'target_name': 'test', 'connection_name': 'list_None_base_proto_dm_l1'}
   13:31:36  On list_None_base_proto_dm_l1: /* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l1"} */
       show tables in base_proto_dm_l1
     
   13:31:36  Opening a new connection, currently in state closed
   13:31:36  Impala adapter: Using user agent: dbt/cloudera-impala-v1.9.0
   C:\users\grekhov_sk\khd-2.0\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
     self._context = ssl.SSLContext(ssl_version)
   13:31:36  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:37  Tracker adapter: Skipping Event {'event_type': 'open', 'auth': 'ldap', 'connection_state': <ConnectionState.OPEN: 'open'>, 'elapsed_time': '0.56'}
   13:31:37  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:37  Tracker adapter: Skipping Event {'event_type': 'end_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l1"} */\n\n    show tables in base_proto_dm_l1\n  ', 'elapsed_time': '1.13', 'status': 'OK', 'profile_name': 'dwh20'}
   13:31:37  SQL status: OK in 1.130 seconds
   13:31:37  On list_None_base_proto_dm_l1: Close
   13:31:37  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:37  Tracker adapter: Skipping Event {'event_type': 'close', 'connection_state': <ConnectionState.CLOSED: 'closed'>, 'elapsed_time': '0.17'}
   13:31:37  Re-using an available connection from the pool (formerly list_None_base_proto_dm_l1, now list_None_business_dm_v_hr_susm_oco)
   13:31:37  list_tables_in_relation: 
   13:31:37  Using impala connection "list_None_business_dm_v_hr_susm_oco"
   13:31:37  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:38  Tracker adapter: Skipping Event {'event_type': 'start_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_business_dm_v_hr_susm_oco"} */\n\n    show tables in business_dm_v_hr_susm_oco\n  ', 'profile_name': 'dwh20', 'app': 'dbt', 'dbt_version': '1.9.8', 'target_name': 'test', 'connection_name': 'list_None_business_dm_v_hr_susm_oco'}
   13:31:38  On list_None_business_dm_v_hr_susm_oco: /* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_business_dm_v_hr_susm_oco"} */
       show tables in business_dm_v_hr_susm_oco
     
   13:31:38  Opening a new connection, currently in state closed
   13:31:38  Impala adapter: Using user agent: dbt/cloudera-impala-v1.9.0
   C:\users\grekhov_sk\khd-2.0\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
     self._context = ssl.SSLContext(ssl_version)
   13:31:38  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:38  Tracker adapter: Skipping Event {'event_type': 'open', 'auth': 'ldap', 'connection_state': <ConnectionState.OPEN: 'open'>, 'elapsed_time': '0.56'}
   13:31:38  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:38  Tracker adapter: Skipping Event {'event_type': 'end_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_business_dm_v_hr_susm_oco"} */\n\n    show tables in business_dm_v_hr_susm_oco\n  ', 'elapsed_time': '0.83', 'status': 'OK', 'profile_name': 'dwh20'}
   13:31:38  SQL status: OK in 0.830 seconds
   13:31:39  On list_None_business_dm_v_hr_susm_oco: Close
   13:31:39  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:39  Tracker adapter: Skipping Event {'event_type': 'close', 'connection_state': <ConnectionState.CLOSED: 'closed'>, 'elapsed_time': '0.17'}
   13:31:39  Re-using an available connection from the pool (formerly list_None_business_dm_v_hr_susm_oco, now list_None_base_dm_v_l2)
   13:31:39  list_tables_in_relation: 
   13:31:39  Using impala connection "list_None_base_dm_v_l2"
   13:31:39  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:39  Tracker adapter: Skipping Event {'event_type': 'start_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_dm_v_l2"} */\n\n    show tables in base_dm_v_l2\n  ', 'profile_name': 'dwh20', 'app': 'dbt', 'dbt_version': '1.9.8', 'target_name': 'test', 'connection_name': 'list_None_base_dm_v_l2'}
   13:31:39  On list_None_base_dm_v_l2: /* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_dm_v_l2"} */
       show tables in base_dm_v_l2
     
   13:31:39  Opening a new connection, currently in state closed
   13:31:39  Impala adapter: Using user agent: dbt/cloudera-impala-v1.9.0
   C:\users\grekhov_sk\khd-2.0\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
     self._context = ssl.SSLContext(ssl_version)
   13:31:39  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:39  Tracker adapter: Skipping Event {'event_type': 'open', 'auth': 'ldap', 'connection_state': <ConnectionState.OPEN: 'open'>, 'elapsed_time': '0.55'}
   13:31:40  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:40  Tracker adapter: Skipping Event {'event_type': 'end_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_dm_v_l2"} */\n\n    show tables in base_dm_v_l2\n  ', 'elapsed_time': '0.93', 'status': 'OK', 'profile_name': 'dwh20'}
   13:31:40  SQL status: OK in 0.930 seconds
   13:31:40  On list_None_base_dm_v_l2: Close
   13:31:40  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:40  Tracker adapter: Skipping Event {'event_type': 'close', 'connection_state': <ConnectionState.CLOSED: 'closed'>, 'elapsed_time': '0.16'}
   13:31:40  Re-using an available connection from the pool (formerly list_None_base_dm_v_l2, now list_None_base_proto_dm_l1_rej)
   13:31:40  list_tables_in_relation: 
   13:31:40  Using impala connection "list_None_base_proto_dm_l1_rej"
   13:31:40  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:40  Tracker adapter: Skipping Event {'event_type': 'start_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l1_rej"} */\n\n    show tables in base_proto_dm_l1_rej\n  ', 'profile_name': 'dwh20', 'app': 'dbt', 'dbt_version': '1.9.8', 'target_name': 'test', 'connection_name': 'list_None_base_proto_dm_l1_rej'}
   13:31:40  On list_None_base_proto_dm_l1_rej: /* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l1_rej"} */
       show tables in base_proto_dm_l1_rej
     
   13:31:40  Opening a new connection, currently in state closed
   13:31:40  Impala adapter: Using user agent: dbt/cloudera-impala-v1.9.0
   C:\users\grekhov_sk\khd-2.0\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
     self._context = ssl.SSLContext(ssl_version)
   13:31:41  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:41  Tracker adapter: Skipping Event {'event_type': 'open', 'auth': 'ldap', 'connection_state': <ConnectionState.OPEN: 'open'>, 'elapsed_time': '0.54'}
   13:31:41  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:41  Tracker adapter: Skipping Event {'event_type': 'end_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l1_rej"} */\n\n    show tables in base_proto_dm_l1_rej\n  ', 'elapsed_time': '0.86', 'status': 'OK', 'profile_name': 'dwh20'}
   13:31:41  SQL status: OK in 0.860 seconds
   13:31:41  On list_None_base_proto_dm_l1_rej: Close
   13:31:41  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:41  Tracker adapter: Skipping Event {'event_type': 'close', 'connection_state': <ConnectionState.CLOSED: 'closed'>, 'elapsed_time': '0.16'}
   13:31:41  Re-using an available connection from the pool (formerly list_None_base_proto_dm_l1_rej, now list_None_business_dm_hr_susm_oco)
   13:31:41  list_tables_in_relation: 
   13:31:41  Using impala connection "list_None_business_dm_hr_susm_oco"
   13:31:41  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:41  Tracker adapter: Skipping Event {'event_type': 'start_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_business_dm_hr_susm_oco"} */\n\n    show tables in business_dm_hr_susm_oco\n  ', 'profile_name': 'dwh20', 'app': 'dbt', 'dbt_version': '1.9.8', 'target_name': 'test', 'connection_name': 'list_None_business_dm_hr_susm_oco'}
   13:31:41  On list_None_business_dm_hr_susm_oco: /* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_business_dm_hr_susm_oco"} */
       show tables in business_dm_hr_susm_oco
     
   13:31:41  Opening a new connection, currently in state closed
   13:31:41  Impala adapter: Using user agent: dbt/cloudera-impala-v1.9.0
   C:\users\grekhov_sk\khd-2.0\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
     self._context = ssl.SSLContext(ssl_version)
   13:31:42  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:42  Tracker adapter: Skipping Event {'event_type': 'open', 'auth': 'ldap', 'connection_state': <ConnectionState.OPEN: 'open'>, 'elapsed_time': '0.56'}
   13:31:42  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:42  Tracker adapter: Skipping Event {'event_type': 'end_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_business_dm_hr_susm_oco"} */\n\n    show tables in business_dm_hr_susm_oco\n  ', 'elapsed_time': '0.88', 'status': 'OK', 'profile_name': 'dwh20'}
   13:31:42  SQL status: OK in 0.880 seconds
   13:31:43  On list_None_business_dm_hr_susm_oco: Close
   13:31:43  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:43  Tracker adapter: Skipping Event {'event_type': 'close', 'connection_state': <ConnectionState.CLOSED: 'closed'>, 'elapsed_time': '0.16'}
   13:31:43  Re-using an available connection from the pool (formerly list_None_business_dm_hr_susm_oco, now list_None_base_proto_dm_l1_tmp)
   13:31:43  list_tables_in_relation: t_hr_indvl_dh_tmp_final, t_hr_indvl_dh_tmp_final__dbt_tmp, t_hr_indvl_dh_tmp_final__dbt_swap
   13:31:43  Using impala connection "list_None_base_proto_dm_l1_tmp"
   13:31:43  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:43  Tracker adapter: Skipping Event {'event_type': 'start_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l1_tmp"} */\n\n    show tables in base_proto_dm_l1_tmp\n  ', 'profile_name': 'dwh20', 'app': 'dbt', 'dbt_version': '1.9.8', 'target_name': 'test', 'connection_name': 'list_None_base_proto_dm_l1_tmp'}
   13:31:43  On list_None_base_proto_dm_l1_tmp: /* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l1_tmp"} */
       show tables in base_proto_dm_l1_tmp
     
   13:31:43  Opening a new connection, currently in state closed
   13:31:43  Impala adapter: Using user agent: dbt/cloudera-impala-v1.9.0
   C:\users\grekhov_sk\khd-2.0\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
     self._context = ssl.SSLContext(ssl_version)
   13:31:44  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:44  Tracker adapter: Skipping Event {'event_type': 'open', 'auth': 'ldap', 'connection_state': <ConnectionState.OPEN: 'open'>, 'elapsed_time': '0.65'}
   13:31:44  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:44  Tracker adapter: Skipping Event {'event_type': 'end_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_proto_dm_l1_tmp"} */\n\n    show tables in base_proto_dm_l1_tmp\n  ', 'elapsed_time': '1.41', 'status': 'OK', 'profile_name': 'dwh20'}
   13:31:44  SQL status: OK in 1.410 seconds
   13:31:45  On list_None_base_proto_dm_l1_tmp: Close
   13:31:45  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:45  Tracker adapter: Skipping Event {'event_type': 'close', 'connection_state': <ConnectionState.CLOSED: 'closed'>, 'elapsed_time': '0.17'}
   13:31:45  Re-using an available connection from the pool (formerly list_None_base_proto_dm_l1_tmp, now list_None_base_dm_v_l1)
   13:31:45  list_tables_in_relation: 
   13:31:45  Using impala connection "list_None_base_dm_v_l1"
   13:31:45  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:45  Tracker adapter: Skipping Event {'event_type': 'start_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_dm_v_l1"} */\n\n    show tables in base_dm_v_l1\n  ', 'profile_name': 'dwh20', 'app': 'dbt', 'dbt_version': '1.9.8', 'target_name': 'test', 'connection_name': 'list_None_base_dm_v_l1'}
   13:31:45  On list_None_base_dm_v_l1: /* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_dm_v_l1"} */
       show tables in base_dm_v_l1
     
   13:31:45  Opening a new connection, currently in state closed
   13:31:45  Impala adapter: Using user agent: dbt/cloudera-impala-v1.9.0
   C:\users\grekhov_sk\khd-2.0\.dbt_env\Lib\site-packages\thrift\transport\TSSLSocket.py:53: DeprecationWarning: ssl.PROTOCOL_TLS is deprecated
     self._context = ssl.SSLContext(ssl_version)
   13:31:45  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:45  Tracker adapter: Skipping Event {'event_type': 'open', 'auth': 'ldap', 'connection_state': <ConnectionState.OPEN: 'open'>, 'elapsed_time': '0.58'}
   13:31:46  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:46  Tracker adapter: Skipping Event {'event_type': 'end_query', 'sql': '/* {"app": "dbt", "dbt_version": "1.9.8", "profile_name": "dwh20", "target_name": "test", "connection_name": "list_None_base_dm_v_l1"} */\n\n    show tables in base_dm_v_l1\n  ', 'elapsed_time': '1.44', 'status': 'OK', 'profile_name': 'dwh20'}
   13:31:46  SQL status: OK in 1.440 seconds
   13:31:47  On list_None_base_dm_v_l1: Close
   13:31:47  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:47  Tracker adapter: Skipping Event {'event_type': 'close', 'connection_state': <ConnectionState.CLOSED: 'closed'>, 'elapsed_time': '0.18'}
   13:31:47  Began running node model.dwh20_test.t_hr_indvl_dh_tmp_final
   13:31:47  Acquiring new impala connection 'model.dwh20_test.t_hr_indvl_dh_tmp_final'
   13:31:47  Began compiling node model.dwh20_test.t_hr_indvl_dh_tmp_final
   13:31:47  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:47  Tracker adapter: Skipping Event {'event_type': 'model_access', 'model_name': '__dbt__cte__rawv_1003_000_hrl3_flex__v_zdbv_person_j', 'model_type': <RelationType.CTE: 'cte'>, 'incremental_strategy': ''}
   13:31:47  Tracker adapter: Usage tracking flag False. To turn on/off use usage_tracking flag in profiles.yml
   13:31:47  Tracker adapter: Skipping Event {'event_type': 'model_access', 'model_name': '__dbt__cte__rawv_1003_000_hrl3_flex__v_zdbv_person_j', 'model_type': <RelationType.CTE: 'cte'>, 'incremental_strategy': ''}
   13:31:47  Writing injected SQL for node "model.dwh20_test.t_hr_indvl_dh_tmp_final"
   13:31:47  Writing injected SQL for node "model.dwh20_test.t_hr_indvl_dh_tmp_final"
   13:31:47  Began executing node model.dwh20_test.t_hr_indvl_dh_tmp_final
   13:31:47  Finished running node model.dwh20_test.t_hr_indvl_dh_tmp_final
   13:31:47  Connection 'master' was properly closed.
   13:31:47  Connection 'list_None_base_dm_v_l1' was properly closed.
   13:31:47  Connection 'model.dwh20_test.t_hr_indvl_dh_tmp_final' was properly closed.
   13:31:47  Command end result
   13:31:52  Wrote artifact WritableManifest to dwh20_test\target\manifest.json
   13:31:52  Wrote artifact SemanticManifest to dwh20_test\target\semantic_manifest.json
   13:31:52  Wrote artifact RunExecutionResult to dwh20_test\target\run_results.json
   Compiled node 't_hr_indvl_dh_tmp_final' is:
   with  __dbt__cte__rawv_1003_000_hrl3_flex__v_zdbv_person_j as (
   SELECT guidpers
        , begda
        , endda
        , system
        , code
        , kis_code
        , fio
        , lastname
        , firstname
        , middlname
        , initials
        , sex
        , birthday
        , snils
        , inn
        , natio
        , specbirthplace
        , birthplace
        , ewbook
        , isdel
        , chngtmst
        , etl_batch_id
        , journal_id
        , tech_operation_cd
        , tech_ogg_processed_dttm
        , tech_scn
        , tech_source_dttm
        , tech_captured_dttm
        , tech_kafka_offset_num
        , tech_kafka_partition_num
        , tech_changed_dttm
        , tech_source_table_type_cd
     FROM rawv_1003_000_hrl3_flex.v_zdbv_person_j
   ), raw_data_query as (
           select
                  case when (replace(replace(trim(cast (j.guidpers as string)),'-',''), '0', '') = '') then null else upper(replace(trim(cast (j.guidpers as string)),'-','')) end as hr_indvl_guid,
                  j.inn as hr_indvl_inn_num,
                  j.firstname  as hr_indvl_first_name,
                  j.lastname as hr_indvl_last_name,
                  j.middlname as hr_indvl_middle_name,
                  j.fio as hr_indvl_full_name,
                  j.initials as hr_indvl_initls_name,
                  j.birthday as hr_indvl_birth_day_dt,
                  j.sex as hr_indvl_gender_name,
                  j.code as hr_indvl_zup_code_num,
                  j.kiscode as hr_indvl_kis_code_num,
                  j.snils as hr_indvl_ssn_num,
                  j.natio as hr_indvl_ntnlty_name,
                  j.birthplace as hr_indvl_birth_place_name,
                  case j.specbirthplace when 1 then TRUE when 0 then FALSE end as hr_indvl_spcl_birth_place_flg,
                  case j.ewbook when 1 then TRUE when 0 then FALSE end as hr_indvl_ebook_flg,
                  j.begda as hr_indvl_start_dt,
                  j.endda as hr_indvl_end_dt,
                  j.system as hr_indvl_sys_name,
                  j.chngtmst as hr_indvl_last_changed_dttm,
                  case j.isdel when 1 then TRUE when 0 then FALSE end as hr_indvl_del_flg,
                  cast (/*атрибут hr_indvl_sid не загружается из системы HR MDM*/ null as bigint) as hr_indvl_sid, -- TODO:
                  cast ('default' as string) as bk_collision_code,
                  case when (replace(replace(trim(cast (j.guidpers as string)), '-', ''), '0', '') = '') then null else upper(replace(trim(cast (j.guidpers as string)), '-', '')) end as hr_indvl_bk,
                  cast (null as timestamp) as tech_valid_from_dttm, -- TODO:
                  cast (null as timestamp) as tech_valid_to_dttm, -- TODO:
                  case when tech_operation_cd = 'D' then true else false end as tech_deleted_flg,
                  cast (14/*HR MDM*/ as int) as tech_source_id,
                  cast (-1 as bigint) as etl_batch_id,
                  cast (current_timestamp() as timestamp) as tech_changed_dttm,
                  j.tech_captured_dttm as tech_captured_dttm
             -- from rawv_сюда_подставить_схему для источника 14 1003 HR MDM.v_сюда_подставить_таблицу src
             from __dbt__cte__rawv_1003_000_hrl3_flex__v_zdbv_person_j as j
             where COALESCE(case when (replace(replace(trim(cast (j.guidpers null as string)), '-', ''), '0', '') = '') then null else upper(replace(trim(cast (j.guidpers as string)), '-', '')) end, '') <> ''
   ),
   base_query as (
          select
                 md5(concat(rd.hr_indvl_bk,'||',rd.bk_collision_code)) as md5_hash,
                 rd.hr_indvl_guid,
                 rd.hr_indvl_inn_num,
                 rd.hr_indvl_first_name,
                 rd.hr_indvl_last_name,
                 rd.hr_indvl_middle_name,
                 rd.hr_indvl_full_name,
                 rd.hr_indvl_initls_name,
                 rd.hr_indvl_birth_day_dt,
                 rd.hr_indvl_gender_name,
                 rd.hr_indvl_zup_code_num,
                 rd.hr_indvl_kis_code_num,
                 rd.hr_indvl_ssn_num,
                 rd.hr_indvl_ntnlty_name,
                 rd.hr_indvl_birth_place_name,
                 rd.hr_indvl_spcl_birth_place_flg,
                 rd.hr_indvl_ebook_flg,
                 rd.hr_indvl_start_dt,
                 rd.hr_indvl_end_dt,
                 rd.hr_indvl_sys_name,
                 rd.hr_indvl_last_changed_dttm,
                 rd.hr_indvl_del_flg,
                 rd.hr_indvl_sid,
                 rd.bk_collision_code,
                 rd.hr_indvl_bk,
                 rd.tech_valid_from_dttm,
                 rd.tech_valid_to_dttm,
                 rd.tech_deleted_flg,
                 rd.tech_source_id,
                 rd.etl_batch_id,
                 rd.tech_changed_dttm,
                 rd.tech_captured_dttm
            from raw_data_query rd
   )
   select
          --bq.md5_hash,
          
       
       bitand(cast(
               case
                   when ((cast(conv(left(md5(md5_hash), 8), 16, 10) as decimal(38, 0)) * cast(power(2, 32) as decimal(38, 0))) + cast(conv(right(left(md5(md5_hash), 16), 8), 16, 10) as decimal(38, 0))) > cast(9223372036854775807 as decimal(38, 0)) then
                        ((cast(conv(left(md5(md5_hash), 8), 16, 10) as decimal(38, 0)) * cast(power(2, 32) as decimal(38, 0))) + cast(conv(right(left(md5(md5_hash), 16), 8), 16, 10) as decimal(38, 0))) - cast(18446744073709551616 as decimal(38, 0))
                   else
                        ((cast(conv(left(md5(md5_hash), 8), 16, 10) as decimal(38, 0)) * cast(power(2, 32) as decimal(38, 0))) + cast(conv(right(left(md5(md5_hash), 16), 8), 16, 10) as decimal(38, 0)))
               end
               as bigint),
       9223372036854775807)
        as hr_indvl_1_hash_key,
          
       
       bitand(cast(
               case
                   when ((cast(conv(left(right(md5(md5_hash), 16), 8), 16, 10) as decimal(38,0)) * cast(power(2,32) as decimal(38,0))) + cast(conv(right(md5(md5_hash), 8) , 16, 10) as decimal(38,0))) > cast(9223372036854775807 as decimal(38,0)) then
                       ((cast(conv(left(right(md5(md5_hash), 16), 8), 16, 10) as decimal(38,0)) * cast(power(2,32) as decimal(38,0))) + cast(conv(right(md5(md5_hash), 8) , 16, 10) as decimal(38,0))) - cast(18446744073709551616 as decimal(38,0))
                   else
                       ((cast(conv(left(right(md5(md5_hash), 16), 8), 16, 10) as decimal(38,0)) * cast(power(2,32) as decimal(38,0))) + cast(conv(right(md5(md5_hash), 8) , 16, 10) as decimal(38,0)))
               end
               as bigint), 
       9223372036854775807)
        as hr_indvl_2_hash_key,
          bq.hr_indvl_guid,
          bq.hr_indvl_inn_num,
          bq.hr_indvl_first_name,
          bq.hr_indvl_last_name,
          bq.hr_indvl_middle_name,
          bq.hr_indvl_full_name,
          bq.hr_indvl_initls_name,
          bq.hr_indvl_birth_day_dt,
          bq.hr_indvl_gender_name,
          bq.hr_indvl_zup_code_num,
          bq.hr_indvl_kis_code_num,
          bq.hr_indvl_ssn_num,
          bq.hr_indvl_ntnlty_name,
          bq.hr_indvl_birth_place_name,
          bq.hr_indvl_spcl_birth_place_flg,
          bq.hr_indvl_ebook_flg,
          bq.hr_indvl_start_dt,
          bq.hr_indvl_end_dt,
          bq.hr_indvl_sys_name,
          bq.hr_indvl_last_changed_dttm,
          bq.hr_indvl_del_flg,
          bq.hr_indvl_sid,
          bq.bk_collision_code,
          bq.hr_indvl_bk,
          bq.tech_valid_from_dttm,
          bq.tech_valid_to_dttm,
          bq.tech_deleted_flg,
          bq.tech_source_id,
          bq.etl_batch_id,
          bq.tech_changed_dttm,
          bq.tech_captured_dttm
     from base_query bq
   13:31:52  Command `dbt compile` succeeded at 16:31:52.759062 after 41.66 seconds
   13:31:52  Flushing usage events
2. Скомпилированные объекты появятся в `C:\users\grekhov_sk\khd-2.0\airflow_etl\dags\magn\generator_dbt_model\dwh20_test\target`
3. Пробуем запустить модель `dbt run --profiles-dir ./dwh20_test --project-dir ./dwh20_test --select t_hr_indvl_dh_tmp_final --vars "{hooks_enabled: false}"`
4. А так можно запустить все модели из папки и определенного слоя `dbt run --profiles-dir ./dwh20_test --project-dir ./dwh20_test --select "dwh20_test.hr.base_proto_dm_l1.t_hr_indvl*" --vars "{hooks_enabled: false}"`