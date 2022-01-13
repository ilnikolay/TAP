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
