## binary tree

在计算机科学中，二叉树是一种树数据结构，其中每个节点最多有两个子节点，称为左子节点和右子节点。

二叉树中每个节点有三个属性：value、left_child、right_child

一个简单的二叉树实现如下:
```python
class BinaryTree:
    def __init__(self, value):
        self.value = value
        self.left_child = None
        self.right_child = None
```
实例化一个二叉树操作如下:
```python
tree = BinaryTree('a)
```

二叉树的插入和深度遍历、广度遍历、前序、后续、中续遍历见`code`文件夹下`binary.py`文件 