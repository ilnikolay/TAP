def salary_change(new_salary, employee, db):
    for empl in db.values():
        if empl['name'] == employee:
            empl['salary'] = new_salary

sample_dict = {
    'emp1': {'name': 'Jhon', 'salary': 7500},
    'emp2': {'name': 'Emma', 'salary': 8000},
    'emp3': {'name': 'Brad', 'salary': 500}
}

# Option 1:
sample_dict['emp3']['salary'] = 8500

print(sample_dict)

# Option 2:
for employee in sample_dict.values():
    if employee['name'] == 'Brad':
        employee['salary'] = 8500
        
print(sample_dict)

# Option 3 with function:
salary_change(50,'Emma',sample_dict)

print(sample_dict)