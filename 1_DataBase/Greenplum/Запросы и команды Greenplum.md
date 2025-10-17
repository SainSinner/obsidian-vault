###### Функции в GP
[Summary of Built-in Functions](https://docs.vmware.com/en/VMware-Greenplum/7/greenplum-database/ref_guide-function-summary.html)
###### IS DISTINCT FROM
"IS DISTINCT FROM" - это оператор сравнения в SQL, который используется для проверки неравенства двух значений. Он похож на оператор "!=" или "<>" в некоторых других языках запросов.  
Однако основное отличие между "IS DISTINCT FROM" и стандартными операторами неравенства заключается в обработке NULL значений. В отличие от стандартных операторов неравенства, которые рассматривают NULL как неопределенное или неизвестное значение и могут приводить к неопределенным результатам при сравнении с NULL, "IS DISTINCT FROM" считает NULL значения различными.

```sql
-- вернет строки в которых указанные столбцы отличаются друг от друга
        where
             new_rows.memberof is distinct from actual_rows.memberof
```

###### WHERE 1=1
Упрощение динамических запросов: Когда SQL-запрос строится динамически (например, при добавлении дополнительных условий на основе условий пользователя или других факторов), использование WHERE 1=1 позволяет добавлять дополнительные условия сразу после WHERE, не беспокоясь о том, нужно ли добавлять перед этим первое условие или нет.

```sql
SELECT *
FROM table
WHERE 1=1
AND column1 = 'value1'
AND column2 = 'value2'
```
###### DESC (сортировка дат)
"DESC" - данные будут отсортированы в обратном порядке — свежие даты выше.
###### Исключить 0 из расчета среднего
При расчете показателя может понадобиться исключить 0 из расчета среднего.
```sql
-- расчет среднего с учетом 0
avg(tp.total_material_costs)
-- расчет среднего без учета 0
avg(CASE WHEN tp.total_material_costs <> 0 THEN tp.total_material_costs END)
```
###### Данные по занимаемому месту таблицами в Greenplum
При недостатке свободного места в базе данных, можно проверить какие таблицы занимают больше всего места.
```sql
SELECT
    schemaname AS schema_name,
    tablename AS table_name,
    ROUND(pg_total_relation_size('"' || schemaname || '"."' || tablename || '"') / (1024.0 * 1024.0),
    2) AS total_table_size_MB
FROM
    pg_tables
ORDER BY
    3 DESC
```
###### Cколько занимает места на диске определенная таблица?
на примере 2 видов одной и той же таблицы
```sql
SELECT  
    pg_size_pretty(pg_relation_size('main.erp.transfer_report_19'))        AS compress  
  , pg_size_pretty(pg_relation_size('main.erp.transfer_report_19_buffer')) AS orig;
```
###### Распределение хранения таблицы по сегментам кластера в Greenplum
```sql
SELECT  
    gp_segment_id  
  , count(1) AS count  
FROM  
    erp.transfer_report_19  
GROUP BY  
    gp_segment_id;
```

#### Что такое COALESCE в Greenplum?

**COALESCE** — это функция SQL, которая используется для обработки значений NULL. Она возвращает первое ненулевое значение из списка аргументов. Если все аргументы равны NULL, функция вернет NULL. Это особенно полезно в запросах, где необходимо заменить NULL на другое значение или выбрать первое доступное значение из нескольких колонок.

Например, в Greenplum, как и в других системах управления базами данных, вы можете использовать COALESCE следующим образом:

```sql
SELECT COALESCE(column1, column2, 'default_value') AS result
FROM your_table;
```

В этом примере функция COALESCE проверяет `column1` и `column2`, и если оба значения равны NULL, она вернет `'default_value'`. 

Таким образом, COALESCE помогает улучшить обработку данных и избегать проблем, связанных с отсутствующими значениями.

#### Количество строк во всех таблицах в определенной схеме в Greenplum?
```sql
SELECT  
    schemaname,  
    relname AS table_name,  
    n_live_tup AS row_count  
FROM  
    pg_stat_user_tables  
WHERE  
    schemaname = 'erp'  
ORDER BY n_live_tup;
```
#### Тип данных каждого столбца определенного представления и максимальное количество знаков по каждому столбцу?
```sql
SELECT  
    column_name,  
    data_type,  
    COALESCE(character_maximum_length, numeric_precision, datetime_precision) AS max_length  
FROM  
    information_schema.columns  
WHERE  
    table_schema = 'illinois_export'  
    AND table_name = 'erp_distributors_branches';
```
У столбцов с text будет NULL, чтобы и это восполнить, нужно написать динамический запрос, который вернет пачку запросов, такой как ниже
```sql
SELECT  
    concat(string_agg(  
                   'SELECT ''' || column_name || ''' as table_name, max(length("' || column_name ||  
                   '" )) AS max_length FROM ' ||  
                   table_schema || '.' || table_name, ' UNION ALL '), ';')  
FROM  
    information_schema.columns  
WHERE  
      table_schema = 'illinois_export'  
  AND table_name = 'erp_distributors_branches'  
  AND data_type NOT IN ('bigint');
```
#### Проверить количество NULL по каждому столбцу?
```sql
SELECT  
    concat('SELECT ', string_agg(  
            'COUNT(CASE WHEN "' || column_name || '"  IS NULL THEN 1 END) AS "' || column_name || '", '),  
           ' FROM illinois_export.erp_distributors_branches;')  
FROM  
    information_schema.columns  
WHERE  
      table_schema = 'illinois_export'  
  AND table_name = 'erp_distributors_branches';
```
#### Иерархия в Greenplum
```sql
-- region “ВыгрузкаИзHRMвELMA_04032024_СВакансиями_анализ (002)” иерархия по  t2.route_parent_guid = r.route_guid  
WITH  
    RECURSIVE r AS (  
   SELECT route_guid, route_parent_guid, employee, route, CAST (route AS TEXT) AS path, 1 AS LEVEL  
   FROM hrm_cur.transfer_employees  
   -- Отправная строка  
   WHERE route_guid = 'd1daa3f4-8ee0-11ee-80dd-dcf401e534c0'  
  
   UNION ALL  
  
   SELECT t2.route_guid, t2.route_parent_guid, t2.employee, t2.route, CAST (path ||'->'|| t2.route AS TEXT), r.level + 1 AS LEVEL  
   FROM hrm_cur.transfer_employees AS t2  
      JOIN r  
          ON t2.route_parent_guid = r.route_guid  
)  
  
SELECT * FROM r ORDER BY LEVEL;  
  
-- endregion  
-- region Определяем сколько у иерархии уровней по t2.route_parent_guid = t1.route_guid и формируем запрос с построением понятной иерархии  
DO $$  
    DECLARE  
        -- join  
        query_join_base              text    := 'SELECT t1.route FROM hrm_cur.transfer_employees AS t1';  
        query_join_template          text    := ' JOIN hrm_cur.transfer_employees AS t%s ON t%s.route_parent_guid = t%s.route_guid';  
        query_join_final             text;  
        stop_join                    boolean := TRUE;  
        query_join_final_count_rows  bigint;  
        level_join                   integer := 2;  
        -- left join  
        query_left_join_base         text    := ' FROM hrm_cur.transfer_employees AS t1 ';  
        query_left_join_template     text    := ' LEFT JOIN hrm_cur.transfer_employees AS t%s ON t%s.route_parent_guid = t%s.route_guid';  
        query_alias_left_join_base   text    := 'select t1.route as t1_route, t1.employee as t1_employee';  
        query_alias_left_join        text    := ', t%s.route as t%s_route, t%s.employee as t%s_employee';  
        stop_left_join               boolean := FALSE;  
        level_left_join              integer := 2;  
        query_left_join_final        text    := '';  
        query_left_join_final_filter text    := ' WHERE t1.route_guid = ''d1daa3f4-8ee0-11ee-80dd-dcf401e534c0''';  
        -- temporary table from left join  
        -- temporary_table_base text := 'CREATE TEMPORARY TABLE employees_hierarchy_temporary_table (%s) ON COMMIT PRESERVE ROWS';        -- temporary_table_columns text := 't%s_route text, t%s_employee text';    BEGIN  
        WHILE stop_join  
            LOOP  
                query_join_base :=  
                        query_join_base || format(query_join_template, level_join, level_join, level_join - 1);  
                query_join_final := format('WITH query as (%s) select count(*) from query', query_join_base);  
                EXECUTE query_join_final INTO query_join_final_count_rows;  
                IF query_join_final_count_rows = 0  
                THEN  
                    stop_join := FALSE;  
                ELSE  
                    level_join := level_join + 1;  
                    END IF;  
            END LOOP;  
        RAISE NOTICE 'Запрос возвращающий 0 строк:';  
        RAISE NOTICE '%', query_join_base;  
        RAISE NOTICE '% итераций для запроса', level_join - 2;  
        WHILE stop_left_join <> TRUE  
            LOOP                query_alias_left_join_base :=  
                        query_alias_left_join_base ||  
                        format(query_alias_left_join, level_left_join, level_left_join, level_left_join,  
                               level_left_join);  
                query_left_join_base :=  
                        query_left_join_base ||  
                        format(query_left_join_template, level_left_join, level_left_join, level_left_join - 1);  
                IF level_left_join = level_join - 1  
                THEN  
                    stop_left_join := TRUE;  
                ELSE  
                    level_left_join := level_left_join + 1;  
                    END IF;  
            END LOOP;  
        query_left_join_final := query_alias_left_join_base || query_left_join_base || query_left_join_final_filter;  
        RAISE NOTICE 'Запрос возвращающий иерархию:';  
        RAISE NOTICE '%', query_left_join_final;  
        RAISE NOTICE '% итераций для запроса', level_left_join - 2;  
    END $$;  
-- endregion  
-- region Это статичный запрос демонстрируеющий иерархию по t2.route_parent_guid = t1.route_guid  
SELECT  
    t1.route    AS t1_route  
  , t1.employee AS t1_employee  
  , t2.route    AS t2_route  
  , t2.employee AS t2_employee  
  , t3.route    AS t3_route  
  , t3.employee AS t3_employee  
  , t4.route    AS t4_route  
  , t4.employee AS t4_employee  
  , t5.route    AS t5_route  
  , t5.employee AS t5_employee  
  , t6.route    AS t6_route  
  , t6.employee AS t6_employee  
  , t7.route    AS t7_route  
  , t7.employee AS t7_employee  
  , t8.route    AS t8_route  
  , t8.employee AS t8_employee  
FROM  
    hrm_cur.transfer_employees AS t1  
        LEFT JOIN hrm_cur.transfer_employees AS t2 ON t2.route_parent_guid = t1.route_guid  
        LEFT JOIN hrm_cur.transfer_employees AS t3 ON t3.route_parent_guid = t2.route_guid  
        LEFT JOIN hrm_cur.transfer_employees AS t4 ON t4.route_parent_guid = t3.route_guid  
        LEFT JOIN hrm_cur.transfer_employees AS t5 ON t5.route_parent_guid = t4.route_guid  
        LEFT JOIN hrm_cur.transfer_employees AS t6 ON t6.route_parent_guid = t5.route_guid  
        LEFT JOIN hrm_cur.transfer_employees AS t7 ON t7.route_parent_guid = t6.route_guid  
        LEFT JOIN hrm_cur.transfer_employees AS t8 ON t8.route_parent_guid = t7.route_guid  
WHERE  
    t1.route_guid = 'd1daa3f4-8ee0-11ee-80dd-dcf401e534c0';  
-- endregion
```

#### Системные каталоги в PostgreSQL/Greenplum
[PostgreSQL : Документация: 12: 51.11. pg_class : Компания Postgres Professional](https://postgrespro.ru/docs/postgresql/12/catalog-pg-class)
[Postgres Pro Standard : Документация: 9.5: 49.7. pg_attribute : Компания Postgres Professional](https://postgrespro.ru/docs/postgrespro/9.5/catalog-pg-attribute)
##### **`pg_class` + `pg_attribute`**

- **Что это?**
    
    - Это системные таблицы PostgreSQL/Greenplum, которые хранят низкоуровневые метаданные о всех объектах базы данных.
    - `pg_class` содержит информацию о таблицах, индексах, последовательностях и других объектах.
    - `pg_attribute` содержит информацию о столбцах всех таблиц (включая системные).
- **Особенности:**
    
    - Предоставляет доступ ко всей внутренней информации базы данных.
    - Полезно для глубокого анализа, оптимизации и администрирования.
    - Позволяет работать с объектами, не завися от стандартов SQL.
- **Основные колонки:**
    
    - `pg_class`: `relname` (имя объекта), `relkind` (тип объекта), `relnamespace` (схема), `reltype`, и т.д.
    - `pg_attribute`: `attname` (имя столбца), `atttypid` (тип данных), `attlen` (длина), `attnotnull` (NOT NULL), `attnum` (позиция столбца), и т.д.
- **Минусы:**
    
    - Более сложен в использовании (нужно связывать несколько таблиц, таких как `pg_class`, `pg_namespace`, `pg_type`, и т.д.).
    - Не фильтрует данные по правам доступа пользователя, поэтому нужны дополнительные проверки.

##### Список столбцов временной таблицы
```sql
-- region Получаем список столбцов временной таблицы для вставки в нее d события  
SELECT  
    string_agg(  
            a.attname, ', '  
            ORDER BY a.attnum)  
INTO  
    data_fresh_columns  
FROM  
    pg_attribute a  
        INNER JOIN pg_class c ON a.attrelid = c.oid  
WHERE  
      c.relname = 'data_fresh' -- Название временной таблицы  
  AND c.relnamespace = pg_my_temp_schema() -- Схема текущей временной таблицы  
  AND a.attnum > 0 -- Исключаем системные столбцы  
  AND NOT a.attisdropped;  
-- endregion  
-- region Получаем список столбцов актуального вида исторической таблицы для вставки события d в временную таблицу  
SELECT  
    concat('  
  ''d''  
  , process_uuid_actual_sync  , process_schema_version_delete  , process_task_dtm_delete  , process_uuid_actual_sync  , process_task_row_count_delete  , ', string_agg(  
            'data_cur.' || column_name, ', '  
            ORDER BY ordinal_position))  
INTO  
    target_cur_columns  
FROM  
    information_schema.columns  
WHERE  
      table_schema = target_cur_schema  
  AND table_name = target_cur_table  
  AND column_name <> ALL (columns_technical);  
-- endregion
```

##### Присвоить значение динамического запроса переменной

```sql
DO $$  
    DECLARE  
        process_uuid_delete      uuid[];  
        process_task_dtm_delete  date;  
        process_start_timestamp  timestamp;  
        process_end_timestamp    timestamp;  
        condition_event_type_u   text;  
        -- переменные ниже используются при ручном течитровании через do  
        process_uuid_actual_sync uuid := '3049e9cc-cde3-4fd7-9b4c-118ea99c7e28';  
        buffer_schema            text := 'erp';  
        buffer_table             text := 'query_settings_transfer_nifi_buffer';  
    BEGIN  
        RAISE NOTICE 'Значение переменной process_uuid_actual_sync: %', process_uuid_actual_sync;  
        EXECUTE format('SELECT  
        task_dtm    FROM        %I.%I    WHERE        task_guid = %L    ORDER BY        task_dtm    LIMIT 1;', buffer_schema, buffer_table, process_uuid_actual_sync)  
        INTO process_task_dtm_delete;  
        RAISE NOTICE 'Значение переменной process_task_dtm_delete: %', process_task_dtm_delete;  
  
    END $$;
```

##### Просмотр описания данных по временной таблице  
```sql
SELECT  
    attname AS column_name,  
    attnum AS ordinal_position,  
    format_type(atttypid, atttypmod) AS data_type  
FROM  
    pg_attribute  
WHERE  
    attrelid = 'pg_temp.test_articul'::regclass  
    AND attnum > 0  
    AND NOT attisdropped  
ORDER BY  
    attnum;
```