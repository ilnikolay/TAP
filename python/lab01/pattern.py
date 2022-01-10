n = 5 #number of max stars
for i in range(1,2*n):
    if i <= n:
        string = '* ' * i
        print(string.rstrip())
    else:
        string = '* ' * ((2*n)-i)
        print(string.rstrip())