# Set

---
 * 新的数据结构，类似于数组，所有成员值唯一
 * Set 本身是一个构造函数，用来生成 Set 数据结构
 * 可以存储原始值或者是对象引用
 * 可以用来实现集合操作

## 属性

 * length：值为 0

## 实例属性

 * Size.prototype.constructor：返回实例的构造函数，默认为 Set
 * Size.prototype.size：返回实例值的个数

## 方法

| 实例方法                                     | 含义                                                                      |
| -------------------------------------------- | ------------------------------------------------------------------------- |
| Set.prototype.add(value)                     | Set 对象尾部添加一个元素                                                  |
| Set.prototype.clear()                        | 移除 Set 对象内多有元素                                                   |
| Set.prototype.delete(value)                  | 移除 Set 中的某个值                                                       |
| Set.prototype.entries()                      | 返回一个新的迭代器对象,该对象包含Set对象中的按插入顺序排列的所有元素的值的[value, value]数组。为了使这个方法和Map对象保持相似， 每个值的键和值相等                                                  |
| Set.prototype.forEach(callbackFn[, thisArg]) | 按照插入顺序对每个对象调用 callbackFn                                     |
| Set.prototype.has(val)                       | 判断 Set 是否有某个值                                                     |
| Set.prototype.keys()                         | 返回一个新的迭代器对象, 该对象包含Set对象中的按插入顺序排列的所有元素的键                             |
| Set.prototype.values()                       | 返回一个新的迭代器对象，该对象包含Set对象中的按插入顺序排列的所有元素的值 |
| Set.prototype.[@@iterator]()                 | 返回一个新的迭代器对象，该对象包含Set对象中的按插入顺序排列的所有元素的值 |



```js
const set = new Set([1, 2, 3, 4, 4, 5]);
console.log(...set)
// 1 2 3 4 5


let mySet = new Set();

mySet.add(1); // Set(1) {1}
mySet.add(5); // Set(2) {1, 5}
mySet.add(5); // Set { 1, 5 }
mySet.add("some text"); // Set(3) {1, 5, "some text"}
var o = {a: 1, b: 2};
mySet.add(o);

mySet.add({a: 1, b: 2}); // o 指向的是不同的对象，所以没问题

mySet.has(1); // true
mySet.has(3); // false
mySet.has(5);              // true
mySet.has(Math.sqrt(25));  // true
mySet.has("Some Text".toLowerCase()); // true
mySet.has(o); // true

mySet.size; // 5

mySet.delete(5);  // true,  从set中移除5
mySet.has(5);     // false, 5已经被移除

mySet.size; // 4, 刚刚移除一个值
console.log(mySet); // Set {1, "some text", Object {a: 1, b: 2}, Object {a: 1, b: 2}}

console.log(mySet.entries())    /**
                                 SetIterator {
                                        [ 1, 1 ],
                                        [ 'some text', 'some text' ],
                                        [ { a: 1, b: 2 }, { a: 1, b: 2 } ],
                                        [ { a: 1, b: 2 }, { a: 1, b: 2 } ] }
```