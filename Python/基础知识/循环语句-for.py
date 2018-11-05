"""
知识点:

    * for 循环
    * range: range 函数可以创建一个证书列表，一般用在 for 循环中
        range(start, stop [, step]): start表示开始，end表示结束，step 表示步长，默认步长为 1
        range(stop): 默认从 0 开始，end表示结束，默认步长为 1
"""

def p(arg):
    print(arg)

for x in range (0, 101, 20):
    if x % 5 == 0:
        p(x)
