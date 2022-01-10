wordlist = ['cat','dog','rabbit']
letterlist = []
[letterlist.append(letter) for word in wordlist for letter in word if letter not in letterlist]
print(letterlist)