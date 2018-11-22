"""
知识点:

    python3 数据类型
        * 数字：int(有符号整型)、long(长整型)、float(浮点)、complex(复数)
        * 字符串
        * 列表
        * 元组
        * 字典
        * 空值 None
"""

def p(arg):
    print(arg)

p(type(100))                    # int   
p(type(1000000000000000000))    # int
p(type(12.345))                 # float
p(type(1 + 5j))                 # complex
p(type('A'))                    # str
p(type(True))                   # bool
p(type(['a', 'b']))             # list
p(type(('a', 'b')))             # tuple
p(type({'bar': 'foo'}))         # dict

######################### 类型转换 ######################### 

p(str(123))     # str
p(int('123'))   # int
p(float(123))   # float
p(str(False))   # str
p(bool(123))    # bool