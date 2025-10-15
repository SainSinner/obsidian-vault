```sql
-- region просмотр изменения WindowsLogin в refPhysicalPersons  
select top 1000 *  
from  
    dbo.v_LogDataChange as ldc  
where  
      ldc.TableName = 'refPhysicalPersons'  
  and ldc.ChangeDate > getdate() - 1  
  and ldc.UserName = 'ovp\esbservice'  
-- and ldc.FieldName = 'WindowsLogin'  
;  
-- endregion
```