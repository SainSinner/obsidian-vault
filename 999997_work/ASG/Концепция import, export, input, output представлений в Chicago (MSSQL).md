###### Чтение
Если мы читаем какую-то таблицу находясь в MasterData из Chicago_ASG_new, то мы создаем 2 представления:
1. Chicago_ASG_new.export.ТаблицаВЧикаго
2. MasterData.import.ТаблицаВЧикаго
Если мы читаем какую-то таблицу находясь в Chicago_ASG_new из MasterData, то мы создаем 2 представления:
1. MasterData.export.ТаблицаВМастерДата
2. Chicago_ASG_new.import.ТаблицаВМастерДата
###### Обновление данных
Если мы хотим преобразовать какую-то таблицу из Chicago_ASG_new изменив ее в MasterData, то мы создаем 2 представления:
1. MasterData.input.ТаблицаВМастерДата
2. Chicago_ASG_new.output.ТаблицаВМастерДата
Если мы хотим преобразовать какую-то таблицу из MasterData изменив ее в Chicago_ASG_new, то мы создаем 2 представления:
1. MasterData.output.ТаблицаВЧикаго
2. Chicago_ASG_new.input.ТаблицаВЧикаго
