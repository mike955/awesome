/** 数据结构 -- 散列表
 * 1. 字典的一种 hash 实现方式
 */ 

function con(param) {
    console.log(param);
}

class HashTable{
    constructor(){
        this.items = {};
    }

    loseloseHashCode(key){  // hash function
        let hash = 0;
        for(let i = 0; i < key.length; i++){
            hash += key.charCodeAt(i);
        }
        return hash % 37;
    }

    put(key, val){  // 散列表添加新的项
        this.items[this.loseloseHashCode(key)] = val;
    }

    remove(key) {   // 删除新的项
        if(this.loseloseHashCode(key) in this.items){
            delete this.items[this.loseloseHashCode(key)];
            return true;
        }else{
            return false;
        }
    }

    get(key) {
        return this.items[this.loseloseHashCode(key)];
    }

    getHashTable(){
        return this.items;
    }
}

let hash_table = new HashTable();
hash_table.put('Gandalf', 'gandalf@js.com');
hash_table.put('John', 'john@js.com');
hash_table.put('Tylion', 'tylion@js.com');
con(hash_table.getHashTable());
con(hash_table.get('Gandalf'));
con(hash_table.get('John'));