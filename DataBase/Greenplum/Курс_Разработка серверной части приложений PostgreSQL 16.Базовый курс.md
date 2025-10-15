[Разработка серверной части приложений PostgreSQL 16.Базовый курс](https://postgrespro.ru/education/courses/DEV1)
[Системный каталог хранит метаинформацию об объектах кластера](https://postgrespro.ru/docs/postgresql/16/catalogs)

###### Часто используемые команды

Часто используемые команды  
Зайти под пользователем postgres  
sudo -u postgres psql

Присоединение к базе данных  
\c arch_wal_overview

Увидеть конфигурацию базы данных  
\dconfig work_mem

Выйти из Базы данных  
\q

Список баз данных можно получить в psql такой командой  
\l

вывода списка схем в psql  
\dn+

вывода списка схем со служебными в psql  
\dnS+

Список таблиц в схеме (в качестве примера схема public)  
\dt public.*

Перемещение таблицы между схемами в каталоге  
ALTER TABLE t SET SCHEMA special;

Частые команды кластера  
Cтатус кластера  
sudo pg_ctlcluster 16 main status

посмотреть, какие запросы выполняет команда:  
\set ECHO_HIDDEN on

Посмотреть на табличные пространства:  
SELECT spcname FROM pg_tablespace;

###### Консоль курса
Установка PostgreSQL заново  
sudo apt update  
sudo apt install postgresql

Сделать запуск postgresql при открытии WSL  
echo "sudo pg_ctlcluster 16 main start" >> ~/.bashrc

Cтатус кластера  
sudo pg_ctlcluster 16 main status

Зайти под пользователем postgres  
sudo -u postgres psql

Создать базу данных user (нужно чтобы название базы данных сразу совпадало с именем юзера в ubuntu, можно будет подключаться к ней сразу по команде psql)  
sudo -u postgres createdb user

Создать юзера  
CREATE USER "user" WITH PASSWORD 'user';

Дать права суперпользователя и проверить  
ALTER ROLE "user" WITH SUPERUSER;  
\du user

Создание директории для истории psql для  
sudo mkdir -p /var/lib/postgresql  
sudo chown -R postgres:postgres /var/lib/postgresql  
sudo systemctl restart postgresql

Создание директории для истории psql для пользователя user  
sudo mkdir -p /home/user/.postgresql  
sudo chown -R user:user /home/user/.postgresql  
sudo -u user nano /home/user/.psqlrc  
\set HISTFILE ~/.postgresql/.psql_history

Увидеть конфигурацию  
\dconfig work_mem

Справку по psql можно получить не только в документации, но и прямо в системе.  
psql --help  
man psql

Расширенный формат. Расширенный формат удобен, когда нужно вывести много столбцов для одной или нескольких записей. Для этого вместо точки с запятой указываем в конце команды \gx:

Переменные psql.Пример использования  
\set TEST Hi!  
\echo :TEST

Значение переменной можно сбросить:  
\unset TEST  
\echo :TEST

Переменные можно использовать, например, для хранения текста часто используемых запросов. Вот запрос на получение списка пяти самых больших по размеру таблиц:  
\set top5 'SELECT tablename, pg_total_relation_size(schemaname||''.''||tablename) AS bytes FROM pg_tables ORDER BY bytes DESC LIMIT 5;'  
top5

Открывая транзакцию можно создавать точку сохранения  
BEGIN;  
SAVEPOINT sp; -- точка сохранения  
-- далее что-то делаем  
-- Обратите внимание: свои собственные изменения транзакция видит, даже если они не зафиксированы.  
-- Теперь откатим все до точки сохранения.  
-- Откат к точке сохранения не подразумевает передачу управления (то есть не работает как GOTO); отменяются только те изменения состояния БД, которые были выполнены от момента установки точки до текущего момента.  
ROLLBACK TO sp;  
-- Сейчас изменения отменены, но транзакция продолжается:  
-- для завершения транзакции  
COMMIT;

Пример использования PREPARE. Здесь $1 означает параметр который мы вводим при вызове q(integer).  
PREPARE q(integer) AS  
SELECT * FROM t WHERE id = $1;

Например, если мы укажем q(2) нам вернется результат запроса ниже.  
SELECT * FROM t WHERE id = 2;

Удалить оператор созданный PREPARE  
DEALLOCATE prepared_statement_name;

Все подготовленные операторы текущего сеанса можно увидеть в представлении:  
SELECT * FROM pg_prepared_statements \gx

Курсор (портал)  
--открываем курсор  
BEGIN;  
DECLARE c CURSOR FOR  
SELECT * FROM t ORDER BY id;  
-- делаем выборку курсором  
FETCH c;  
-- размер выборки можно увеличить, например  
FETCH 2 c;  
-- закрыть курсор  
CLOSE c;  
-- Однако курсоры автоматически закрываются по завершению транзакции, так что можно не закрывать их явно. (Исключение составляют курсоры, открытые с указанием WITH HOLD.)  
-- закрываем транзакцию  
COMMIT;

Присоединение к базе данных  
\c arch_wal_overview

Размер буферного кеша показывает параметр shared_buffers  
SHOW shared_buffers;

Просмотр архива журнала транзакций (WAL)  
sudo pg_ctlcluster 16 main restart  
psql arch_wal_overview

Дополнительная информация по запросу  
EXPLAIN (analyze, buffers, costs off, timing off) SELECT * FROM t;

Поисковой путь по умолчанию  
SHOW search_path;

Установим путь поиска для текущего сеанса (это означает, что сначала будем пытаться найти указанную таблицу в схеме public, а потом в схеме special  
SET search_path = public, special;

!Остановился на "Функции" [https://edu.postgrespro.ru/16/dev1-16/dev1_08_sql_func.html](https://edu.postgrespro.ru/16/dev1-16/dev1_08_sql_func.html)