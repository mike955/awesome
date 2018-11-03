"""
知识点:

"""
def p(arg):
    print(arg)


str1 = 'hello, world!'
p(len(str1))        # 字符串长度
p(str1.title())     # 首字母答谢
p(str1.upper())     # 全部大些
p(str1.isupper())    # 判断字符串是不是大写
p(str1.startswith('hello'))    # 判断字符串是不是以 hello  开头
p(str1.endswith('hello'))      # 判断字符串是不是以 hello  开头
