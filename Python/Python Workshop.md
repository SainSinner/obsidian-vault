[data-engineering/DE-101 Modules/Module05/DE - 101 Labs/AWS - Python Workshop/aws-python-workshop.MD at master · Data-Learn/data-engineering · GitHub](https://github.com/Data-Learn/data-engineering/blob/master/DE-101%20Modules/Module05/DE%20-%20101%20Labs/AWS%20-%20Python%20Workshop/aws-python-workshop.MD#%D0%B2%D0%B2%D0%B5%D0%B4%D0%B5%D0%BD%D0%B8%D0%B5)

## Виртуальная среда
Для создания виртуальной среды воспользуемся консольной командой:

```shell
python -m venv my_venv
```
После того, как виртуальная среда создана, вам необходимо активировать ее. После активации ваш код запускается внутри среды, включая любые установленные вами пакеты. Чтобы активировать среду, используйте одну из следующих команд :
**Windows (PowerShell)**

```shell
.\my_venv\Scripts\Activate.ps1
```

Чтобы знать, что вы находитесь внутри виртуальной среды, ваша командная строка будет иметь префикс (my_venv). Теперь любые используемые вами пакеты будут храниться в структуре папок в вашей виртуальной среды.

Чтобы выйти из виртуальной среды, вы вводите deactivate, и в командной строке больше не будет префикса (my_venv).

## Переменные
Переменные в Python объявляются в формате `имя = значение`. В python мы можем хранить разные типы данных без необходимости явно указывать тип при объявлении переменной.

Вот несколько примеров:

```python
a_str = "This is an example of a string in quotes" #строчное значение
my_float = 5.5 #число с плавающей точкой
example_tuple = ("apple", "orange", "pear") #кортеж
boolean_values = True #булево значение
```
Как с переменной взаимодействовать с функцией:
Написав `my_function()`, вы вызываете функцию **в момент присвоения**, а не передаёте её саму в переменную.

Разберём на примере:

python

Copy code

```python
def my_function():
    print("Функция вызвана!")
    return 42

 Здесь вы вызываете my_function, и результат её выполнения (42) присваивается переменной test_function
test_function = my_function()  # Функция вызвана!

print(test_function)  # Вывод: 42
```

#### Разница:

1. **Передача функции как объекта:**
    
    python
    
    Copy code
    
    `test_function = my_function  # Без скобок test_function()  # Вызов функции через переменную # Функция будет вызвана только в этот момент.`
    
2. **Вызов функции при присвоении:**
    
    python
    
    Copy code
    
    `test_function = my_function()  # Со скобками # Функция будет вызвана немедленно, и результат выполнения присвоится п`
### Использование переменных внутри строки

Представьте, что вы хотите использовать значение переменной в середине строки. Это можно сделать несколькими способами.

### .format()

В этом методе вы можете использовать фигурные скобки внутри строки, чтобы указать, куда должна идти переменная. Затем используйте `.format(variable_name)` после кавычек. Если у вас есть несколько переменных, то для каждой переменной вы используете фигурные скобки. В `.format()` отделите каждую переменную запятой. Например `.format (variable_1, variable_2).`

Попробуйте ввести следующий пример в интерактивном режиме питона.

```python
>>>first_name = "John"
>>>surname = "Doe"
>>>print("My first name is {}. My family name is {}".format(first_name, surname))
```

### f-strings

Начиная с версии 3.6 появилась возможность использовать форматирование под названием _f-strings_ для использования переменной внутри строчного значения. Для некоторых этот форматирование более читабельное.

```python
firstname = "Jane"
surname = "Doe"

print(f"My first name is {firstname}. My family name is {surname}")
```

## Словари

Словарь(`dictionary`) - это способ хранения связанной информации в парах ключ-значение (`key-value` pairs). Он использует ключ(`key`) в качестве идентификатора и значение (`value`) для хранения информации. Например, ключом может быть first_name, а значением - Ada.

Словарь, написанный на Python, будет выглядеть как `{"first_name": "Ada"}`.

Словари очень распространены в AWS, поэтому вы будете часто их видеть.

- Они используются для обмена информацией между различными сервисами и функциями.
- Они возвращаются как ответ от Application Programming Interfaces (API).
- Они используются как значения тегов (Tag)

### Создание, чтение, обновление и удаление значений в словаре

### Создание

Словари можно создавать, назначая пары `ключ-значение` (`key-value`), которые вы хотите сохранить в словаре.

Используя интерактивный режим Python, попробуйте следующее:

```python
>>> user = {"first_name":"Ada"}
>>> print(user)
{'first_name': 'Ada'}
```

или если вы собираетесь добавлять содержимое словаря позже, вы можете объявить пустой словарь. Вы можете создать пустой словарь двумя способами:

Присвоение `{}` переменной, например:

`account_details = {}` или конструктор `dict()`:

`account_details = dict()`

### Чтение

Чтобы прочитать значение, связанное с ключом, вам необходимо указать имя словаря и значение ключа в квадратных скобках.

Попробуйте следующее:

```python
>>> user = {"first_name":"Ada"}
>>> print(user["first_name"])
Ada
```

### Обновление

- Добавление новой пары `ключ-значение` (`key-value`)

Словари изменяемы(mutable), то есть их можно изменять после того, как вы их создадите. Вы можете добавлять, обновлять или удалять пары ключ-значение в словаре.

Чтобы добавить в словарь дополнительную пару `ключ-значение`, укажите имя словаря, новый ключ в `[]` и `значение` после знака `=`.

Попробуйте следующее:

```python
>>>user["family_name"] = "Byron"
>>>print(user)
{'first_name': 'Ada', 'family_name': 'Byron'}
```

- Изменение значения

Изменение значения аналогично его добавлению, вы указываете новое значение после знака `=`.

Попробуйте следующее:

```python
user["family_name"] = "Lovelace"
print(user)
{'first_name': 'Ada', 'family_name': 'Lovelace'}
```

### Удаление пары `ключ-значение`

Чтобы удалить пару `ключ-значение`, вы используете оператор `del` с именем словаря и ключом, который вы хотите удалить.

```python
>>> del user["family_name"]
>>> print(user)
{'first_name': 'Ada'}
```
## Списки

Список - это упорядоченная последовательность значений, разделенных пробелами. Например:

`[0,1,2,3,4]`

или

`["apples","oranges","bananas"]`

Список может содержать другие объекты, например словари, о которых мы узнали на прошлом уроке. Например:

`[{"fruit_type":"apples"},{"number":50}]`

### Создание, чтение, обновление и удаление элементов в списке

### Создание

Списки могут быть созданы путем присвоения значений, которые вы хотите сохранить в списке, переменной, например:

`fruit = ["apples","oranges","bananas"]`

или если вы собираетесь добавлять содержимое списка позже, вы можете объявить пустой список. Вы можете создать пустой список двумя способами, подобно словарю:

Присвоение `[]` переменной, например:

`fruit = []` или конструктор `list()`:

`fruit = list()`

### Чтение

Объектам, хранящимся в списке, присваивается порядковый номер, начинающийся с 0. Чтобы прочитать элемент из списка, вы используете порядковый номер сохраненного значения.

Используя интерактивный режим Python, попробуйте следующее:

```python
>>>fruit = ["apples","oranges","bananas"]
>>>print(fruit[1])
oranges
```

В приведенном выше примере python напечатал значение, хранящееся в позиции индекса 1, которая вернула `oranges`, потому что список начинается с позиции 0 (в которой хранятся `apples`).

Вы можете найти длину списка, используя len(). Попробуйте следующее:

```
>>>len(fruit)
3
```

Вы можете вернуть последнее значение в списке или работать в обратном направлении от последнего элемента, используя отрицательное значение индекса. Например, чтобы вернуть последнее значение в списке.

Try the following:

```python
>>>print(fruit[-1])
bananas
>>>print(fruit[-2])
oranges
```

### Обновление

Списки изменяемы, что означает, что они могут быть изменены после того, как вы их создадите. Вы можете добавлять, обновлять, удалять и изменять порядок элементов в списке.

Вы можете использовать `append()`, чтобы добавить элемент в конец списка.

Попробуйте следующее:

```
>>> fruit.append("kiwi")
>>> print(fruit)
['apples', 'oranges', 'bananas', 'kiwi']
```

Если вы хотите добавить элемент в определенную точку списка, вы можете использовать значение индекса с помощью метода `insert()`.

Попробуйте следующее:

```
>>> fruit.insert(2, "passion fruit")
>>> print(fruit)
['apples', 'oranges', 'passion fruit', 'bananas', 'kiwi']
```

### Организация списков

Элементы в списке не сортируются автоматически.

Если вы хотите вернуть отсортированную информацию, но сохранить исходный порядок списка, вы можете использовать функцию `sorted()`.

Попробуйте следующее:

```python
>>>print(sorted(fruit))
['apples', 'bananas', 'kiwi', 'oranges', 'passion fruit']
>>>print(fruit)
['apples', 'oranges', 'passion fruit', 'bananas', 'kiwi']
```

В приведенном выше примере вы можете видеть, что функция `sorted()` возвращает отсортированный список, но не изменяет исходный порядок списка.

Если вы хотите постоянно отсортировать список, вам следует использовать метод `sort()`.

Попробуйте следующее:

```python
>>> fruit.sort()
>>> print(fruit)
['apples', 'bananas', 'kiwi', 'oranges', 'passion fruit']
```

Чтобы изменить порядок списка, вы можете использовать метод `reverse()`. Это навсегда изменит порядок в списке.

Попробуйте следующее:

```
>>>fruit.reverse()
>>> print(fruit)
['passion fruit', 'oranges', 'kiwi', 'bananas', 'apples']
```

Чтобы отменить это действие. вы должны просто снова использовать `reverse()`, чтобы восстановить исходный порядок.

### Удаление

Вы можете удалить элементы из списка, используя оператор `del`, если вы знаете позицию индекса.

Попробуйте следующее:

```python
>>> del fruit[1]
>>> print(fruit)
['passion fruit', 'kiwi', 'bananas', 'apples']
```

Если вы используете `del`, элемент удаляется, поэтому вы больше не можете его использовать. Например, если у вас есть список пользователей, вы можете удалить пользователя.

Если вы хотите использовать значение после удаления его из списка, используйте метод `pop()`. Чтобы использовать `pop()`, вам нужно сохранить значение, которое вы удалили из списка, внутри другой переменной.

Попробуйте следующее:

```python
>>>favorite_fruit = fruit.pop()
>>>print(favorite_fruit)
apples
```

В этом примере `pop()` вернул последний элемент в списке, который является значением по умолчанию для `pop()`. Вы можете вернуть любой элемент с помощью `pop()`, используя значение индекса.

Попробуйте следующее:

```python
>>> fresh_fruit = fruit.pop(1)
>>> print(fresh_fruit)
kiwi
```

Если вы не знаете позицию индекса или не хотите удалять последний элемент в списке, вы можете использовать метод `remove()`, чтобы указать значение элемента, который вы хотите удалить.

Попробуйте следующее:

```python
>>> fruit.remove('bananas')
>>> print(fruit)
['passion fruit']
```

Помните, что когда вы используете `del`, `pop()` или `remove()`, элемент безвозвратно удаляется из исходного списка. Если список распечатан, вы увидите, что эти элементы больше не хранятся в списке.

## Определение типа данных

Иногда ваш код вызывает ошибку `TypeError`. Это может быть неприятно исправлять. Первым шагом часто бывает выяснение типа данных.

Чтобы узнать, какой тип данных Python хранит в переменной, можно использовать метод `type()`.

В IDE (интегрированная среда разработки ) попробуйте следующее:

```python
>>>my_variable = "A string"
>>>print(type(my_variable))
```

На экране дложно быть выведено следующее:

```python
<class 'str'>
```

Как только вы узнаете тип данных, вы можете решить проблему, явно указав, как вы хотите, чтобы Python обрабатывал данные.

Вот пример `TypeError` ниже.

```python
>>> my_number = 50
>>> some_string = "The number is "
>>> print(some_string + my_number)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: can only concatenate str (not "int") to str
```

Вот как мы можем исправить ошибку `TypeError`, указав Питону преобразовать `my_number` в строку.

```python
>>> my_number = 50
>>> some_string = "The number is "
>>> print(some_string + str(my_number))
The number is 50
```
## Создание файла requirements.txt


Когда вы введете `pip freeze`, вы увидите все пакеты, установленные в вашей виртуальной среде. Нам нужно иметь возможность воссоздать набор пакетов, когда код будет повторно использован где-то еще. Например, на другом компьютере или в другой среде. Для этого используется файл `requirements.txt`. Этот файл содержит список всех пакетов и версий, необходимых для установки новой среды.

Вы можете создать файл `requirements.txt` с помощью команды

```shell
pip freeze> requirements.txt.
```

В текущем каталоге будет создан файл `requirements.txt`.

Чтобы установить файл `requirements.txt` в новой виртуальной среде, введите следующий код чтобы установить все те же пакеты и зависимости из этого файла.

```shell
pip install -r requirements.txt
```

## Введение в boto3

### 1. **Установите библиотеку boto3**

Установите библиотеку с помощью pip:

bash

Copy code

`pip install boto3`

---

### 2. **Настройте AWS CLI (опционально)**

Хотя AWS CLI не является обязательным, он помогает быстро настроить учетные данные. Установите CLI, если его еще нет:

- [Инструкция по установке AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

Затем настройте AWS CLI:

bash

Copy code

`aws configure`

Вам будет предложено указать:

- **AWS Access Key ID**: Учетные данные, которые вы получили в AWS.
- **AWS Secret Access Key**: Секретный ключ для доступа.
- **Default region**: Например, `us-east-1`.
- **Output format**: Можно оставить `json`.

!Все параметры указанные выше можно заполнить сгенерировав Access key на вкладке 
[Security credentials | IAM | Global](https://us-east-1.console.aws.amazon.com/iam/home?region=eu-north-1#/security_credentials)

Эти учетные данные сохранятся в файле `~/.aws/credentials`.

## Запуск скрипта из командной строки с аргументами.  Argparse

Python имеет встроенный парсер аргументов командной строки [argparse](https://docs.python.org/3/library/argparse.html), который упрощает написание интерфейсов командной строки.

```python
import argparse  # argparse является встроенным пакетом, и его нужно импортировать  
import boto3  
  
# присваиваем переменной парсера значение argparse.ArgumentParser()  
# те. этой командой мы создали парсер  
parser = argparse.ArgumentParser(  
    description="Provides translation between one source language and another of the same set of languages.")  
  
# добавьте каждый аргумент используя метод parser.add_argument()  
# первый аргумент, который мы добавляем отвечает за значение текста, который мы хотим перевести  
parser.add_argument(  
    '--text',  
    # dest="Text",  
    type=str,  
    help="The text to translate. The text string can be a maximum of 5,000 bytes long. Depending on your character set, this may be fewer than 5,000 characters",  
    required=True  
)  
  
parser.add_argument(  
    '--source-language-code',  
    # dest="SourceLanguageCode",  
    type=str,  
    help="The language code for the language of the source text. The language must be a language supported by Amazon Translate.",  
    required=True  
)  
  
parser.add_argument(  
    '--target-language-code',  
    # dest="TargetLanguageCode",  
    type=str,  
    help="The language code requested for the language of the target text. The language must be a language support by Amazon Translate.",  
    required=True  
)  
  
parser.add_argument(  
    '--terminology-names',  
    # dest="TerminologyNames",  
    type=tuple,  
    help="The name of a terminology list file to add to the translation job. This file provides source terms and the desired translation for each term. A terminology list can contain a maximum of 256 terms. You can use one custom terminology resource in your translation request.",  
    required=False,  
    default=()  
)  
  
# код ниже:  
# - проанализирует командную строку  
# - разделит ввод на аргументы  
# - конвертирует каждый аргумент в тот тип данных, который мы указали выше  
  
args = parser.parse_args()  
  
print(args)  
  
def translate_text(**kwargs):  
    client = boto3.client('translate')  
    response = client.translate_text(**kwargs)  
    print(response)  
  
  
def main():  
    # vars() - это встроенная функция, которая возвращает данные в виде словаря  
    translate_text(**vars(args))  
  
  
if __name__ == "__main__":  
    main()
```
**dest** - задает имя аргументу отличное от дефолтного, например `SourceLanguageCode`, но если без него выполнять, то будет следующее `source_language_code` что тоже можно потом использовать.
**vars(args)** - позволяет вернуть аргументы в виде словаря типа  `Namespace(text='we are learning python on ', source_language_code='en', target_language_code='ru', terminology_names=())`
**Если хотим создать необязательный аргумент** - необходимо обозначить `required=False`, но так же важно задать его значение по умолчанию, например `default=()`, это позволит избежать следующей ошибки
*Invalid type for parameter TerminologyNames, value: None, type: <class 'NoneType'>, valid types: <class 'list'>, <class 'tuple'>*

## Ввод данных из файла

Для загрузки файла будем использовать встроенную функцию `open`. В [документации](https://docs.python.org/3/library/functions.html#open) показано, что `open` имеет необязательный параметр. В приведенном ниже примере мы передаем в него значение 'r', который означает, что файл открыт только для чтения. Для записи в файл вам нужно использовать `w`.

```python
def open_input(file):
    with open(file, 'r') as f:
        text = f.read() #используем read() для чтения содержимого файла 
        print(text)

def main():
    open_input("text.txt")

if __name__=="__main__":
    main()
```

## Ввод данных из JSON
Когда мы конвертируем Python в JSON, происходит некоторое преобразование. Сопоставление показано ниже:

|Python|JSON|
|:--|:--|
|dict|object|
|list,tuple|array|
|str|string|
|int, float|number|
|True|true|
|False|false|
|None|null|
#### json.loads() и json.dumps()

Прежде чем подгружать внешний файл, стоит изучить  
`json.loads()` и `json.dumps()`. Эти два метода используют строки JSON. Когда вы учитесь управлять `JSON`, легко запутаться между `json.loads()` и `json.load()` или `json.dumps()` и `json.dump()`.

Вот простой способ узнать, что использовать.

- `json.load` () и `json.dump()` - используются для ввода и вывода JSON из файлов и в файлы.
- `json.loads` () и `json.dumps()` - используются для ввода и вывода JSON из строк и в строки.

```python
import json  
  
# вводные данные - JSON строка   
json_string = """  
{  
    "Input":[        {        "Text":"I am learning to code in AWS",        "SourceLanguageCode":"en",        "TargetLanguageCode":"fr",        "Required": true        }    ]}  
"""  
  
def main():  
    json_input = json.loads(json_string)  
    text = json_input['Input'][0]['Text']  
    source_language_code = json_input['Input'][0]['SourceLanguageCode']  
    target_language_code = json_input['Input'][0]['TargetLanguageCode']  
    print(text, source_language_code, target_language_code)  
  
if __name__=="__main__":  
    main()
```

##### через файл 
Создайте новый файл с именем `translate_input.json`.

Вставьте следующий текст в файл.

```json
{
    "Input":[
        {
        "Text":"I am learning to code in AWS",
        "SourceLanguageCode":"en",
        "TargetLanguageCode":"fr"
        }
    ]
}
```

Измените `lab_5_step_4_json_input.py`.

Введите или вставьте в файл следующее:

```python
# встроенные библиотеки
import argparse
import json

# установленные библиотеки
import boto3

# аргументы
parser = argparse.ArgumentParser(description="Provides translation  between one source language and another of the same set of languages.")
parser.add_argument(
    '--file',
    dest='filename',
    help="The path to the input file. The file should be valid json",
    required=True)

args = parser.parse_args()

# функции
def open_input():
    with open(args.filename) as file_object:
        contents = json.load(file_object)
        return contents['Input'][0]

def translate_text(**kwargs): 
    client = boto3.client('translate')
    response = client.translate_text(**kwargs)
    print(response) 

# Функция Main - в которой мы вызываем другие функции
def main():
    kwargs = open_input()
    translate_text(**kwargs)

if __name__ == "__main__":
    main()
```


## Циклы
Если вы хотите при каждом повторении увеличить счетчик больше, чем значение по умолчанию (равное 1), добавляете третий параметр к функции `range()`, как показано в следующем коде. Такая фича вам будет полезна, если вам нужны только нечетные или четные числа счетчика, например.

```python
>>> for number in range(1,10,2):
...     print(f'The next number is {number}')
```
 Цикл который проходится по объектам json с предварительной валидацией JSON
 запускается через командную строку из директории где расположен
 ```shell
 python lab_6_step_2_loops.py --file translate_input.json --path-to-file-avro-schema ./avro_schema_json.avcs
```
 
 ```python
 # встроенные пакеты  
import argparse  
import json  
  
from fastavro.schema import load_schema  
from fastavro import validate  
  
# установленный пакет  
import boto3  
  
# добавление аргументов  
parser = argparse.ArgumentParser(  
    description="Provides translation  between one source language and another of the same set of languages.")  
parser.add_argument(  
    '--file',  
    dest='filename',  
    help="The path to the input file. The file should be valid json",  
    required=True)  
parser.add_argument(  
    '--path-to-file-avro-schema',  
    dest='path_to_file_avro_schema',  
    type=str,  
	help="The path to the file with validation schema. The file should be valid avcs and type of file should be .avsc.",

    required=True)  
  
args = parser.parse_args()  
  
  
# вспомогательные функции  
def open_input():  
    """This function returns a dictionary containing the contents of the Input section in the input file"""  
    with open(args.filename) as file_object:  
        contents = json.load(file_object)  
        # Добавим валидацию Json файла avro schema  
        avro_schema = load_schema(schema_path=args.path_to_file_avro_schema)  
        validate(datum=contents, schema=avro_schema)  
    return contents['Input']  
  
  
# функция Boto3, которая использует Amazon Translate для перевода текста и возвращает только переведенный текст  
def translate_text(**kwargs):  
    client = boto3.client('translate')  
    response = client.translate_text(**kwargs)  
    print(response['TranslatedText'])  
  
  
# цикл для перебора элементов JSON файла  
def translate_loop():  
    input_text = open_input()  
    for item in input_text:  # тут мы перебираем словари из файла  
        translate_text(**item)  
  
  
# функция Main - для вызова других функций  
def main():  
    translate_loop()  
  
  
if __name__ == "__main__":  
    main()
```

### Генераторы списков

До сих пор в наших примерах был представлен список элементов для перебора. Что, если мы хотим создать новый список из предоставленных данных. Например, может быть, мы хотим сгенерировать список только из текста (из словаря из файла JSON), который мы хотим перевести.

Вы можете сделать это с помощью встроенного метода Python `.append()` и цикла for.

Добавьте следующую функцию в свой код в lab_6_step_2_loops.py.

```python
def new_input_text_list():
    input_text = open_input()
    new_list = []
    for item in input_text:
        text = item['Text']
        new_list.append(text)
    print(new_list)
```

Не забудьте вызвать этой функцию из `main()`, иначе наша новая функция не запустится.

```python
def main():
    new_input_text_list()
    translate_loop()
```

Для запуска программы введите в терминале следующую команду:

`python lab_6_step_2_loops.py --file translate_input.json`

Это должно вернуть следующее:

```shell
['What is cloud computing?', 'Cloud computing is the on-demand delivery of IT 
resources over the Internet with pay-as-you-go pricing.', 'Instead of buying, 
owning, and maintaining physical data centers and servers, you can access technology 
services, such as computing power, storage, and databases, on an as-needed basis from 
a cloud provider like Amazon Web Services (AWS)', 'Who is using cloud computing?', 
'Organizations of every type, size, and industry are using the cloud for a wide variety 
of use cases, such as data backup, disaster recovery, email, virtual desktops, software 
development and testing, big data analytics, and customer-facing web applications.', 
'For example, healthcare companies are using the cloud to develop more personalized treatments 
for patients. Financial services companies are using the cloud to power real-time fraud detection 
and prevention.', 'And video game makers are using the cloud to deliver online games to millions 
of players around the world.']
```

Вы можете видеть, что это список, заключенный в квадратные скобки []

### Генератор списков/list_comprehension

Использование цикла `for` для создания новых списков с помощью `.append()` - вполне допустимый способ создания новых списков. Однако мы можем использовать составление списка, чтобы свести его к одной строке. Он объединяет цикл `for` и создание списка в одну строку.

В `lab_6_step_2_loops.py` добавьте следующий код под функцией `new_input_text_list()`:

```python
def new_list_comprehension():
    input_text = open_input()
    list_comprehension = [item['Text'] for item in input_text]
    print(list_comprehension)
```

Измените функцию `main()` следующим образом:

```python
def main():
    new_input_text_list()
    translate_loop()
    new_list_comprehension()
```

Для запуска программы введите в терминале следующую команду:

`python lab_6_step_2_loops.py --file translate_input.json`

Вы увидите, что он выполняет ту же функцию, что и цикл `for`, но в одной строке. Хотя для начала генераторы списков выглядят сложными, вы можете разбить структуру выражения, чтобы ее было легче запомнить.

1. Генератор списка присваивается переменной `list_comprehension`.
2. Поскольку мы создаем список, он заключен в [], это заменяет строку new_list = [], которая использовалась для создания пустого списка.
3. Код после первой части определяет, какое конкретное значение мы хотим включить в список `item['Text']`, который заменяет `text = item ['Text']` и его присвоение переменной.
4. Вторая часть выражения - это for цикл `for item в input_text`, который идентичен исходному циклу `for item in input_text:`
## Условия

### Пример использования 

```python
import json

# вводные данные в виде json строки
json_string = """
{
    "Input":[
        {
        "Text":"I am learning to code in AWS",
        "SourceLanguageCode":"en",
        "TargetLanguageCode":"fr"
        }
    ]
}
"""

json_input = json.loads(json_string) # используем метод loads так как загружает информацию из json строки.

# задаем 2 переменные для хранения кода языка
SourceLanguageCode = json_input['Input'][0]['SourceLanguageCode']
TargetLanguageCode = json_input['Input'][0]['TargetLanguageCode']

#  if проверяет эквивалентность исходного и целевого языка
if SourceLanguageCode == TargetLanguageCode:
    print("The SourceLanguageCode is the same as the TargetLanguageCode - stopping")
else:
    print("The Source Language and Target Language codes are different - proceeding")
```

Это должно вернуться:

```shell
The Source Language and Target Language codes are different - proceeding
```

### Операторы


При использовании операторов `if` вы часто будете использовать разные операторы для определения эквивалентности. Вот некоторые из операторов, которые поддерживает Python:

|Оператор|Значение|
|:--|:--|
|==|эквивалентно|
|!=|не эквивалентно|
|>|больше чем|
|<|меньше чем|
|>=|больше или равно|
|<=|меньше или равно|

### Проверяем значение в списке

if SourceLanguageCode in languages:

```python
import json

# список языков поддерживаемых Amazon Translate
languages = ["af","sq","am","ar","az","bn","bs","bg","zh","zh-TW","hr","cs","da","fa-AF","nl","en","et","fi","fr","fr-CA","ka","de","el","ha","he","hi","hu","id","it","ja","ko","lv","ms","no","fa","ps","pl","pt","ro","ru","sr","sk","sl","so","es","sw","sv","tl","ta","th","tr","uk","ur","vi"]

# используем json строку как вводные данные
json_string = """
{
    "Input":[
        {
        "Text":"I am learning to code in AWS",
        "SourceLanguageCode":"en",
        "TargetLanguageCode":"fr"
        }
    ]
}
"""

json_input = json.loads(json_string)

# присваиваем переменным SourceLanguageCode and TargetLanguageCode значения из JSON файла
SourceLanguageCode = json_input['Input'][0]['SourceLanguageCode']
TargetLanguageCode = json_input['Input'][0]['TargetLanguageCode']

# используем if-else условие чтобы проверить наличие SourceLanguageCode в списке языков languages.
if SourceLanguageCode in languages:
    print("The SourceLanguageCode is valid - proceeding")
else:
    print("The SourceLanguageCode is not valid - stopping")
```
### Проверка вводных данных

Проверяем на вхождение TargetLanguageCode и SourceLanguageCode в список который мы определили в коде.

```python
# встроенные пакеты  
import argparse  
import json  
  
from fastavro.schema import load_schema  
from fastavro import validate  
  
# установленный пакет  
import boto3  
  
# добавление аргументов  
parser = argparse.ArgumentParser(  
    description="Provides translation  between one source language and another of the same set of languages.")  
parser.add_argument(  
    '--file',  
    dest='filename',  
    help="The path to the input file. The file should be valid json",  
    required=True)  
parser.add_argument(  
    '--path-to-file-avro-schema',  
    dest='path_to_file_avro_schema',  
    type=str,  
    help="The path to the file with validation schema. The file should be valid avcs and type of file should be .avsc.",  
    required=True)  
  
args = parser.parse_args()  
  
  
# вспомогательные функции  
def open_input():  
    """This function returns a dictionary containing the contents of the Input section in the input file"""  
    with open(args.filename) as file_object:  
        contents = json.load(file_object)  
        # Добавим валидацию Json файла avro schema  
        avro_schema = load_schema(schema_path=args.path_to_file_avro_schema)  
        validate(datum=contents, schema=avro_schema)  
    return contents['Input']  
  
  
# функция Boto3, которая использует Amazon Translate для перевода текста и возвращает только переведенный текст  
def translate_text(**kwargs):  
    client = boto3.client('translate')  
    response = client.translate_text(**kwargs)  
    print(response['TranslatedText'])  
  
  
# цикл для перебора элементов JSON файла  
def translate_loop():  
    input_text = open_input()  
    for item in input_text:  # тут мы перебираем словари из файла  
        if input_validation(item) == True:  
            translate_text(**item)  
        else:  
            raise SystemError  
  
  
# функция для проверки данных из JSON строки  
def input_validation(item):  
    languages = ["af", "sq", "am", "ar", "az", "bn", "bs", "bg", "zh", "zh-TW", "hr", "cs", "da", "fa-AF",  
                 "nl", "en", "et", "fi", "fr", "fr-CA", "ka", "de", "el", "ha", "he", "hi", "hu", "id", "it",  
                 "ja", "ko", "lv", "ms", "no", "fa", "ps", "pl", "pt", "ro", "ru", "sr", "sk", "sl", "so", "es",  
                 "sw", "sv", "tl", "ta", "th", "tr", "uk", "ur", "vi"  
                 ]  
    json_input = item  
    SourceLanguageCode = json_input['SourceLanguageCode']  
    TargetLanguageCode = json_input['TargetLanguageCode']  
  
    if SourceLanguageCode == TargetLanguageCode:  
        print("The SourceLanguageCode is the same as the TargetLanguageCode - nothing to do")  
        print("---")  
        return False  
    elif SourceLanguageCode not in languages and TargetLanguageCode not in languages:  
        print("Neither the SourceLanguageCode and TargetLanguageCode are valid - stopping")  
        print("---")  
        return False  
    elif SourceLanguageCode not in languages:  
        print("The SourceLanguageCode is not valid - stopping")  
        print("---")  
        return False  
    elif TargetLanguageCode not in languages:  
        print("The TargetLanguageCode is not valid - stopping")  
        print("---")  
        return False  
    elif SourceLanguageCode in languages and TargetLanguageCode in languages:  
        print("The SourceLanguageCode and TargetLanguageCode are valid - proceeding")  
        print("---")  
        return True  
    else:  
        print("There is an issue")  
        print("---")  
        return False  
  
  
# функция Main - для вызова других функций  
def main():  
    translate_loop()  
  
  
if __name__ == "__main__":  
    main()
```

## Логирование (logging)

Добавление сообщений в наш код, которые предоставляют метаданные о том, как код выполняется, называется логированием. Логи(сообщения) полезны во многих отношениях. Одно из важнейших назначений - помощь в определении мест возникновения ошибок.

В этом разделе для логирования мы будем использовать встроенный модуль [logging](https://docs.python.org/3/library/logging.html).

Судя по документации, модуль logging имеет возможность дифференцировать уровни логов, для того чтобы мы могли эффективнее анализировать наш код.

|Уровень|Когда используется|
|:--|:--|
|DEBUG|Подробная информация, обычно полезная только при диагностике проблем.|
|INFO|Подтверждение того, что все работает должным образом.|
|WARNING|Указание на то, что произошло что-то неожиданное, или указание на некоторую проблему в ближайшем будущем (например, «мало места на диске»). Программное обеспечение по-прежнему работает, как ожидалось.|
|ERROR|Из-за более серьезной проблемы программное обеспечение не могло выполнять некоторые функции.|
|CRITICAL|Серьезная ошибка, указывающая на то, что сама программа может не работать.|

Уровень по умолчанию - WARNING, что означает, что будут отслеживаться только события этого уровня и выше, если пакет logging не настроен на иное.

пример простейшего логирования для взаимодействия с консолью
```python
import logging
import json


json_string = """
{
    "Input":[
        {
        "Text":"I am learning to code in AWS",
        "SourceLanguageCode":"en",
        "TargetLanguageCode":"fr"
        }
    ]
}
"""

json_input = json.loads(json_string)


SourceLanguageCode = json_input['Input'][0]['SourceLanguageCode']
TargetLanguageCode = json_input['Input'][0]['TargetLanguageCode']

if SourceLanguageCode == TargetLanguageCode:
    logging.warning("The SourceLanguageCode is the same as the TargetLanguageCode - stopping") 
    # если сработает данное условие, сообщение выведется на консоле, потому что это `warning`
else:
    logging.info("The Source Language and Target Language codes are different - proceeding") # # # если сработает данное условие, сообщение не выведется на консоле потому что уровень лога info ниже чем warning
```

Пример логирования с различными случаями 

```python
  
# встроенные пакеты  
import argparse  
import json  
import logging  
import boto3  
  
# уровень DEBUG означает, что все уровни логирования будут сохранены в файл  
logging.basicConfig(filename='translate.log',level=logging.DEBUG)  
  
# добавление аргументов  
parser = argparse.ArgumentParser(description="Provides translation  between one source language and another of the same set of languages.")  
parser.add_argument(  
    '--file',  
    dest='filename',  
    help="The path to the input file. The file should be valid json",  
    required=True)  
  
args = parser.parse_args()  
  
# функции  
  
# загружаем json строку  
def open_input():  
    with open(args.filename) as file_object:  
        contents = json.load(file_object)  
        return contents['Input']  
  
# функция Boto3, которая использует Amazon Translate для перевода текста и возвращает только переведенный текст  
def translate_text(**kwargs):  
    client = boto3.client('translate')  
    response = client.translate_text(**kwargs)  
    print(response['TranslatedText'])  
  
# цикл для перебора элементов JSON файла  
def translate_loop():  
    input_text = open_input()  
    for item in input_text:  
        if input_validation(item) == True:  
            translate_text(**item)  
        else:  
            raise SystemError  
  
# функция для проверки данных из JSON строки  
def input_validation(item):  
    languages = ["af","sq","am","ar","az","bn","bs","bg","zh","zh-TW","hr","cs","da","fa-AF",  
                "nl","en","et","fi","fr","fr-CA","ka","de","el","ha","he","hi","hu","id","it",  
                "ja","ko","lv","ms","no","fa","ps","pl","pt","ro","ru","sr","sk","sl","so","es",  
                "sw","sv","tl","ta","th","tr","uk","ur","vi"  
                ]  
    json_input=item  
    SourceLanguageCode = json_input['SourceLanguageCode']  
    TargetLanguageCode = json_input['TargetLanguageCode']  
  
    if SourceLanguageCode == TargetLanguageCode:  
        logging.warning("The SourceLanguageCode is the same as the TargetLanguageCode - nothing to do")  
        logging.debug(f"SourceLanguageCode:{SourceLanguageCode}\nTargetLanguageCode:{TargetLanguageCode}")  
        return False  
    elif SourceLanguageCode not in languages and TargetLanguageCode not in languages:  
        logging.warning("Neither the SourceLanguageCode and TargetLanguageCode are valid - stopping")  
        logging.debug(f"SourceLanguageCode:{SourceLanguageCode}\nTargetLanguageCode:{TargetLanguageCode}")  
        return False  
    elif SourceLanguageCode not in languages:  
        logging.warning("The SourceLanguageCode is not valid - stopping")  
        logging.debug(f"SourceLanguageCode:{SourceLanguageCode}")  
        return False  
    elif TargetLanguageCode not in languages:  
        logging.warning("The TargetLanguageCode is not valid - stopping")  
        logging.debug(f"TargetLanguageCode:{TargetLanguageCode}")  
        return False  
    elif SourceLanguageCode in languages and TargetLanguageCode in languages:  
        logging.info("The SourceLanguageCode and TargetLanguageCode are valid - proceeding")  
        return True  
    else:  
        logging.warning("There is an issue")  
        logging.debug(f"SourceLanguageCode:{SourceLanguageCode}\nTargetLanguageCode:{TargetLanguageCode}")  
        return False  
  
# функция Main для вызова других функций  
def main():  
    translate_loop()  
  
if __name__ == "__main__":  
    main()
```
## Ошибки и исключения


Может быть несколько операторов except, в которых подробно описывается, что делать в случае различных типов ошибок.

Пример:

```python
import logging

integer = 50
string = "The number is"

try:
    print(string + integer)
except TypeError as t_err:
    logging.warning("Error - {}. You cannot add a string to an integer, without converting the integer to a string first".format(t_err))
except ValueError as v_err:
    logging.warning("Error - {}. Your message".format(v_err))
```

Чтобы сработал except ValueError необходимо передать попытаться преобразовать набор букв в число.
## Хранение данных
### Создание таблицы

На этом этапе вы создаете таблицу `Movies`. Первичный ключ таблицы состоит из следующих атрибутов:

- year - ключ раздела. AttributeType - это N для числа.
- title - ключ сортировки. AttributeType - S для строки. Скопируйте следующую программу и вставьте ее в файл с именем `MoviesCreateTable.py`.
```python
import boto3

dynamodb = boto3.resource('dynamodb', region_name='us-west-2')

table = dynamodb.create_table(
    TableName='Movies',
    KeySchema=[
        {
            'AttributeName': 'year',
            'KeyType': 'HASH'  #Partition key
        },
        {
            'AttributeName': 'title',
            'KeyType': 'RANGE'  #Sort key
        }
    ],
    AttributeDefinitions=[
        {
            'AttributeName': 'year',
            'AttributeType': 'N'
        },
        {
            'AttributeName': 'title',
            'AttributeType': 'S'
        },

    ],
    ProvisionedThroughput={
        'ReadCapacityUnits': 10,
        'WriteCapacityUnits': 10
    }
)

print("Table status:", table.table_status)

```

Ниже приведен пример данных фильма.

```json
{
    "year" : 2013,
    "title" : "Turn It Down, Or Else!",
    "info" : {
        "directors" : [
            "Alice Smith",
            "Bob Jones"
        ],
        "release_date" : "2013-01-18T00:00:00Z",
        "rating" : 6.2,
        "genres" : [
            "Comedy",
            "Drama"
        ],
        "image_url" : "http://ia.media-imdb.com/images/N/O9ERWAU7FS797AJ7LU8HN09AMUP908RLlo5JF90EWR7LJKQ7@@._V1_SX400_.jpg",
        "plot" : "A rock band plays their music at high volumes, annoying the neighbors.",
        "rank" : 11,
        "running_time_secs" : 5215,
        "actors" : [
            "David Matthewman",
            "Ann Thomas",
            "Jonathan G. Neff"
       ]
    }
}
```

### Загрузите данные в таблицу фильмов
```python
import boto3
import json
import decimal

dynamodb = boto3.resource('dynamodb', region_name='us-west-2')

table = dynamodb.Table('Movies')

with open("moviedata.json") as json_file:
    movies = json.load(json_file, parse_float = decimal.Decimal)
    for movie in movies:
        year = int(movie['year'])
        title = movie['title']
        info = movie['info']

        print("Adding movie:", year, title)

        table.put_item(
           Item={
               'year': year,
               'title': title,
               'info': info,
            }
        )

```

### Чтение элементов

```python
import boto3  
import json  
import decimal  
from boto3.dynamodb.conditions import Key, Attr  
from botocore.exceptions import ClientError  
  
class DecimalEncoder(json.JSONEncoder):  
    def default(self, o):  
        if isinstance(o, decimal.Decimal):  
            if o % 1 > 0:  
                return float(o)  
            else:  
                return int(o)  
        return super(DecimalEncoder, self).default(o)  
  
dynamodb = boto3.resource("dynamodb", region_name='us-west-2')  
  
table = dynamodb.Table('Movies')  
  
title = "Shrek"  
year = 2001  
  
try:  
    response = table.get_item(  
        Key={  
            'year': year,  
            'title': title  
        }  
    )  
except ClientError as e:  
    print(e.response['Error']['Message'])  
else:  
    item = response['Item']  
    print("GetItem succeeded:")  
    print(json.dumps(item, indent=4, cls=DecimalEncoder))  
  
  
  
if __name__ == "__main__":  
    main()
```

### Обновление элемента

```python
import boto3
import json
import decimal

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            if o % 1 > 0:
                return float(o)
            else:
                return int(o)
        return super(DecimalEncoder, self).default(o)

dynamodb = boto3.resource('dynamodb', region_name='us-west-2')

table = dynamodb.Table('Movies')

title = "Shrek"
year = 2001

response = table.update_item(
    Key={
        'year': year,
        'title': title
    },
    UpdateExpression="set info.rating=:r, info.plot=:p, info.actors=:a",
    ExpressionAttributeValues={
        ':r': decimal.Decimal(10.0),
        ':p': "Everything happens all at once.",
        ':a': ["Larry", "Moe", "Curly"]
    },
    ReturnValues="UPDATED_NEW"
)

print("UpdateItem succeeded:")
print(json.dumps(response, indent=4, cls=DecimalEncoder))

```

### Увеличение/уменьшение атомарного счетчика

```python
import boto3
import json
import decimal

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            if o % 1 > 0:
                return float(o)
            else:
                return int(o)
        return super(DecimalEncoder, self).default(o)

dynamodb = boto3.resource('dynamodb', region_name='us-west-2')

table = dynamodb.Table('Movies')

title = "Shrek"
year = 2001

response = table.update_item(
    Key={
        'year': year,
        'title': title
    },
    UpdateExpression="set info.rating = info.rating 1 :val",
    ExpressionAttributeValues={
        ':val': decimal.Decimal(1)
    },
    ReturnValues="UPDATED_NEW"
)

print("UpdateItem succeeded:")
print(json.dumps(response, indent=4, cls=DecimalEncoder))
```

### Обновить элемент (условно)
```python
import boto3  
import json  
import decimal  
from botocore.exceptions import ClientError  
  
  
class DecimalEncoder(json.JSONEncoder):  
    def default(self, o):  
        if isinstance(o, decimal.Decimal):  
            if o % 1 > 0:  
                return float(o)  
            else:  
                return int(o)  
        return super(DecimalEncoder, self).default(o)  
  
dynamodb = boto3.resource('dynamodb', region_name='us-west-2')  
  
table = dynamodb.Table('Movies')  
  
title = "Shrek"  
year = 2001  
  
# условное обновление (провалится)  
print("Attempting conditional update...")  
  
try:  
    response = table.update_item(  
        Key={  
            'year': year,  
            'title': title  
        },  
        UpdateExpression="remove info.actors[0]",  
        ConditionExpression="size(info.actors) > :num",  
        ExpressionAttributeValues={  
            ':num': 2  
        },  
        ReturnValues="UPDATED_NEW"  
    )  
  
except ClientError as e:  
    if e.response['Error']['Code'] == "ConditionalCheckFailedException":  
        print(e.response['Error']['Message'])  
    else:  
        raise  
  
  
print("UpdateItem succeeded:")  
print(json.dumps(response, indent=4, cls=DecimalEncoder))  
  
if __name__ == "__main__":  
    main()
```

### Удаление элемента

```python
import boto3  
import json  
import decimal  
from botocore.exceptions import ClientError  
  
  
class DecimalEncoder(json.JSONEncoder):  
    def default(self, o):  
        if isinstance(o, decimal.Decimal):  
            if o % 1 > 0:  
                return float(o)  
            else:  
                return int(o)  
        return super(DecimalEncoder, self).default(o)  
  
dynamodb = boto3.resource('dynamodb', region_name='us-west-2')  
  
table = dynamodb.Table('Movies')  
  
title = "Shrek"  
year = 2001  
  
print("Attempting a conditional delete...")  
  
try:  
    response = table.delete_item(  
        Key={  
            'year': year,  
            'title': title  
        },  
        ConditionExpression="info.rating <= :val",  
        ExpressionAttributeValues= {  
            ":val": decimal.Decimal(5)  
        }  
    )  
except ClientError as e:  
    if e.response['Error']['Code'] == "ConditionalCheckFailedException":  
        print(e.response['Error']['Message'])  
    else:  
        raise  
else:  
    print("DeleteItem succeeded:")  
    print(json.dumps(response, indent=4, cls=DecimalEncoder))  
  
if __name__ == "__main__":  
    main()
```

### Запросы и сканирование данных

#### Query - Все фильмы, выпущенные за год

```python
import boto3  
import json  
import decimal  
from boto3.dynamodb.conditions import Key, Attr  
  
class DecimalEncoder(json.JSONEncoder):  
    def default(self, o):  
        if isinstance(o, decimal.Decimal):  
            if o % 1 > 0:  
                return float(o)  
            else:  
                return int(o)  
        return super(DecimalEncoder, self).default(o)  
  
dynamodb = boto3.resource('dynamodb', region_name='us-west-2')  
  
table = dynamodb.Table('Movies')  
  
print("Movies from 2001")  
  
response = table.query(  
    KeyConditionExpression=Key('year').eq(2001)  
)  
  
for i in response['Items']:  
    print(i['year'], ":", i['title'])
```