```sql
SELECT  
    STRING_AGG('os.' + COLUMN_NAME + ' as ' + COLUMN_NAME, ',') as answer  
FROM  
    INFORMATION_SCHEMA.COLUMNS  
WHERE  
    TABLE_SCHEMA = 'balance'  
    AND TABLE_NAME = 'ObligationsResultsLogHistory';
```