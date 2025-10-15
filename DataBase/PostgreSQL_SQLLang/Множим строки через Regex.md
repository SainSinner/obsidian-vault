```sql
-- region Пример размножения строк регулярным выражением  
DROP TABLE IF EXISTS temp_names;  
CREATE TEMPORARY TABLE temp_names (  
    id SERIAL PRIMARY KEY,  
    name VARCHAR(50) NOT NULL  
);  
  
INSERT INTO temp_names (name)  
VALUES  
    ('apple banana'),  
    ('cat dog mouse');  
  
SELECT * FROM temp_names;  
  
SELECT  
    id,  
    unnest(regexp_matches(name, '\w+', 'g')) AS word  
FROM  
    temp_names;  
-- endregion
```