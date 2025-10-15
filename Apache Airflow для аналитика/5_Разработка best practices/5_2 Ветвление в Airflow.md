предыдущая [[5_2 Sensors]]
следующая [[5_2 Задача на BranchOperator]]

При создании пайплайнов обработки данных возможны ситуации, когда нужно решить более сложные задачи, чем просто выполнение задачи A, затем B, а затем C. Например, возможна ситуация, когда нужно принять решение о том, выполнять ли несколько задач на основе результатов предыдущей задачи. 

Иными словами, как нам реализовать логику `if else` Оператором в Airflow? 

![](https://ucarecdn.com/70db1bfa-0843-485a-aebe-19fc695d9b0b/)

**BranchPythonOperator**

Простой способ добавить ветвление в Airflow - это использование `BranchPythonOperator` Данный декоратор принимает на вход функцию на Python, которая возвращает список допустимых идентификаторов задач (или иначе, имен задач внутри DAG). После выполнения функции DAG будет выполнять соответствующие задачи из этого списка

```python
# Функция для условия выбора нужного task_id
def branch_func(**kwargs):
    # Делаем запрос в Xcom, для исполнения условия
    xcom_value = int(kwargs['ti'].xcom_pull(task_ids='start_task'))
    if xcom_value >= 5:
        return 'continue_task' # Идентификатор задачи
    else:
        return 'stop_task' # Идентификатор задачи

# Стартовый оператор который пуляет в xcom 10
start_op = BashOperator(
    task_id='start_task',
    bash_command="echo 10",    
    dag=dag)

# Сам оператор условие
branch_op = BranchPythonOperator(
    task_id='branch_task',
    python_callable=branch_func,
    dag=dag)

# Операторы которые ничего не делают
continue_op = DummyOperator(task_id='continue_task', dag=dag)
stop_op = DummyOperator(task_id='stop_task', dag=dag)

start_op >> branch_op >> [continue_op, stop_op]
```

Python-функция ветвления должна вернуть хотя бы один идентификатор задачи для любой выбранной ветки (то есть она не может вернуть ничего). 

**Пример в облаке** 

Ссылка: `[http://158.160.116.58:8001/tree?dag_id=0_Examples_5.2.3.Branch_Operator](http://158.160.116.58:8001/tree?dag_id=0_Examples_5.2.3.Branch_Operator)`

**ShortCircuitOperator**

Ещё одним способом добавить условную логику в ваши группы задач в Airflow является использование оператора `ShortCircuitOperator` Он принимает функцию на Python, которая возвращает `Task` в зависимости от условия, **True** или **False**. Если функция возвращает **True**, выполнение DAG продолжается, а если **False**, то все последующие задачи игнорируются. Это полезно когда, например, ваша группа задач выполняется каждый день, но некоторые задачи должны выполняться только по воскресеньям. 

```python
​
from airflow import DAG
from airflow.models.baseoperator import chain
from airflow.operators.dummy import DummyOperator
from airflow.operators.python import ShortCircuitOperator
from airflow.utils import dates

args = {
    'owner': 'airflow',
}

with DAG(
    dag_id='dag',
    default_args=args,
    start_date=dates.days_ago(2),
    tags=['example'],
) as dag:

    cond_true = ShortCircuitOperator(
        task_id='condition_is_True',
        python_callable=lambda: True,
    )

    cond_false = ShortCircuitOperator(
        task_id='condition_is_False',
        python_callable=lambda: False,
    )

    # Сгенерируем много задач через цикл, чуть дальше мы изучим это подробнее
    ds_true = [DummyOperator(task_id='true_' + str(i)) for i in range(2)]
    ds_false = [DummyOperator(task_id='false_' + str(i)) for i in range(2)]

    # Создает цепочку из задач аналогично >> такой операции
    chain(cond_true, *ds_true)
    chain(cond_false, *ds_false)

​
```

Вывод задачи

![](https://ucarecdn.com/e245d673-c3b9-4183-8f2a-c0cb2fb50722/)

**Пример в облаке** 

Ссылка: `[http://158.160.116.58:8001/tree?dag_id=0_Examples_5.2.3.ShortCircuitOperator](http://158.160.116.58:8001/tree?dag_id=0_Examples_5.2.3.ShortCircuitOperator)`