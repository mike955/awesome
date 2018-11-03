"""
知识点:
    逻辑运算符
    * and 运算符表示 且
    * or 运算符表示 或
    * True 表示 真
    * Flase 表示 假
    * not 表示否定
"""
a = 5
b = 10
c = 3
d = 4
e = 5
a += b
a -= c
a *= d
a /= e
print("a = ", a)

flag1 = 3 > 2
flag2 = 2 < 1
flag3 = flag1 and flag1
flag4 = flag1 and flag2
flag5 = not flag1
print("flag1 = ", flag1)
print("flag2 = ", flag2)
print("flag3 = ", flag3)
print("flag4 = ", flag4)
print("flag5 = ", flag5)
print(flag1 is True)
print(flag2 is not False)
