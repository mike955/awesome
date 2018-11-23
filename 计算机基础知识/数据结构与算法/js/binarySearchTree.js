/** 二叉搜索树(BST):
 *  1. 左侧节点 < 父节点 < 右侧节点
 */

class BinarySearchTree {
    constructor() {
        this.root = undefined;
        this.nodes = [];
    }

    newNode(key) {
        return {
            key = key,
            left = undefined,
            right = undefined
        }
    }

    minNode(node) {
        if (node == undefined) {
            return undefined;
        } else if (node.left == undefined) {
            return node;
        } else if (node.left != undefined) {
            return this.minNode(node.left)
        }
    }

    maxNode(node) {
        if (node == undefined) {
            return undefined;
        } else if (node.right == undefined) {
            return node;
        } else if (node.right != undefined) {
            return this.maxNode(node.right)
        }
    }

    insert(key) { // 树中插入新的节点
        if (this.root == undefined) {
            this.root = key;
        } else {
            this.insert(root, key);
        }
    }

    insertNode(node, key) {
        if (key < node.key) {
            if (node.left == undefined) {
                node.left = this.newNode(key);
            } else {
                this.insertNode(node.left, key);
            }
        } else if (node.right == undefined) {
            node.right = this.newNode(key);
        } else {
            this.insertNode(node.right, key);
        }
    }

    search(key) { // 搜索树中的值
        return this.searchKey(this.root, key);
    }

    searchKey(node, key){
        if(node == null){
            return false;
        }
        if(key < node.key){
            return this.searchKey(this.left, key);
        }else if (key > node.key){
            return this.searchKey(this.right, key);
        }
        return true;
    }

    mix() { // 返回树中的最小值
        return minNode(this.root);
    }

    max() { // 返回树中的最大值
        return maxNode(this.root);
    }

    remove(key) { // 移除某个键

    }

    inOrderTraverse() { // 中序遍历
        this.nodes = [];
        this.inOrderTraverseNode(this.root);
        return this.nodes;
    }

    inOrderTraverseNode(node) {
        if (node != undefined) {
            this.inOrderTraverseNode(node.left);
            this.nodes.push(node);
            this.inOrderTraverseNode(node.right);
        }
    }

    preOrderTraverse() { // 前序遍历
        this.nodes = [];
        this.preOrderTraverseNode(this.root);
        return this.nodes;
    }

    preOrderTraverseNode(node) {
        if (node != undefined) {
            this.nodes.push(node);
            this.preOrderTraverseNode(node.left);
            this.preOrderTraverseNode(node.right);
        }
    }

    postOrderTraverse() { // 后序遍历
        this.nodes = [];
        this.postOrderTraverseNode(this.root);
        return this.nodes;
    }

    postOrderTraverseNode(node) {
        if (node != undefined) {
            this.postOrderTraverseNode(node.left);
            this.postOrderTraverseNode(node.right);
            this.nodes.push(node);
        }
    }
}