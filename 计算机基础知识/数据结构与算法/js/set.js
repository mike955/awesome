/** 数据结构 -- 集合
 *  1. 项无序且唯一
 */

function con(param) {
    console.log(param);
}

class Set {
    constructor() {
        this.itmes = {};
    }

    add(value) { // 添加项
        if (this.has(value)) {
            return false;
        }
        this.itmes[value] = value;
        return true;
    }

    remove(value) { // 删除指定项
        if (this.has(value)) {
            delete this.itmes[value];
            return true;
        }
        return false
    }

    has(value) { // 是否有某项
        return value in this.itmes;
    }

    clear() { // 清除集合
        this.itmes = {};
    }

    size() { // 集合大小
        return Object.keys(this.itmes).length;
    }

    values() { // 返回集合中所有值
        return Object.keys(this.itmes);
    }

    union(set) {   // 并集, 返回新集合
        let new_set = this.itmes;
        for(key in set){
            if(!(key in new_set)){
                new_set[key] = key;
            }
        }
        return new_set;
    }

    intersection(set){  // 交集
        let new_set = {};
        for(key in set){
            if((key in new_set)){
                new_set[key] = key;
            }
        }
        return new_set;
    }

    difference(set) {   // 差集
        let new_set = this.itmes;
        for(key in set){
            key in new_set ? delete new_set[key] : "";
        }
        return new_set;
    }

    subset(set) {   // 子集: 判断当前集合是否是 set 的子集
        if(this.size() > set.size()){
            return false;
        }else{
            for(key in this.itmes){
                if(!set.has(key)){
                    return false;
                }
            }
            return true;
        }
    }
}

let set = new Set();
set.add(1);
con(set.values());
con(set.has(1));
con(set.size());

set.add(2);
con(set.values());
con(set.has(2));
con(set.size());

set.remove(1);
con(set.size());
set.remove(2);
con(set.values());
