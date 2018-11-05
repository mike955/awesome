def p(arg):
    print(arg)

list1 = ['physics', 'chemistry', 1997, 2000]
list2 = [1, 2, 3, 4, 5 ]
list3 = ["a", "b", "c", "d"]

p(list1[0]) # 访问列表中的值
p(list2[1:2]) # 访问列表中的值, 左闭右开

del list1[0]            # 删除列表中元素
list1[0] * 4            # 列表内容重复四份，原列表中的内容变成了四份

max(list1)
min(lis1)
len(list1)              # 列表长度

list1.append('super')   # 列表添加元素
list1.count(1997)       # 统计某个元素在列表中出现的次数
list1.index(1997)       # 查找某个元素的索引
list1.remove(1997)      # 移除某个元素
list1.reverse()         # 元素顺序反转
list1.sort()            # 元素排序

