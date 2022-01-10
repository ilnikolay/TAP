## 1. Modify wordlist.py so that:
     a) the final list only contains a single copy of each letter.
     b) use list comprehension instead simple for loops
```python
wordlist = ['cat','dog','rabbit']
letterlist = []
[letterlist.append(letter) for word in wordlist for letter in word if letter not in letterlist]
print(letterlist)
```
## 2. Write a Python program to change Brad’s salary to 8500 in brad.py.
```python
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
```
## 3. Write a program to print the following start pattern using the for loop:
*
* *
* * *
* * * *
* * * * *
* * * *
* * *
* *
*
```python
n = 5 #number of max stars
for i in range(1,2*n):
    if i <= n:
        string = '* ' * i
        print(string.rstrip())
    else:
        string = '* ' * ((2*n)-i)
        print(string.rstrip())
```
## 4. Write Python script that takes string on input, and arrange the characters of a string so that all lowercase letters should come first.
   EXAMPLE INPUT:       PyNaTive
   EXPECTED OUTPUT:     yaivePNT
```python
string = str(input('Please enter a string:'))

if string.isalpha() == False:
    print('Please enter only alphabet letters!!!!')
else:
    #Option 1:
    lower_case = [letter for letter in string if letter.islower()]
    upper_case = [letter for letter in string if letter.isupper()]
    reordered = lower_case + upper_case
    print(''.join(reordered))

    #Option 2:
    lower_string = ''
    upper_string = ''
    for char in string:
        if char.islower():
            lower_string += char
        else:
            upper_string += char
    ordered_string = lower_string + upper_string

    print(ordered_string)
```