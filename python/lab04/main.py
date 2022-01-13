import csvparse
import converter
import jsonparse
import json
from decor import underscore, italic, bold


# Task 2 input:
list_of = [["Name", "Last Name", "Profession", "Age"],
        ["John", "Doe", "Accountant", 38],
        ["Amanda", "Smith", "CFO", 50],
        ["Rick", "Pitt", "Engineer", 28],
        ["Tom", "Gasly", "Athlete", 24],
        ["Ross", "Hendriks", "Musician", 35]]

# Task 3 input:
person_string = '{"name": "Bob", "languages": "English", "numbers": [2, 1.6, null], "name": "test1223"}'

# Task 4:
@underscore
@italic
@bold
def hello():
    return "hello world"


def main():
    # Task1:
    # csvparse.parser('/Users/nikolayninov/Work/TAP/python/lab04/biostats.csv')

    # Task2:
    # converter.list_csv(list_of, 'test.csv')
    # converter.csv_dict('test.csv')

    # Task3:
    # jsonparse.unique(person_string)

    # Task4:
    print(hello())


if __name__ == '__main__':
    main()