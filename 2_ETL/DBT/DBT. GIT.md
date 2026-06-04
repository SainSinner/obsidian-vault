### Версия коллег из GBC
1. Создаем ветку от **master**
2. Прогоняем dbt compile и dbt run
3. merge ветки в test
4. тестируем в тесте
5. потом пулл реквест ветки в master создаем
### Моя версия
1. Создаем ветку от origin/test и называем ее origin/feature/HRANALYTICS-670_t
2. git checkout origin/feature/HRANALYTICS-670_t
3. git add .
4. git commit -m "some message"
5. git pull
6. делаем MR origin/feature/HRANALYTICS-670_t в origin/test
7. Создаем ветку от origin/master и называем ее origin/feature/HRANALYTICS-670_p
8. git checkout origin/feature/HRANALYTICS-670_p
9. git cherry-pick 22d77d1de1245b483e2457ca4bfaef0a46be7ef1 22d77d1de1245b483e2457ca4bfaef0a46be7ef2 **(здесь вводим guid коммитов которые хотим вставить в ветку через пробел)**
10. git pull
11. делаем MR origin/feature/HRANALYTICS-670_p в origin/master