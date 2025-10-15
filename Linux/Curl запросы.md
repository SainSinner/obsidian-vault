###### Без контента
```
curl -u 'TechReg:Reg_ASG_djlrf!@01' -X GET http://10.115.21.130/erp_it_dev15/hs/UniversalImport/ImportData
```
###### С ссылкой на контент в файле
```
curl -X PUT -u 'TechReg:Reg_ASG_djlrf!@01' -H "Content-Type: application/json" -d @test4x.json  http://10.115.21.130/erp_it_dev15/hs/UniversalImport/ImportData
```
###### С контентом в запросе
```
curl -X PUT -u 'TechReg:Reg_ASG_djlrf!@01' -H "Content-Type: application/json" -d '{"FileName":"05296852-fb74-4c95-a15e-782e79e24b9f","InterfaceName":"HierarchyNetworks","InterfaceVersion":1,"MessageGuid":"c36cf58c-1c93-4331-a59c-813a87fedcc2","Иерархия":[{"branch_network_id":"12345678910","branch_network_name":"Прочие","branch_network_type":"Не определено","partner_code":"00003300008","partner_name":"Не определено","partner_network_id":"0","partner_type":"Сети"},{"branch_network_id":"281475157142889","branch_network_name":"Хорека/Сибирская Корона/Омск","branch_network_type":"On-Trade (сети)","partner_code":"00003053582","partner_name":"Прочие","partner_network_id":"281475598150228","partner_type":"Сети"},{"branch_network_id":"12345678910","branch_network_name":"Прочие","branch_network_type":"Не определено","partner_code":"00003301607","partner_name":"Не определено","partner_network_id":"0","partner_type":"Сети"},{"branch_network_id":"12345678910","branch_network_name":"Прочие","branch_network_type":"Не определено","partner_code":"00007301483","partner_name":"Не определено","partner_network_id":"0","partner_type":"Сети"}],"Сети1С":[{"client_type":null,"code":null,"partner_name":"Европа","partner_network_id":"281475234159708","partner_type":"Сети"},{"client_type":null,"code":null,"partner_name":"Калейдоскоп","partner_network_id":"281475234163907","partner_type":"Сети"},{"client_type":null,"code":null,"partner_name":"Чарка","partner_network_id":"281475234161260","partner_type":"Сети"},{"client_type":null,"code":null,"partner_name":"Вулкан","partner_network_id":"281475234162074","partner_type":"Сети"}]}' http://10.115.21.130/erp_it_dev15/hs/UniversalImport/ImportData
```
