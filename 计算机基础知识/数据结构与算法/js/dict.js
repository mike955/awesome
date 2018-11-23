/** 
 * 数据结构 -- 字典(映射)
 * 1.键值对存储数据
 */

function con(param) {
    console.log(param);
}

class Dictionary{
    constructor(){
        this.items = {};
    }

    set(key, val){  // 添加元素
        this.items[key] = val;
    }

    delete(key) {   // 删除元素
        if(key in this.items){
            delete this.items[key];
            return true;
        }
        return false;
    }

    has(key) {  // 是否存在元素
        return key in this.items ? true : false;
    }

    get(key) {  // 获取元素
        return this.items[key];
    }

    clear() {   // 清除字典
        this.items = {};
    }

    size() {    // 字典大小
        return Object.keys(this.items).length;
    }

    keys() {    // 数组返回字典键
        return Object.keys(this.items);
    }

    values() {  //数组返回字典值
        return Object.values(this.items);
    }

    getItems() {    // 返回字典
        return this.items;
    }
}

let dictionary = new Dictionary();
dictionary.set('Gandalf', 'gandalf@js.com');
dictionary.set('John', 'john@js.com');
dictionary.set('Tylion', 'tylion@js.com');
con(dictionary.has('Gandalf'));
con(dictionary.size());

con(dictionary.keys());
con(dictionary.values());
con(dictionary.get('Tylion'))

con(dictionary.keys());
con(dictionary.values());
con(dictionary.getItems());