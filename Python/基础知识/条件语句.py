"""
知识点:
    条件语句
"""

def p(arg):
    print(arg)

score = 90

if score >= 90:
    grade = 'A'
elif score >= 80:
    grade = 'B'
elif score >= 70:
    grade = 'C'
elif score >= 60:
    pass
else:
    grade = 'D'

p(grade)

if 90 > 80 and 90 < 100 :
    print('90 > 80 and 90 < 100')