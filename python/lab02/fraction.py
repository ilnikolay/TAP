def gcd(m,n):
    while m%n != 0:
        oldm = m
        oldn = n

        m = oldn
        n = oldm%oldn
    return n

class Fraction:
    # TODO implement comparisom operators >, < and numerical operators *, / and -
    def __init__(self,top,bottom):
        if bottom == 0:
            raise ZeroDivisionError
        elif bottom < 0:
            bottom = abs(bottom)
            top = -top
        g = gcd(top,bottom)
        self.num = top // g
        self.den = bottom // g


    def __str__(self):
        return str(self.num)+"/"+str(self.den)

    def show(self):
        print(self.num,"/",self.den)

    def __add__(self,otherfraction):
        newnum = self.num*otherfraction.den + \
                    self.den*otherfraction.num
        newden = self.den * otherfraction.den

        return Fraction(newnum,newden)

    def __sub__(self,otherfraction):
        newnum = 0
        newden = 0
        if self == otherfraction:
            return 0
        elif self.den == otherfraction.den:
            newnum = self.num - otherfraction.num
            newden = self.den
        else:
            newnum = self.num * otherfraction.den - otherfraction.num * self.den
            newden = self.den * otherfraction.den

        return Fraction(newnum,newden)

    def __mul__(self, otherfraction):
        newnum = self.num * otherfraction.num
        newden = self.den * otherfraction.den

        return Fraction(newnum,newden)

    def __truediv__(self, otherfraction):
        newnum = self.num * otherfraction.den
        newden = self.den * otherfraction.num

        return Fraction(newnum,newden)

    def __eq__(self, other):
        firstnum = self.num * other.den
        secondnum = other.num * self.den

        return firstnum == secondnum

    def __lt__(self, otherfraction):
        firstnum = self.num / self.den
        secondnum = otherfraction.num / otherfraction.den

        return firstnum < secondnum

    def __gt__(self, otherfraction):
        firstnum = self.num / self.den
        secondnum = otherfraction.num / otherfraction.den

        return firstnum > secondnum

x = Fraction(2,7)
y = Fraction(3,8)
print(x+y)
print(x-y)
print(x*y)
print(x/y)
print(x == y)
print(x < y)
print(x > y)