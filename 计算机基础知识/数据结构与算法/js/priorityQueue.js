// 数据结构 -- 优先队列

function con(param) {
    console.log(param);
}

class PriorityQueue{
    constructor(){
        this.items = [];
    }

    QueneElement(element, priority){
        return {
            element: element,
            priority: priority
        }
    }

    enqueue(element, priority){
        let queue_element = this.QueneElement(element, priority);
        let added = false;
        for(let i = 0; i < this.items.length; i++){
            if(queue_element.priority < this.items[i].priority){
                this.items.splice(i, 0, queue_element);
                added = true;
                break;
            }
        }
        if(added == false){
            this.items.push(queue_element);
        }
    }

    print() {
        return this.items;
    }
}

let priority_queue = new PriorityQueue();
priority_queue.enqueue('John', 2);
priority_queue.enqueue('Jack', 1);
priority_queue.enqueue('Camm', 1);
con(priority_queue.print());