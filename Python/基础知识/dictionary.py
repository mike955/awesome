def p(arg):
    print(arg)

# 字典类似于 js 中的对象类型，存储键值对
dict = {'a': 1, 'b': 2, 'b': '3'}       # 值可以是任何类型
dict = {'Alice': '2341', 'Beth': '9102', 'Cecil': '3258'}

len(dict)
str(dict)
type(dict)

dict.clear()        # 清空字典内所有元素
dict.copy()         # 返回字典的浅复制
dict.get()          # 返回追定键的值
dict.has_key()      # 判断字典里是否有某个值
dict.items()        # 返回可遍历的(键，值)元组数组
dict.keys()         # 以列表返回一个字典所有的键
dict.values()       # 以列表返回一个字典所有的键
dict.pop(1992)      # 删除字典中某个值