"""
1. Write a Python program that reads a CSV file and remove initial spaces, quotes around each entry and the delimiter.
/Users/nikolayninov/Work/TAP/python/lab04/task01/biostats.csv
"""
import csv
def parser(file):
    with open(file, newline='') as f:
        reader = csv.reader(f, quoting=csv.QUOTE_ALL, skipinitialspace=True)
        for row in reader:
            print(row)