задаю атрибут 
`replacementValue`
со значением
```groovy
$${'$1':replace("﻿",""):replace("ТабНомер","employee_num;"):replace("Сотрудник","employee;"):replace("Должность","job_title;"):replace("подразделение","position_parent;"):replace("Локация","location;"):replace("Территория","territory;"):replace("Руководитель (функц.)\tЗамещающий (комментарий)","chief_substitute_employee;"):replace("email","email;"):replace("Дата увольнения","dismissal_date"):replaceAll(';\t', ';')}
```
Затем в ReplaceText 1.20.0
в Replacement Value следующее выражение прописываю
```
${replacementValue:evaluateELString()}
```