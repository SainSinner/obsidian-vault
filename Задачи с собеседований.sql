-- region Задача: Баланса счета во все моменты времени. Нарастающий остаток. Оконная функция для проставления

-- OperationID - numeric(15,0) - Уникальный идентификатор операции
-- CharType - int - Тип операции
-- OperDate - datetime -  Дата операции
-- Qty - numeric(28,10) -  Сумма операции
-- Indatetime - datetime - Фактическая дата совершения операции
-- Rest - numeric(28,10) -  Остаток

CREATE temp TABLE OperPart_test
(
    OperationID numeric(15, 0),
    CharType    int,
    OperDate    timestamp,
    Qty         numeric(28, 10),
    Indatetime  timestamp,
    Rest        numeric(28, 10)
);

-- Наполнение данными
INSERT INTO OperPart_test
VALUES (33581974000, 1, '20210820 0:00:00.000', 1000011.0000000000, '20210820 13:10:25.700', 0);
INSERT INTO OperPart_test
VALUES (33582024800, -1, '20210820 0:00:00.000', 1000011.1100000000, '20210820 13:51:08.903', 0);
INSERT INTO OperPart_test
VALUES (33582208700, 1, '20210820 0:00:00.000', 825000.1500000000, '20210820 15:33:38.776', 0);
INSERT INTO OperPart_test
VALUES (33582407110, -1, '20210820 0:00:00.000', 825000.0000000000, '20210820 16:29:39.980', 0);
INSERT INTO OperPart_test
VALUES (33582408610, 1, '20210820 0:00:00.000', 1000011.0000000000, '20210820 16:34:53.183', 0);
INSERT INTO OperPart_test
VALUES (33582419620, -1, '20210820 0:00:00.000', 1000011.0000000000, '20210820 17:09:24.250', 0);
INSERT INTO OperPart_test
VALUES (33582519290, 1, '20210820 0:00:00.000', 15000.0000000000, '20210820 19:57:20.546', 0);

SELECT 1000868.31 + SUM(CASE WHEN CharType = 1 then -Qty else Qty end) over (order by Indatetime) as rest
FROM OperPart_test;

drop table if exists OperPart_test;
-- endregion

-- region Задача: Дана таблица T(value), выведите все повторяющиеся записи
CREATE temporary TABLE T1_test
(
    col1 Int
);

INSERT INTO T1_test
VALUES (1),
       (1),
       (1),
       (3),
       (4),
       (5),
       (1),
       (3);

select count(col1), col1
from T1_test
group by col1
having count(col1) > 1;

drop table if exists T1_test;
-- endregion

-- region Задача: Вывести сотрудника и департамент, со второй максимальной зарплатой в каждом департаменте за апрель 2023
create temp table Salary_test
(
    VALUE_DAY date,
    EMPL_FIO  text,
    EMPL_DEP  text,
    AMOUNT    float
);

insert into Salary_test (VALUE_DAY, EMPL_FIO, EMPL_DEP, AMOUNT)
VALUES ('2023.04.30', 'Иванов Иван Иванович      ', 'Департамент 1', 50000),
       ('2023.04.30', 'Сидоров Валерий Валериевич', 'Департамент 1', 75000),
       ('2023.05.31', 'Иванов Иван Иванович      ', 'Департамент 2', 84000),
       ('2023.04.30', 'Сидоров Иван Иванович     ', 'Департамент 2', 75000),
       ('2023.04.30', 'Иванов Петр Петрович      ', 'Департамент 2', 80000),
       ('2023.05.31', 'Сидоров Валерий Валериевич', 'Департамент 1', 88000),
       ('2023.04.30', 'Петров Валерий Валериевич ', 'Департамент 2', 89000),
       ('2023.05.31', 'Петров Петр Петрович      ', 'Департамент 1', 89000),
       ('2023.05.31', 'Сидоров Иван Иванович     ', 'Департамент 2', 89000),
       ('2023.05.31', 'Иванов Петр Петрович      ', 'Департамент 2', 90000),
       ('2023.05.31', 'Петров Валерий Валериевич ', 'Департамент 1', 94000),
       ('2023.04.30', 'Петров Петр Петрович      ', 'Департамент 1', 100000);

with query_rank as (select *,
                           rank() over (partition by EMPL_DEP order by AMOUNT desc) as rank
                    from Salary_test
                    where VALUE_DAY between '2023-04-01' and '2023-04-30')
select *
from query_rank
where rank = 2;

drop table if exists Salary_test;
-- endregion

-- region Задача: Выведите поквартальную статистику продаж в разрезе регионов:
-- Данные в таблицу вносятся вручную, поэтому возможны дефекты написания регионов.
-- Учтите это при выполнении задачи - регионы нужно привести к единому виду.
-- Структура таблицы Sales (id, value_day, region, total_price)
--     id - номер чека
--     value_day - дата продажи
--     region - регион
--     total_price - сумма чека
-- Пример данных
-- (1, '01.01.2024', 'Москва', 100)
-- (2, '01.02.2024', 'г. Москва', 500)
-- (3, '01.04.2024', 'москва', 50)
-- (4, '07.05.2024', 'Московская обл', 67)
-- (5, '11.01.2024', 'Московская область', 20)
-- (6, '03.04.2023', 'Московская обл.', 30)
-- (7, '01.06.2022', 'Санкт Петербург', 11)
-- (8, '03.04.2024', 'Г. Санкт-Петербург', 10)
-- (9, '12.07.2023', 'Тулькая обл', 30)
-- (10, '01.08.2023', 'Тверская обл.', 50)
-- Выведите поквартальную статистику продаж в разрезе регионов:
-- Объем продаж (руб)
-- Кол-во продаж (шт)
-- Средний чек (руб)
-- Максимальный чек (руб)
-- Медианный чек (руб)
-- Среднее кол-во продаж в день (шт)
-- Максимальный дневной объем продаж (руб)

create temp table region_test
(
    id          int,
    value_day   date,
    region      text,
    total_price float
);

insert into region_test (id, value_day, region, total_price)
VALUES (1, '2024.01.01', 'Москва', 100),
       (2, '2024.02.01', 'г. Москва', 500),
       (3, '2024.04.01', 'москва', 50),
       (4, '2024.05.07', 'Московская обл', 67),
       (5, '2024.01.11', 'Московская область', 20),
       (6, '2023.04.03', 'Московская обл.', 30),
       (7, '2022.06.01', 'Санкт Петербург', 11),
       (8, '2024.04.03', 'Г. Санкт-Петербург', 10),
       (9, '2023.07.12', 'Тулькая обл', 30),
       (10, '2023.08.01', 'Тверская обл.', 50);

select *
from region_test;

with name_region as (select id,
                            value_day,
                            case
                                when lower(region) like '%москва%' then 'Москва'
                                when lower(region) like '%московская%' then 'Московская область'
                                when lower(region) like '%петербург%' then 'Санкт-Петербург'
                                when lower(region) like '%тулькая%' then 'Тулькая область'
                                when lower(region) like '%тверская%' then 'Тверская область'
                                end as region_name,
                            total_price
                     from region_test),
     name_region_per_day as (select count(id)        as "кол-во продаж в день (шт)",
                                    value_day,
                                    region_name,
                                    sum(total_price) as "дневной объем продаж (руб)"
                             from name_region
                             group by value_day, region_name)
select extract(QUARTER from t.value_day)                           as "Квартал",
       t.region_name                                               as "Регион",
       sum(t.total_price)                                          as "Объем продаж (руб)",
       count(t.id)                                                 as "Кол-во продаж (шт)",
       avg(t.total_price)                                          as "Средний чек (руб)",
       max(t.total_price)                                          as "Максимальный чек (руб)",
       percentile_cont(0.5) within group ( order by t.total_price) as "Медианный чек (руб)",
       avg(t_1."кол-во продаж в день (шт)")                        as "Среднее кол-во продаж в день (шт)",
       max(t_1."дневной объем продаж (руб)")                       as "Максимальный дневной объем продаж (руб)"
from name_region as t
         left join name_region_per_day as t_1 on t.region_name = t_1.region_name and t.value_day = t_1.value_day
group by extract(QUARTER from t.value_day), t.region_name
order by extract(QUARTER from t.value_day), t.region_name;

drop table if exists region_test;
-- endregion
-- endregion

-- region Задача Конкуренты

-- Есть таблица `competitors_prices` со следующими данными:
--
-- - sku_id_competitor — идентификатор SKU конкурента
-- - competitor_id — идентификатор конкурента
-- - promo_price_competitor — промо-цена конкурента
-- - regular_price_competitor — регулярная цена конкурента
-- - parsing_date — дата парсинга
--
-- Нужно получить витрину, где для каждой комбинации `(sku_id_competitor, competitor_id, parsing_date)` остаётся **только одно значение цены**:
-- - если есть `promo_price_competitor` → берём её,
-- - если промо отсутствует (`NULL`) → берём `regular_price_competitor`.

CREATE temp TABLE IF NOT EXISTS competitors_prices_test
(
    sku_id_competitor        INT,
    competitor_id            INT,
    promo_price_competitor   DECIMAL,
    regular_price_competitor DECIMAL,
    parsing_date             DATE
);

INSERT INTO competitors_prices_test
VALUES (15, 200, 147.0, 174.0, DATE '2025-08-30'),
       (16, 200, NULL, 222.0, DATE '2025-08-27'),
       (15, 200, NULL, 174.0, DATE '2025-08-30');

select distinct on (sku_id_competitor, competitor_id, parsing_date) sku_id_competitor,
                                                                    competitor_id,
                                                                    parsing_date,
                                                                    coalesce(promo_price_competitor, regular_price_competitor)
from competitors_prices_test
order by parsing_date desc;

drop table if exists competitors_prices_test;
-- endregion

-- region Задача: Запрос с использованием SELECT

-- Есть таблица `employees` с полями:
-- - id
-- - name
-- - salary
-- - department_id

select *
from employees as t
where t.salary > (select avg(t_1.salary) as mean_salary
                  from employees as t_1);
-- endregion

-- region Задача: Оконные функции и подзапросы

-- В таблице `employees` напишите запрос, который возвращает:
-- - имя сотрудника
-- - зарплату
-- - ранг по зарплате внутри своего `department_id` (нумерация по убыванию зарплаты).

select name,
       salary,
       department_id,
       rank() over (partition by department_id order by salary desc) as rnk
from employees;
-- endregion

-- region Задача Последняя загрузка по таблице за день

-- Есть таблица public.load_status со следующими данными:
-- 	•	dt — дата/время загрузки
-- 	•	table_name — имя таблицы/вьюхи
-- 	•	status — статус загрузки
--
-- Нужно построить выборку/витрину,
-- где для каждой таблицы в рамках каждого календарного дня
-- остаётся только одна строка — с максимальной dt
-- (если в день было несколько загрузок). Отфильтровать последние 14 дней.

CREATE temp TABLE load_status_test
(
    id         bigserial PRIMARY KEY,             -- уникальный ключ
    dt         timestamp with time zone NOT NULL, -- время загрузки
    table_name text                     NOT NULL, -- имя таблицы/вьюхи
    status     text                     NOT NULL  -- статус загрузки
);

INSERT INTO load_status_test (dt, table_name, status)
VALUES
-- Таблица alpha — два прогона в один день
('2025-09-15 09:15:00+03', 'alpha.orders_daily', 'OK'),
('2025-09-15 11:45:00+03', 'alpha.orders_daily', 'OK'),

-- Таблица beta — три прогона в один день
('2025-09-15 07:20:00+03', 'beta.customer_snapshot', 'OK'),
('2025-09-15 09:55:00+03', 'beta.customer_snapshot', 'OK'),
('2025-09-15 14:10:00+03', 'beta.customer_snapshot', 'OK'),

-- Таблица gamma — один прогон сегодня, два вчера
('2025-09-15 08:30:00+03', 'gamma.product_catalog', 'OK'),
('2025-09-14 10:05:00+03', 'gamma.product_catalog', 'OK'),
('2025-09-14 16:25:00+03', 'gamma.product_catalog', 'OK'),

-- Таблица delta — разные даты
('2025-09-13 06:40:00+03', 'delta.pricing_rules', 'OK'),
('2025-09-14 07:55:00+03', 'delta.pricing_rules', 'OK'),
('2025-09-15 12:20:00+03', 'delta.pricing_rules', 'OK'),

-- Таблица epsilon — только один прогон
('2025-09-15 10:10:00+03', 'epsilon.stock_levels', 'OK');

select table_name,
       date(dt) as date,
       max(dt)  as last_datetime
from load_status_test
-- where dt >= date_trunc('day', now() - '14 day'::interval)
group by table_name,
         date(dt);

drop table if exists load_status_test;
-- endregion

-- region Создание функции

-- Создайте функцию `get_department_salary_summary(dept_id INT)`, которая принимает ID отдела и возвращает таблицу с:
-- - общим количеством сотрудников
-- - средней зарплатой в этом отделе.

drop function get_department_salary_summary(INT);
create function get_department_salary_summary(dept_id INT)
    returns table
            (
                quantity_employees        int,
                avg_salary_per_department float
            )
    language plpgsql
as

$$
begin
    return query
        select count(name) as quantity_employees,
               avg(salary) as avg_salary_per_department
        from employees
        where department_id = dept_id;
end;
$$
-- endregion