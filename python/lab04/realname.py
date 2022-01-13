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