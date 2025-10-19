туториал
https://github.com/schibsted/jslt/blob/master/tutorial.md#jslt-tutorial
описание функций
[jslt/functions.md at master · schibsted/jslt · GitHub](https://github.com/schibsted/jslt/blob/master/functions.md)
онлайн-тестирование JSLT
[JSLT demo playground](https://www.garshol.priv.no/jslt-demo)

Пример использования:
на входе 
```json
[{"att1":"00-00000861","att2":"Хаски"},{"att1":"02-00019582","att2":"Хаски"}]
``` 
jslt который позволяет это сделать 
```json
[ for (.) { "data": {for (.) replace(.key, "att", "") : .value} } ]
```
на выходе 
```json
[{"data":{"1":"00-00000861","2":"Хаски"}},{"data":{"1":"02-00019582","2":"Хаски"}}] 
```

Пример использования для преобразования string в json object при выгрузке данных из GP/Postgresql
```json
[  
  for (.)  {    "data": from-json(.data)  }]
```

{"foo" : {"bar" : [1,2,3,4,5]}}