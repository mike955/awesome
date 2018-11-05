"""
字符串运算符
    + 字符串连接
    * 重复字符串输出
    []  索引获取字符串中字符
    [:] 截取字符串中的一部分
    in  判断字符串所属关系
    not in
    r/R 原始字符串，
    % 字符串格式
"""

a = "Hello"
b = "Python"
 
print "a + b 输出结果：", a + b 
print "a * 2 输出结果：", a * 2 
print "a[1] 输出结果：", a[1] 
print "a[1:4] 输出结果：", a[1:4] 
 
if( "H" in a) :
    print "H 在变量 a 中" 
else :
    print "H 不在变量 a 中" 
 
if( "M" not in a) :
    print "M 不在变量 a 中" 
else :
    print "M 在变量 a 中"
 
print r'\n'
print R'\n'