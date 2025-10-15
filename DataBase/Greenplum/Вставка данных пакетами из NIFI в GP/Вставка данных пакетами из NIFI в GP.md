прописать в url для обращения к базе данных jdbc:postgresql://nifidb1t-dtln.ovp.ru:5432/sandbox?reWriteBatchedInserts=true

jdbc:postgresql://green0t-dtln.ovp.ru:5432/main?reWriteBatchedInserts=true

![[Pasted image 20240828202219.png]]


|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
      
|№ попытки теста|длительность вставки из NIFI  с "?reWriteBatchedInserts=true"|длительность вставки из NIFI без "?reWriteBatchedInserts=true"|объем файла|№ файла|количество строк в файле|Таблица в которую вставляли данные|
|1|00:00:01.397|00:00:09.455|448.08 KB|1|1024|main.erp.transfer_report_customer_debt_maturity|
|1|00:00:00.758|00:00:09.210|459.56 KB|2|1024|main.erp.transfer_report_customer_debt_maturity|
|1|00:00:01.437|00:00:08.110|373.93 KB|3|839|main.erp.transfer_report_customer_debt_maturity|
|2|00:00:01.411|00:00:09.844|448.08 KB|1|1024|main.erp.transfer_report_customer_debt_maturity|
|2|00:00:00.869|00:00:09.382|459.56 KB|2|1024|main.erp.transfer_report_customer_debt_maturity|
|2|00:00:01.399|00:00:07.931|373.93 KB|3|839|main.erp.transfer_report_customer_debt_maturity|