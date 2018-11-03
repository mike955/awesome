"""
知识点:
    类型转换：

"""

def p(arg):
    print(type(arg))

p(str(123))     # str
p(int('123'))   # int
p(float(123))   # float
p(str(False))   # str
p(bool(123))    # bool