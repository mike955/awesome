// 数据结构 -- 栈

function con(param) {
    console.log(param);
}

class Stack {
    constructor() {
        this.items = [];
    }

    push(element) { // 添加元素到栈顶
        this.items.push(element);
        return this.items;
    }

    pop() { // 移除栈顶元素
        this.items.pop();
    }

    peek() { // 返回栈顶元素
        return this.items[this.items.length - 1]
    }

    isEmpty() { // 判断栈是否为空
        return this.items.length == 0;
    }

    clear() { // 清除栈所有元素
        this.items = [];
    }

    size() { // 返回栈中元素个数
        return this.items.length;
    }

    print() {   //打印栈中所有元素
        return this.items;
    }
}

let stack = new Stack();
con(stack.isEmpty());
stack.push(5);
stack.push(8);
con(stack.peek());
con(stack.isEmpty());
con(stack.size());
con(stack.print());