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