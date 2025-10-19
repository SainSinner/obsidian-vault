предыдущая [[3_2 Перепишем скрипт использую Airflow]]
следующая [[3_2 Operator и Task]]

Теория описана здесь [[2_2 Directed Acyclic Graph (DAG)]]
Вспомним что такое DAG - ориентированный ациклический граф для которого характерны следующие свойства:

1. Наш граф однонаправленный то есть задачи исполняются шаг за шагом. Возможны параллельные задачи.
2. Ни одна задача не может создавать данные, которые в дальнейшем будут ссылаться сами на себя. В DAG нет циклов.
3. Все задачи имеют четкую структуру с дискретными процессами. Наш граф конечен.

![](https://ucarecdn.com/80dfe544-edaa-4a41-be91-8715ce8e1872/)

**Что такое `DAG` в Airflow**

Это конвейер (можно также рассматривать как контейнер для хранения задач) данных, представляющий собой набор инструкций, которые должны быть выполнены в определенном порядке. DAG в Airflow представляет собой класс `class` (тут подразумевается `python Class`) который устанавливает связи между задачами, создаваемыми при помощи `Operator` (также представляет из себя `python Class`)

Важно подчеркнуть, что задачи не могут существовать вне DAG-ов. DAG, можно сказать, выступает в роли организационного элемента, обеспечивая выполнение задач в определенной последовательности и учитывая все взаимосвязи между ними.

Пример DAG выше в интерфейсе Airflow:

![](https://ucarecdn.com/8a1712b3-7d41-4fae-b802-92d45d77b180/)

Код для создания данного DAG (разберем его в следующих шагах):

```python
from airflow import DAG
from datetime import timedelta
from airflow.utils.dates import days_ago
from airflow.operators.dummy_operator import DummyOperator
 
# Создадим объект класса DAG
dag =  DAG('dag', schedule_interval=timedelta(days=1), start_date=days_ago(1))

# Создадим несколько шагов, которые будут параллельно исполнять dummy(пустые)команды
t1 = DummyOperator(task_id='task_1', dag=dag)
t2 = DummyOperator(task_id='task_2', dag=dag)
t3 = DummyOperator(task_id='task_3', dag=dag)
t4 = DummyOperator(task_id='task_4', dag=dag)

# Настройка зависимостей
t1 >> [t2, t3] >> t4
```

#### **Практика:**

**Как создать DAG** 

Первым делом мы импортируем необходимый `class` 

```javascript
from airflow import DAG
```

После чего создаем объект `DAG` Какие аргументы принимает DAG мы разберем в следующем шаге.

```lisp
dag =  DAG('dag', schedule_interval=timedelta(days=1), start_date=days_ago(1))
```

Есть два основных способа создать DAG, первый "простой" второй с помощью контекстного менеджера, при помощи `with` 

**Простой способ**

```python
from airflow import DAG
from datetime import timedelta
from airflow.utils.dates import days_ago
 
# Создадим объект класса DAG
dag =  DAG('dag', schedule_interval=timedelta(days=1), start_date=days_ago(1))
```

Данный код создаст пустой DAG, который затем можно наполнить задачами:

#### ![](https://ucarecdn.com/0513a7fd-9b84-4ead-8ad3-9aa79bb2d626/)

#### С помощью контекстного менеджера

```python
from airflow import DAG
from datetime import timedelta
from airflow.utils.dates import days_ago
 
# Создадим объект класса DAG
with DAG('dag', schedule_interval=timedelta(days=1), start_date=days_ago(1)) as dag:
  pass
```

Данный код отработает аналогично вышестоящему, однако сам синтаксис немного отличается. Результат будет идентичен.

**Пример в облаке**

Ссылка на DAG: [http://158.160.116.58:8001/tree?dag_id=0_Examples_3.2.2](http://158.160.116.58:8001/tree?dag_id=0_Examples_3.2.2)