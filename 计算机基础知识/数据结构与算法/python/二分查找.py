# 二分查找

import math

data_list = [1,2,3,4,5,6,7,8,9,11,234,5432]

def binary_search(list, item):
    low = 0
    high = len(data_list) - 1
    time = 0
    while low < high:
        time = time + 1
        mid =  math.floor((low + high)/2)
        if mid == item:
            return mid
        elif mid < item:
            low = mid + 1
        else:
            high = mid - 1
    
result = binary_search(data_list, 8)
print(result)
