предыдущая [[5_2 Ветвление в Airflow]]
следующая [[5_3 Кастомный Operator и Hook]]

Вам дан код который возвращает в Xcom значение от 1 до 10. Ваша задача реализовать BranchOperator который в зависимости от этого значения вернет одну из задач, больше или меньше. Вам дан кусочек кода который необходимо доработать.

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
from airflow.operators.dummy import DummyOperator
from airflow.operators.python_operator import BranchPythonOperator
from random import randint

default_args = {
    'owner':'airflow',
    'start_date': datetime(2022, 2, 16)
}

dag = DAG('dag', schedule_interval='@daily', default_args=default_args)

def rand(**kwargs):
  kwargs['ti'].xcom_push(key='rand', value=randint(0, 10))


def branch(**kwargs):
# ВАШ КОД
# Если > 5 то вернуть higher
# иначе вернуть lower

lower = DummyOperator(
    task_id = 'lower',
    dag=dag
)

higher = DummyOperator(
    task_id = 'higher',
    dag=dag
)

branch_op = BranchPythonOperator(
    task_id = 'branch_task',
    provide_context = True,
    python_callable=branch,
    dag=dag
)

random_number = PythonOperator(
    task_id = 'random_number',
    python_callable=rand,
    dag=dag
)

random_number >> branch_op >> [lower, higher]
```

#### Ответ
```python
from airflow import DAG  
from airflow.operators.python import PythonOperator  
from datetime import datetime  
from airflow.operators.dummy import DummyOperator  
from airflow.operators.python_operator import BranchPythonOperator  
from random import randint

default_args = {  
    'owner': 'airflow',  
    'start_date': datetime(2022, 2, 16)  
}

dag = DAG('AirFlow_5_2_3', schedule_interval='@daily', default_args=default_args)

  
def rand(**kwargs):  
    random_number = randint(0, 10)  
    kwargs['ti'].xcom_push(key='rand', value=random_number)  
    print(f"rand: {random_number}")

  
def rand_print(**kwargs):  
    pulled_value = kwargs['ti'].xcom_pull(key='rand', task_ids='random_number')  
    print(f"Pulled value: {pulled_value}")  
    if pulled_value > 5:  
        return print('higher')  
    else:  
        return print('lower')

  
def branch(**kwargs):  
    xcom_value = int(kwargs['ti'].xcom_pull(key='rand', task_ids='random_number'))  
    if xcom_value > 5:  
        return 'higher'  
    else:  
        return 'lower'

  
# ВАШ КОД  
# Если > 5 то вернуть higher  
# иначе вернуть lower

lower = DummyOperator(  
    task_id='lower',  
    dag=dag  
)

higher = DummyOperator(  
    task_id='higher',  
    dag=dag

)

branch_op = BranchPythonOperator(  
    task_id='branch_task',  
    provide_context=True,  
    python_callable=branch,  
    dag=dag  
)

random_number = PythonOperator(  
    task_id='random_number',  
    python_callable=rand,  
    dag=dag  
)

random_number_print = PythonOperator(  
    task_id='random_number_print',  
    python_callable=rand_print,  
    dag=dag  
)

random_number >> random_number_print >> branch_op >> [lower, higher]  
# random_number >> random_number_print
```