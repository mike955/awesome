"""
知识点:
"""

def p(arg):
    print(arg)

a = 0
b = 1
for x in range(1, 10):
    a, b = (b, a+b)
    p(a)