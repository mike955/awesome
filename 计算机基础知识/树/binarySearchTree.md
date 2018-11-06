## binary search tree

二进制搜索树有时被称为有序或排序的二叉树，它以排序的顺序保存其值，因此查找和其他操作可以使用二进制搜索的原则。

二叉搜索树有一个重要特征：节点值大于左节点的值，小于右节点的值，即: left_child < value < rigth_child。

定义一个二叉搜索树:
```python
class BinarySearchTree:
    def __init__(self, value):
        self.value = value
        self.left_child = None
        self.right_child = None

    def insert_node(self, value);
        if value <= self.left and self.left_child:
            self.left_child.insert_node(value)
        elif value <= self.value:
            self.left_child = BinarySearchTree(value)
        elif value > self.value and self.right_child:
            self.right_child.insert_node(value)
        else:
            self.right_child = BinarySearchTree(value)

    def find(self, value):
        if value < self.value and self.left_child:
            return self.left_child.find_node(value)
        if value > self.value and self.right_child:
            return self.right_child.find_node(value)

        return value == self.value
```