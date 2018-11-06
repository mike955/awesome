# Tree data structures

---
## A tree difinition

数据结构树是一系列节点的统称，节点之间通过边连接起来，每一个节点包含一个值或一些数据，节点可能有子节点或没有子节点；

树的第一个节点被称为根结点`root`，如果根结点下面有其他的节点`node`,那么根节点也是一个父节点，连接的节点成为子节点；

所有的节点通过`边(edge)`连接，`edge`是`tree`的重要组成部分，因为它管理着节点之间的连接；

叶子节点(leave)是树最末尾的节点，它们没有子节点；

树高(height)是树的叶子节点到根节点的最长路径

节点的深度(depth)是节点到根节点的长度

## 树概念总结

 - Root is the topmost node of the tree
 - Edge is the link between two nodes
 - Child is a node that has a parent node
 - Parent is a node that has an edge to a child node
 - Leaf is a node that does not have a child node in the tree
 - Height is the length of the longest path to a leaf
 - Depth is the length of the path to its root