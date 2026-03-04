# 1
```sql
select
count(*)
from
SQL_TEST.T_SQLT_ART
where 1=1
AND LOWER(NAME) LIKE 'чай%'
AND LOWER(NAME) NOT LIKE 'чайник%'
AND VOL_TRANSP = 1
```
# 2
```sql
select
-- *
count(*)
from
SQL_TEST.T_SQLT_ART
where 1=1
AND ART_GRP_LVL_1_NAME = 'Яйцо'
AND (VOL_TRANSP * 10) >= 10 
```
# 3
```sql
select
count(*)
from
SQL_TEST.T_SQLT_ART
where 1=1
AND ((WEIGHT * 2) >= 10 OR (VOL_TRANSP * 10 ) <= 2)
= 2)
```
# 4
```sql
SELECT
-- TOP 5
sum(VOL_TRANSP)
FROM SQL_TEST.T_SQLT_ART AS TSA
WHERE
(MOD(WEIGHT,1)=0 AND WEIGHT BETWEEN 1 AND 3) OR (VOL_TRANSP BETWEEN 3 AND 5)
-- (MOD(TSA.WEIGHT, 1) = 0 AND TSA.WEIGHT >= 1 AND TSA.WEIGHT < 3) OR (TSA.VOL_TRANSP >= 3 AND TSA.VOL_TRANSP < 5)
--AND MOD(TSA.WEIGHT, 1) = 0
--AND ((TSA.WEIGHT >= 1 AND TSA.WEIGHT < 3) OR (TSA.VOL_TRANSP >= 3 AND TSA.VOL_TRANSP < 5))
;
```

# 5
```sql
select
--top 5
ART_GRP_LVL_0_NAME, ART_GRP_LVL_1_NAME,
ROUND(avg(VOL_TRANSP), 3)
from
SQL_TEST.T_SQLT_ART
where 1=1 
group by 
ART_GRP_LVL_0_NAME, ART_GRP_LVL_1_NAME
Having
min(VOL_TRANSP) - MAX(VOL_TRANSP) = 0
order by
ART_GRP_LVL_0_NAME, ART_GRP_LVL_1_NAME
```
# 6
```sql
select
NAME as "Название товара",
FLOOR(10 / VOL_TRANSP) as "Сколько целых товаров поместится в этот пакет"
from
SQL_TEST.T_SQLT_ART
where 1=1
AND ART_GRP_LVL_2_NAME = 'Грибы'
AND VOL_TRANSP >= 2
AND VOL_TRANSP <= 10
OrDER BY
NAME
```
# 7
```sql
select
(min(WEIGHT/VOL_TRANSP) + MAX(WEIGHT/VOL_TRANSP)) / 2 as "Средняя плотность"
from
SQL_TEST.T_SQLT_ART
where
(WEIGHT/VOL_TRANSP) > 0
```
# 8
```sql
select
WEIGHT as "Вес",
VOL_TRANSP AS "Объем"
from SQL_TEST.T_SQLT_ART as a 
WHERE 1=1
AND (VOL_TRANSP = (SELECT max(VOL_TRANSP) FROM SQL_TEST.T_SQLT_ART) or VOL_TRANSP = (SELECT min(VOL_TRANSP) FROM SQL_TEST.T_SQLT_ART))
```
# 9
```sql
WITH main_query as (
select top 10
a.NAME as "Название товара",
a.ART_GRP_LVL_0_NAME as "Наименование ГР20",
SUM(s.SALE) AS "Суммарная выручка, руб",
Sum(s.SALE_QNTY) AS "Суммарные продажи, шт"
from
SQL_TEST.T_SQLT_SALES as s
LEFT JOIN SQL_TEST.T_SQLT_ART as a on s.ART_ID = a.ART_ID
where YEAR(s.DAY_ID) = 2019
GROUP BY
a.NAME,
a.ART_GRP_LVL_0_NAME
ORDER BY
SUM(s.SALE) desc
)
select
top 5
"Название товара",
"Наименование ГР20",
"Суммарная выручка, руб",
"Суммарные продажи, шт"
from
main_query
order by
"Суммарные продажи, шт" desc
```
# 10
```sql
```