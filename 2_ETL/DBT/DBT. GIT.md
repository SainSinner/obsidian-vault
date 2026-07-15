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
### Переключиться на другую ветку несмотря на изменения в текущей
git checkout -f origin/feature/HRANALYTICS-781_t
### Удалить ветку из локального репозитория
git branch -D feature/HRANALYTICS-764_p
### Убрать из отслеживания битые файлы KHD 2.0
git update-index --assume-unchanged sql/gen/raw/ddl/table/archive/arch_lnd_0898_000.arch_budgetitems_extdimensionkinds.sql 

**или таким образом все из определенной папки**

git ls-files sql/gen/raw/ddl | xargs git update-index --assume-unchanged

### Вернуть в отслеживаемые битые файлы KHD 2.0

git ls-files sql/gen/raw/ddl | xargs git update-index --no-assume-unchanged

