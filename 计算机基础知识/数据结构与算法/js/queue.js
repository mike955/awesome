//  数据结构 -- 队列

function con(param) {
    console.log(param);
}

class Queue {
    constructor() {
        this.items = [];
    }

    enqueue(ele) { // 入队列
        this.items.push(ele);
    }

    dequeue() { // 队列第一个元素出队列
        this.items.shift();
    }

    front() { // 返回队列中第一个元素
        return this.items[0];
    }

    isEmpty() { // 判断栈是否为空
        return this.items.length == 0;
    }

    size() { // 返回栈的长度
        return this.items.length;
    }

    print() { // 输出栈中所有元素
        return this.items;
    }
}

let queue = new Queue();
queue.enqueue("John");
queue.enqueue("Jack");
queue.enqueue("Camm11a");
con(queue.print());
con(queue.size());
con(queue.isEmpty());
queue.dequeue();
queue.dequeue();
con(queue.print());