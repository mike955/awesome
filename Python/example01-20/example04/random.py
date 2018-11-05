"""
知识点:

    * 产生随机数
        random.random() 随机产生一个(0,1)范围内的随机数
        random.randint() 随机产生一个(0,1)范围内的随机数
"""
import random

def p(arg):
    print(arg)

p(type(random))
# p(random.randint(1,10) )        # 产生 1 到 10 的一个整数型随机数  
# p(random.random() )             # 产生 0 到 1 之间的随机浮点数
# p(random.uniform(1.1,5.4) )     # 产生  1.1 到 5.4 之间的随机浮点数，区间可以不是整数
# p(random.choice('tomorrow') )   # 从序列中随机选取一个元素
# p(random.randrange(1,100,2) )   # 生成从1到100的间隔为2的随机整数

# a=[1,3,5,6,7]                # 将序列a中的元素顺序打乱
# random.shuffle(a)
# p()