#### Через утилиту gpfdist
в консоли машины greenplum:

1. зайти под пользователем который может запустить `gpfdist`

`sudo su - gpadmin`

2. проверить запущенные `gpfdist`

`ps ax | grep gpfdist`

3. на свободном порту запустить `gpfdist` в интересующей нас директории

`gpfdist -d /data1/master/gpseg-1/pg_log/ -p 8082 &`

4. в консоли Greenplum запустить скрипт подобный нижнему
```sql
DROP EXTERNAL TABLE IF EXISTS gp_log;
CREATE EXTERNAL TABLE gp_log (
    column1 TEXT,
    column2 TEXT,
    column3 TEXT,
    column4 TEXT,
    column5 TEXT,
    column6 TEXT,
    column7 TEXT,
    column8 TEXT,
    column9 TEXT,
    column10 TEXT,
    column11 TEXT,
    column12 TEXT,
    column13 TEXT,
    column14 TEXT,
    column15 TEXT,
    column16 TEXT,
    column17 TEXT,
    column18 TEXT,
    column19 TEXT,
    column20 TEXT,
    column21 TEXT,
    column22 TEXT,
    column23 TEXT,
    column24 TEXT,
    column25 TEXT,
    column26 TEXT,
    column27 TEXT,
    column28 TEXT,
    column29 TEXT,
    column30 TEXT
)
LOCATION ('gpfdist://green0t-dtln.ovp.ru:8082/gpdb-2024-06-23_000000.csv')
FORMAT 'CSV' (DELIMITER ',');

SELECT * FROM gp_log LIMIT 3;
```
#### Через file
В консоли Greenplum запустить скрипт подобный нижнему, но этот вариант у меня не сработал на main ноде, только на 1 и 2.

```sql
DROP EXTERNAL TABLE IF EXISTS gp_log;
CREATE EXTERNAL TABLE gp_log (
    column1 TEXT,
    column2 TEXT,
    column3 TEXT,
    column4 TEXT,
    column5 TEXT,
    column6 TEXT,
    column7 TEXT,
    column8 TEXT,
    column9 TEXT,
    column10 TEXT,
    column11 TEXT,
    column12 TEXT,
    column13 TEXT,
    column14 TEXT,
    column15 TEXT,
    column16 TEXT,
    column17 TEXT,
    column18 TEXT,
    column19 TEXT,
    column20 TEXT,
    column21 TEXT,
    column22 TEXT,
    column23 TEXT,
    column24 TEXT,
    column25 TEXT,
    column26 TEXT,
    column27 TEXT,
    column28 TEXT,
    column29 TEXT,
    column30 TEXT
)
LOCATION ('file://green1t-dtln.ovp.ru:5432/data1/primary/gpseg0/pg_log/gpdb-2024-06-21_000000.csv')
FORMAT 'CSV' (DELIMITER ',');

SELECT * FROM gp_log LIMIT 3;
```
#### Как используется * в `gpfdist`  
при указании LOCATION `('gpfdist://green0t-dtln.ovp.ru:8082/gpdb-2024-06-23_000000.csv')` мы можем использовать * следующим образом `('gpfdist://green0t-dtln.ovp.ru:8082/gpdb*.csv')`  
Если существует файл удовлетворяющий запросу он нам вернется, однако, если существует более 1 файла удовлетворяющего условию - возникнет ошибка.

Необходимо перечислять файлы следующим образом, тогда они объединяются в один запрос:  
`LOCATION ('gpfdist://green0t-dtln.ovp.ru:8082/gpdb-2024-06-22_0.csv',   'gpfdist://green0t-dtln.ovp.ru:8082/gpdb-2024-06-22_1.csv')`