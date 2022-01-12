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