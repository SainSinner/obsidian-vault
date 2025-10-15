Если указать следующим образом  

```sql
ROUND(avg(tp.total_material_costs), 2)     AS total_material_costs
```

  
результат будет следующим  

avro:
```json
{"name":"total_material_costs","type":["null",{"type":"bytes","logicalType":"decimal","precision":10,"scale":0}]}
```
пример значения:
"total_material_costs" : 334577,

  
Если же указать следующим образом  

```sql
ROUND(avg(tp.total_material_costs), 2)::numeric(30,2)      AS total_material_costs
```

  
результат будет следующим  

avro:
```json
{"name":"total_material_costs","type":["null",{"type":"bytes","logicalType":"decimal","precision":30,"scale":2}]}
```
само значение:
"total_material_costs" : 334576.97