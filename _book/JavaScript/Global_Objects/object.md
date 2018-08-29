# Object 

---
* Object 是一个构造函数，为给定值创建一个对象包装器
* 有两个属性：length、prototype
    * Object.length 值为1
    * Object.prototype 可以为所有 Object 类型的对象添加属性
* 有很多方法，如下表

## Object方法表
| 方法                                                    | 作用                                                         |
| ------------------------------------------------------- | ------------------------------------------------------------ |
| [assign()](#assign)                                     | 复制一个或多个对象来创建一个新对象                           |
| [create()](#create)                                     | 使用指定的原型对象和属性创建一个新对象                       |
| [defineProperty()](#defineProperty)                     | 给对象添加一个属性并指定该属性的配置                         |
| [defineProperties()](#defineProperties)                 | 给对象添加多个属性并分别指定它们的配置                       |
| [entries()](#entries)                                   | 返回给定对象自身可枚举属性的 [key, value] 数组               |
| [freeze()](#freeze)                                     | 冻结对象：其他代码不能删除或更改任何属性                     |
| [getOwnPropertyDescriptor()](#getOwnPropertyDescriptor) | 返回指定的属性配置                                           |
| [getOwnPropertyNames()](#getOwnPropertyNames)           | 返回一个数组，它包含了指定对象所有的可枚举或不可枚举的属性名 |
| [getOwnPorpertySymbols()](#getOwnPorpertySymbols)       | 返回一个数组，它包含了指定对象自身所有的符号属性             |
| [getPrototypeOf()](#getPrototypeOf)                     | 返回指定对象的原型对象                                       |
| [is()](#is)                                             | 比较两个值是否相同，所有的 NaN 值都相等                      |
| [isExtensible()](#isExtensible)                         | 判断对象是否可扩展                                           |
| [isFrozen()](#isFrozen)                                 | 判断对象是否已经冻结                                         |
| [isSealed()](#isSealed)                                 | 判断对象是否已经密封                                         |
| [keys()](#keys)                                         | 返回一个包含所有给定对象*自身*可枚举属性名称的数组           |
| [preventExtensions()](#preventExtensions)               | 防止对象的任何扩展                                           |
| [seal()](#seal)                                         | 防止其它代码删除对象的属性                                   |
| [setPrototypeOf()](#setPrototypeOf)                     | 设置对象的原型（即内部[[Prototype]]属性）                    |
| [values()](#values)                             | 返回给定对象自身可枚举值的数组                               |


### assign()
 * 用户将所有可枚举属性的值从一个或多个源对象复制到目标对象，并返回目标对象
 * Object.assign(target, ...sources)

```js
const object1 = {
    a: 1,
    b: 2,
    c: 3
};

const object2 = Object.assign({c:4, d:5}, object1)
console.log(object2.c, object2.d);          // 3 5
```

[BACK TO TOC](#Object方法表)

 * assign() 为浅拷贝，拷贝的只是属性值，如果属性值为引用，也只拷贝引用,如果引用所指的值变了，那么属性值也会变化
 * 继承属性和不可枚举属性不能被拷贝

### create()

 * 创建一个新对象，使用现有的对象来提供新创建的对象的 __proto__
 * Object(proto, [propertiesObject])

```js
const person = {
  isHuman: false,
  printIntroduction: function () {
    console.log(`My name is ${this.name}. Am I human? ${this.isHuman}`);
  }
};

const me = Object.create(person);

me.name = "Matthew"; // "name" is a property set on "me", but not on "person"
me.isHuman = true; // inherited properties can be overwritten

me.printIntroduction();
// expected output: "My name is Matthew. Am I human? true"
```

[BACK TO TOC](#Object方法表)

### defineProperty()

 * 在一个对象上定义新的属性或修改现有属性，并返回该对象
 * Object.defineProperty(obj, props)

```js
let obj = {}

Object.definePorperties(obj, {
    'property1': {
        value: true,
        writable: true
    },
    'property2': {
        value: 'hello',
        writable: true
    }
});
```

[BACK TO TOC](#Object方法表)

### defineProperties()
 * 直接在一个对象上定义一个新属性，或者修改一个对象的现有属性，返回对象
 * Object.defineProperty(obj, prop, descriptor)

```js
let obj = {
    key: 'kk'
}

Object.defineProperty(obj, 'key', {
    enumerable: false,
    ...
})
```

[BACK TO TOC](#Object方法表)

### entries()

 * 返回一个给定对象自身可枚举属性的键值对数组，不包含原型链中的属性
 * for...in 返回原型链中的属性，返回顺序与 entries() 相同
 * Object.entried(obj)

```js
const obj = { 
    foo: 'bar',
    baz: 11
}

console.log(Object.entries(obj))
```

[BACK TO TOC](#Object方法表)

### freeze()
 
 * 冻结对象，不能向对象添加、修改、删除属性及其属性的可枚举、可配值、可写性
 * Object.freeze(obj)

```js
const obj = {
    foo: 'baz'
}

const obj1 = Object.freeze(obj);
obj1.bar = 33;  //throw error in strict mode
```

[BACK TO TOC](#Object方法表)

### getOwnPropertyDescriptor()

 * 返回指定对象上一个自有属性对象的属性描述符
 * Object.getOwnPropertyDescriptor(obj, prop)

```js
let o, d;

o = { get foo() { return 17; } };
d = Object.getOwnPropertyDescriptor(o, "foo");
// d {
//   configurable: true,
//   enumerable: true,
//   get: /*the getter function*/,
//   set: undefined
// }
```

[BACK TO TOC](#Object方法表)

### getOwnPropertyNames()

 * 返回一个由指定对象的所有自身属性的属性名组成的数组
 * Object.getOwnPropertyNames(obj)

```js
var arr = ["a", "b", "c"];
console.log(Object.getOwnPropertyNames(arr).sort()); // ["0", "1", "2", "length"]

// 类数组对象
var obj = { 0: "a", 1: "b", 2: "c"};
console.log(Object.getOwnPropertyNames(obj).sort()); // ["0", "1", "2"]
```
[BACK TO TOC](#Object方法表)

### getOwnPorpertySymbols()

 * 获取对象所有自身属性的描述符
 * Object.getOwnPropertyDescriptors(obj)

[BACK TO TOC](#Object方法表)

### getPrototypeOf()

 * 返回指定对象的原型（内部[[Prototype]]属性的值）
 * Object.getProtorypeOf(object)

```js
const prototype1 = {
    foo: 'bar'
}

const object1 = Object.create(prototype1)
console.log(Object.getPrototypeOf(object1))     // {foo:'bar'}
```

[BACK TO TOC](#Object方法表)

### is()

 * 判断两个值是否相同
 * Object.is(value1, value2)

```js
Object.is('foo', 'foo');     // true
Object.is(window, window);   // true

Object.is('foo', 'bar');     // false
Object.is([], []);           // false
```

[BACK TO TOC](#Object方法表)

### isExtensible()

 * 判断一个对象是否式可扩展的（即能否添加新属性）
 * Object.isExtensible(obj)

[BACK TO TOC](#Object方法表)

### isFrozen()

 * 判断一个对象是否被冻结
 * Object.isFrozen(obj)

[BACK TO TOC](#Object方法表)

### isSealed()

 * 判断一个对象是否被密封
 * Object.isSealed(obj)
 * 密封：指不可扩展，不能删除，不能修改已有属性的可枚举性、可配置性、可写性，但可以修改已有属性值的对象

[BACK TO TOC](#Object方法表)

### keys()
 
 * 返回一个由一个给定对象的自身可枚举属性组成的数组
 * Object.keys(obj)

```js
// simple array
var arr = ['a', 'b', 'c'];
console.log(Object.keys(arr)); // console: ['0', '1', '2']

// array like object
var obj = { 0: 'a', 1: 'b', 2: 'c' };
console.log(Object.keys(obj)); // console: ['0', '1', '2']

// array like object with random key ordering
var anObj = { 100: 'a', 2: 'b', 7: 'c' };
console.log(Object.keys(anObj)); // console: ['2', '7', '100'], key值随机
```

[BACK TO TOC](#Object方法表)

### preventExtensions()
 
 * 让一个对象变的不可扩展，不能再添加新的属性
 * Object.preventExtensions(obj)

[BACK TO TOC](#Object方法表)

### seal()

 * 封闭对象
 * Object.seal(obj)

[BACK TO TOC](#Object方法表)

### setPrototypeOf()
 * 设置一个指定对象的原型（即，内部[[Prototype]]属性）到另一个对象或null

[BACK TO TOC](#Object方法表)

### values()

 * 返回一个给定对象自己的所有可枚举属性值的数组
 * Object.values()

```js
var obj = { foo: 'bar', baz: 42 };
console.log(Object.values(obj)); // ['bar', 42]

// array like object
var obj = { 0: 'a', 1: 'b', 2: 'c' };
console.log(Object.values(obj)); // ['a', 'b', 'c']
```

[BACK TO TOC](#Object方法表)

