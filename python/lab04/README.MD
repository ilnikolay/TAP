## Task 1:
```python
import csv
def parser(file):
    with open(file, newline='') as f:
        reader = csv.reader(f, quoting=csv.QUOTE_ALL, skipinitialspace=True)
        for row in reader:
            print(row)
```
### Input file:
```csv
"Name",     "Sex", "Age", "Height (in)", "Weight (lbs)"
"Alex",       "M",   41,       74,      170
"Bert",       "M",   42,       68,      166
"Carl",       "M",   32,       70,      155
"Dave",       "M",   39,       72,      167
```
### Output from script:
```
['Name', 'Sex', 'Age', 'Height (in)', 'Weight (lbs)']
['Alex', 'M', '41', '74', '170']
['Bert', 'M', '42', '68', '166']
['Carl', 'M', '32', '70', '155']
['Dave', 'M', '39', '72', '167']
```

## Task 2
```python
import csv

def list_csv(list, file):
    with open(file, 'w') as f:
        write = csv.writer(f, quoting=csv.QUOTE_NONNUMERIC)
        write.writerows(list)


def csv_dict(file):
    with open(file, newline='') as f:
        reader = csv.DictReader(f)
        for row in reader:
            print(row)
```

### Input for task2:
```
list_of = [["Name", "Last Name", "Profession", "Age"],
        ["John", "Doe", "Accountant", 38],
        ["Amanda", "Smith", "CFO", 50],
        ["Rick", "Pitt", "Engineer", 28],
        ["Tom", "Gasly", "Athlete", 24],
        ["Ross", "Hendriks", "Musician", 35]]
```
### CSV file:
```csv
"Name","Last Name","Profession","Age"
"John","Doe","Accountant",38
"Amanda","Smith","CFO",50
"Rick","Pitt","Engineer",28
"Tom","Gasly","Athlete",24
"Ross","Hendriks","Musician",35
```
### Dict output from task2:
```
{'Name': 'John', 'Last Name': 'Doe', 'Profession': 'Accountant', 'Age': '38'}
{'Name': 'Amanda', 'Last Name': 'Smith', 'Profession': 'CFO', 'Age': '50'}
{'Name': 'Rick', 'Last Name': 'Pitt', 'Profession': 'Engineer', 'Age': '28'}
{'Name': 'Tom', 'Last Name': 'Gasly', 'Profession': 'Athlete', 'Age': '24'}
{'Name': 'Ross', 'Last Name': 'Hendriks', 'Profession': 'Musician', 'Age': '35'}
```

## Task 3
```python
import json
"""
Repeated Names Within an Object
The RFC specifies that the names within a JSON object should be unique, but does not mandate how repeated names in JSON objects should be handled.
By default, this module does not raise an exception;
instead, it ignores all but the last name-value pair for a given name
"""

def unique(json_input):
    json_input = json.loads(json_input)
    print(json.dumps(json_input, indent = 4, sort_keys=True))
```

### Input for task 3:
```
person_string = '{"name": "Bob", "languages": "English", "numbers": [2, 1.6, null], "name": "test1223"}'
```
### Output for task 3:
```json
{
    "languages": "English",
    "name": "test1223",
    "numbers": [
        2,
        1.6,
        null
    ]
}
```

## Task 4
```python
def bold(func):
    def dec():
        return "<b> " + func() + " </b>"
    return dec

def italic(func):
    def dec():
        return "<i> " + func() + " </i>"
    return dec

def underscore(func):
    def dec():
        return "<u> " + func() + " </u>" 
    return dec
```
### Output task4:
```python
@underscore
@italic
@bold
def hello():
    return "hello world"

output:
<u> <i> <b> hello world </b> </i> </u>
```

## Task 5
```python
#!/usr/bin/env python3

import sys
import os
import csv

arg_count = 2
exit_wrong_args = 65

file = os.path.abspath('/etc/passwd')
script_name = sys.argv[0].split('/')[-1]

if len(sys.argv) != arg_count:
    print(f'Usage {script_name} USERNAME')
    sys.exit(exit_wrong_args)

pattern = sys.argv[1]


def file_excerpt(username):
    with open(file, newline='') as f:
        reader = csv.reader(f, delimiter=':')
        for row in reader:
                if row[0] == username:
                    print(row[4])

file_excerpt(pattern)
```
### Output Task5:
```bash
>./realname.py root

>System Administrator
```