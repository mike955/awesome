# Map

---
 *  Map 对象保存简直对，任何值可以用作 key, js 的 object 只能用 string 作为键值
 *  new Map([iterable])
 *  NaN 也可以作为Map对象的键

## 属性
* length：值为 0

## 实例属性

 * Map.prototype.constructor：返回实例的构造函数，默认为 Map
 * Map.prototype.size：返回实例值的个数

## 实例方法
| 实例方法                                  | 含义                                   |
| ----------------------------------------- | -------------------------------------- |
| Map.prototype.clear()                     | 移除所有键/值对                        |
| Map.prototype.delete(key)                 | 移除任何时候与键相关联的值，并返回该值 |
| Map.prototype.entries()                   | 返回一个新的 Iterator 对象             |
| Map.prototype.forEach(callbackFn[, this]) | 按插入顺序循环执行 callbackFn          |
| Map.prototype.get(key)                    | 获取键对应的值，没有返回 undefined     |
| Map.prototype.has(key)                    | 判断Map是否包含某个键,返回 true/false  |
| Map.prototype.keys()                      | 返回一个新的 Iterator 对象, 它按插入顺序包含了Map对象中每个元素的键            |
| Map.prototype.set(key, value)             | 设置Map对象中键的值，返回该Map对象,它按插入顺序包含了Map对象中每个元素的值      |
| Map.prototype.values()                    | 返回一个新的 Iterator 对象             |
| Map.prototype[@@iterator]()               | 返回一个新的Iterator对象               |


```js
let myMap = new Map();
 
let keyObj = {},
    keyFunc = function () {},
    keyString = "a string";
 
// 添加键
myMap.set(keyString, "和键'a string'关联的值");
myMap.set(keyObj, "和键keyObj关联的值");
myMap.set(keyFunc, "和键keyFunc关联的值");
 
myMap.size; // 3
 
// 读取值
myMap.get(keyString);    // "和键'a string'关联的值"
myMap.get(keyObj);       // "和键keyObj关联的值"
myMap.get(keyFunc);      // "和键keyFunc关联的值"
 
myMap.get("a string");   // "和键'a string'关联的值"
                         // 因为keyString === 'a string'
myMap.get({});           // undefined, 因为keyObj !== {}
myMap.get(function() {}) // undefined, 因为keyFunc !== function () {}

console.log(myMap.entries())
/**  MapIterator {
  [ 'a string', '和键\'a string\'关联的值' ],
  [ {}, '和键keyObj关联的值' ],
  [ [Function: keyFunc], '和键keyFunc关联的值' ] }
 */

console.log(myMap.keys())

/**
 * MapIterator { 'a string', {}, [Function: keyFunc] }
 * /
```