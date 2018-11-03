"""
code one section
计算

知识点:
    * input 函数表示读取输入流
    * float 将整型和字符串装欢为浮点数
    * % 标记转换说明符的开始
    * . 后面跟精度
"""
import math

################ 运算   ###############################
f = float(input('请输入内容: '))
c = (f - 32) / 1.8
print('%.1f华氏度 = %.1f摄氏度' % (f, c))

radius = float(input('请输入半径: '))
perimeter = 2 * math.pi * radius
area = math.pi * radius * radius
print('周长: %.2f' % perimeter)
print('面积: %.2f' % area)
print('周长: %.2f 面积 %.2f' % (perimeter, area))

year = int(input('请输入年份: '))
is_leap = (year % 4 == 0 and year % 100 != 0 or year % 400 == 0)
print(is_leap)

