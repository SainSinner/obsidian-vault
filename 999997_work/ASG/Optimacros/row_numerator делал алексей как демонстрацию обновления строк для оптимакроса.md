![[row_numerator.sql]]

```sql
-- Предположим, это промежуточная таблица для выгрузки данных в Оптимакрос (Sandbox)
DROP TABLE IF EXISTS ader.opt_test_data;
CREATE TABLE ader.opt_test_data (
	num integer, -- Номер строки для Optimacros
	row_to_send_num integer, -- Индекс обновленной строки, которая будет отправляться в Optimacros
	is_empty bool, -- Отметка для пустых строк таблицы
	month_code integer,
	smth text
) DISTRIBUTED BY (num);

-- Заполним ее данными
WITH m AS (
			  SELECT ind
			  FROM GENERATE_SERIES(1, 12) AS ind
		  )
INSERT
INTO ader.opt_test_data(num, row_to_send_num, month_code, smth)
SELECT (m.ind - 1) * 100000 + s
	 , s
	 , 202400 + m.ind
	 , 'test_' || m.ind || '_' || s
FROM GENERATE_SERIES(1, 100000) AS s
CROSS JOIN m;

-- Предположим, это функция ежедневной выборки данных
-- С каждым ее запуском часть строк должна удаляться, а часть - добавляться
DO LANGUAGE plpgsql
$$
	DECLARE var_rowcount integer;
			var_rowcount_new integer;
			var_rows_to_insert integer = 75000;

			var_min_month_code integer;
			var_max_month_code integer;
			var_next_month_code integer;
	BEGIN

		-- Для примера, предположим, что функция должна удалить данные за самый "старый" месяц
		-- и добавить данные за новый месяц
		SELECT MIN(month_code)
		INTO var_min_month_code
		FROM ader.opt_test_data;

		SELECT MAX(month_code)
		INTO var_max_month_code
		FROM ader.opt_test_data;

		IF var_max_month_code % 100 = 12
		THEN
			var_next_month_code = (var_max_month_code / 100 + 1) * 100 + 1;
		ELSE
			var_next_month_code = var_max_month_code + 1;
		END IF;
		--

		SELECT COUNT(*)
		INTO var_rowcount
		FROM ader.opt_test_data;

		-- Удаляем устаревшие данные
		DELETE
		FROM ader.opt_test_data
		WHERE month_code = var_min_month_code
		   OR is_empty;

		-- Сбрасываем номера новых строк
		UPDATE ader.opt_test_data
		SET row_to_send_num = NULL;

		-- Добавляем новые строки. row_to_send_num должен содержать последовательные номера новых строк
		INSERT INTO ader.opt_test_data(num, row_to_send_num, month_code, smth)
		SELECT NULL
			 , s
			 , var_next_month_code
			 , 'test_' || var_next_month_code || '_' || s
		FROM GENERATE_SERIES(1, var_rows_to_insert) AS s;

		SELECT COUNT(*)
		INTO var_rowcount_new
		FROM ader.opt_test_data;

		-- Вставляем пустые строки в таблицу, чтобы общее количество строк не уменьшилось
		-- Эти строки тоже должны быть отправлены в Optimacros, чтобы стереть удаленные данные
		IF var_rowcount_new < var_rowcount
		THEN
			INSERT INTO ader.opt_test_data(num, row_to_send_num, is_empty, month_code, smth)
			SELECT NULL
				 , s
				 , TRUE
				 , NULL
				 , NULL
			FROM GENERATE_SERIES(var_rows_to_insert + 1, var_rows_to_insert + (var_rowcount - var_rowcount_new)) AS s;
		END IF;

		-- Проставляем num у новых строк
		WITH new_nums AS (
							 SELECT ROW_NUMBER() OVER (ORDER BY s) AS ind
								  , s AS new_num
							 FROM GENERATE_SERIES(1, var_rowcount) AS s
							 WHERE NOT EXISTS (
												  SELECT 1
												  FROM ader.opt_test_data AS d
												  WHERE d.num = s
											  )
						 )
		UPDATE ader.opt_test_data AS upd_ts
		SET num = nn.new_num
		FROM ader.opt_test_data AS ts
		JOIN new_nums AS nn
			ON ts.row_to_send_num = nn.ind
		WHERE upd_ts.row_to_send_num = ts.row_to_send_num
		  AND upd_ts.num IS NULL;
	END
	$$;

-- Итого:
SELECT month_code
	 , COUNT(*) AS cnt
	 , MIN(num) AS min_num
	 , MAX(num) AS max_num
	 , MIN(smth) AS min_smth
	 , MAX(smth) AS max_smth
FROM ader.opt_test_data
GROUP BY month_code
ORDER BY month_code;
```