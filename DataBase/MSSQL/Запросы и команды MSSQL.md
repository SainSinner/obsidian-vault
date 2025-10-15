[Функции, используемых в базах данных Microsoft SQL - SQL Server | Microsoft Learn](https://learn.microsoft.com/ru-ru/sql/t-sql/functions/functions?view=sql-server-ver16)

#### STRING_AGG (Transact-SQL)
`STRING_AGG` — это агрегатная функция, которая принимает все выражения из строк и сцепляет их в одну строку. Значения выражений неявно преобразуются в строковые типы и затем сцепляются. Неявное преобразование в строки выполняется по существующим правилам преобразования типов данных. Дополнительные сведения о преобразовании типов данных см. в статье [Функции CAST и CONVERT (Transact-SQL)](https://learn.microsoft.com/ru-ru/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver16).

Если входное выражение имеет тип `VARCHAR`, разделитель не может иметь тип `NVARCHAR`.

Значения NULL пропускаются, и соответствующий разделитель не добавляется. Чтобы вернуть заполнитель для значений NULL, используйте функцию `ISNULL`, как показано в примере Б.

Функция `STRING_AGG` доступна на любом уровне совместимости.
https://learn.microsoft.com/ru-ru/sql/t-sql/functions/string-agg-transact-sql?view=sql-server-ver16

###### Пример А. Формирование списка имен, разделенного по строкам

В приведенном ниже примере формируется список имен в одной результирующей ячейке, разделенный символами возврата каретки.

SQLКопировать

```
USE AdventureWorks2022;
GO
SELECT STRING_AGG (CONVERT(NVARCHAR(max),FirstName), CHAR(13)) AS csv 
FROM Person.Person;
GO
```

Вот результирующий набор.

Развернуть таблицу

|csv|
|---|
|Саид  <br>Екатерининский  <br>Ким  <br>Ким  <br>Ким  <br>Хем  <br>...|

Значения `NULL`, найденные в ячейках `name`, не возвращаются в результатах.
#### Агрегатная функции `bool_or` и `bool_and`
https://learn.microsoft.com/ru-ru/azure/databricks/sql/language-manual/functions/bool_or
Возвращает `true` значение, если хотя бы одно значение `expr` имеет значение true в группе.

Агрегатная `bool_or` функция является синонимом [любой агрегатной функции](https://learn.microsoft.com/ru-ru/azure/databricks/sql/language-manual/functions/any).
###### Примеры

```SQL
> SELECT bool_or(col) FROM VALUES (true), (false), (false) AS tab(col);
 true

> SELECT bool_or(col) FROM VALUES (NULL), (true), (false) AS tab(col);
 true

> SELECT bool_or(col) FROM VALUES (false), (false), (NULL) AS tab(col);
 false
```
есть так же `bool_and`
https://learn.microsoft.com/ru-ru/azure/databricks/sql/language-manual/functions/bool_and
####  Функция`concat_ws`
https://learn.microsoft.com/ru-ru/azure/databricks/sql/language-manual/functions/concat_ws
Возвращает строки объединения, разделенные `sep`.

```SQL
> SELECT concat_ws(' ', 'Spark', 'SQL');
  Spark SQL
> SELECT concat_ws('s');
  ''
> SELECT concat_ws(',', 'Spark', array('S', 'Q', NULL, 'L'), NULL);
  Spark,S,Q,L
```
#### FORMAT (Transact-SQL)
https://learn.microsoft.com/ru-ru/sql/t-sql/functions/format-transact-sql?view=sql-server-ver16
Возвращает значение в указанных формате и культуре (не обязательно). Используйте функцию `FORMAT` для форматирования значений даты и времени и чисел в качестве строк. Для общих преобразований типов данных используйте `CAST` или `CONVERT`.

###### А. Простой пример функции FORMAT

В следующем примере возвращается простой набор данных, отформатированный для различных языков и региональных параметров.

```SQL
DECLARE @d AS DATE = '11/22/2020';

SELECT FORMAT(@d, 'd', 'en-US') AS 'US English',
       FORMAT(@d, 'd', 'en-gb') AS 'British English',
       FORMAT(@d, 'd', 'de-de') AS 'German',
       FORMAT(@d, 'd', 'zh-cn') AS 'Chinese Simplified (PRC)';

SELECT FORMAT(@d, 'D', 'en-US') AS 'US English',
       FORMAT(@d, 'D', 'en-gb') AS 'British English',
       FORMAT(@d, 'D', 'de-de') AS 'German',
       FORMAT(@d, 'D', 'zh-cn') AS 'Chinese Simplified (PRC)';
```

Вот результирующий набор.

Выходные данные

```SQL
US English   British English  German      Simplified Chinese (PRC)
-----------  ---------------- ----------- -------------------------
8/9/2024     09/08/2024       09.08.2024  2024/8/9

US English              British English  German                    Chinese (Simplified PRC)
----------------------- ---------------- ------------------------  -------------------------
Friday, August 9, 2024  09 August 2024   Freitag, 9. August 2024   2024年8月9日
```