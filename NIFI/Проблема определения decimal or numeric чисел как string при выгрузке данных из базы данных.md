Нужно поставить параметр "Use Avro Logical Types = True" (есть в процессорах ExecuteSQL, QueryDatabaseTable): "If disabled, written as string. If enabled, Logical types are used and written as its underlying type, specifically, DECIMAL/NUMBER as logical 'decimal': written as bytes with additional precision and scale meta data..."

numeric столбец выглядит так с включенным параметром: {"name":"price","type":["null",{"type":"bytes","logicalType":"decimal","precision":18,"scale":5}]}  
и так - с выключенным: {"name":"price","type":["null","string"]}