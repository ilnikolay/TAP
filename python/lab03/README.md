## Task1:
```python
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
```

## Task2:
```python
import functools

class Example:
    def __init__(self):
        print('Instance Created.')
      
    # Defining __call__ method
    def __call__(self, list):
        self.num_list = list
        return functools.reduce(lambda a, b: a+b, self.num_list)

# Instance created
e = Example()
  
# __call__ method will be called
sum = e([1,2,3,4,5])
print(sum)
```

## Task 3
```python
class EuropeanSocketInterface:
    def voltage(self): pass

    def live(self): pass

    def neutral(self): pass

    def earth(self): pass


# Adaptee
class Socket(EuropeanSocketInterface):
    def voltage(self):
        return 230

    def live(self):
        return 1

    def neutral(self):
        return -1

    def earth(self):
        return 0


# Target interface
class USASocketInterface:
    def voltage(self): pass

    def live(self): pass

    def neutral(self): pass


# The Adapter
class Adapter(USASocketInterface):
    def __init__(self, adapter) -> None:
        self.adapter = adapter

    def voltage(self):
        return 110
    def live(self):
        return self.adapter.live()
    def neutral(self):
        return self.adapter.neutral()

# Client
class ElectricKettle:

    def __init__(self, power):
        self.power = power

    def boil(self):
        if self.power.voltage() > 110:
            print("Kettle on fire!")
        elif self.power.live() == 1 and self.power.neutral() == -1:
            print("Coffee time!")
        else:
            print("No power.")


def main():
    # Plug in
    socket = Socket()
    adapter = Adapter(socket)
    kettle = ElectricKettle(adapter)

    # Make coffee
    kettle.boil()

    return 0


if __name__ == "__main__":
    main()
```