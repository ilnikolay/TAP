class Roman():

    roman_dict = {1000:"M",900:"CM",500:"D",400:"CD",100:"C",90:"XC",50:"L",40:"XL",10:"X",9:"IX",5:"V",4:"IV",1:"I"}

    def __init__(self, int):
        self.int = int

    def __str__(self):
        roman_string = ''
        for i in self.roman_dict.keys():
            while self.int >= i:
                self.int -= i
                roman_string = roman_string + self.roman_dict[i]
        return roman_string

p = Roman(8)
print(p)