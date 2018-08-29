# Function

---

 * Function是一个构造函数，用于创建一个新的 Funtion 对象
 * 属性
    * length：函数的接收参数个数
    * prototype.constructor：声明函数的原型构造方法

### Function方法表(方法均为实例方法)

| 方法          | 作用                                                                                                                                                                                                                |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [apply()](#apply)     | 在一个对象的上下文中应用另一个对象的方法                                                                                                                                                                            |
| [bind()](#bind)        | 创建一个新函数，称为绑定函数，调用这个绑定函数时，绑定函数会以创建它时传入 bind() 方法的第一个参数作为 this，传入 bind() 方法的第二个以及以后的参数加上绑定函数运行时本身的参数按照顺序作为原函数的参数来调用原函数 |
| [call()](#call)        | 在一个对象的上下文中应用另一个对象的方法，参数能够以列表形式传入                                                                                                                                                    |
| [isGenerator()](#isGenerator) | 判断函数是否为生成器函数                                                                                                                                                                                            |

### apply

 * 调用一个函数，其具有一个指定的 this 值，以及作为一个数组（或类似数组的对象）提供的参数
 * func.apply(this.Arg, [argsArray])

```js
Function.prototype.construct = function (aArgs) {
  var oNew = Object.create(this.prototype);
  this.apply(oNew, aArgs);
  return oNew;
};
```

### bind

 * 创建一个新的函数，当被调用时，将其 this 关键字设置为提供的值，在调用新函数时，在任何提供之前提供一个给定的参数序列
 * func.bind(this[, arg1[,arg2[, ...]]])

```js
this.x = 9; 
var module = {
  x: 81,
  getX: function() { return this.x; }
};

module.getX(); // 返回 81

var retrieveX = module.getX;
retrieveX(); // 返回 9, 在这种情况下，"this"指向全局作用域

// 创建一个新函数，将"this"绑定到module对象
// 新手可能会被全局的x变量和module里的属性x所迷惑
var boundGetX = retrieveX.bind(module);
boundGetX(); // 返回 81
```

### call

 * 调用一个函数，其具有一个指定的 this 值和分别地提供的参数
 * func.call(thisArgs, arg1, arg2, ...)

```js
function Product(name, price) {
  this.name = name;
  this.price = price;

  if (price < 0) {
    throw RangeError(
      'Cannot create product ' + this.name + ' with a negative price'
    );
  }
}

function Food(name, price) {
  Product.call(this, name, price);  // 继承 Product
  this.category = 'food';
}

//等同于
function Food(name, price) {
  this.name = name;
  this.price = price;
  if (price < 0) {
    throw RangeError(
      'Cannot create product ' + this.name + ' with a negative price'
    );
  }

  this.category = 'food';
}

//function Toy 同上
function Toy(name, price) {
  Product.call(this, name, price);
  this.category = 'toy';
}

var cheese = new Food('feta', 5);
var fun = new Toy('robot', 40);
```

### isGenerator

 * 判断函数是否是一个生成器
 * func.isGenerator()

```js
function f() {}
function* g() {
  yield 42;
}
console.log("f.isGenerator() = " + f.isGenerator());    // f.isGenerator() = false
console.log("g.isGenerator() = " + g.isGenerator());    // g.isGenerator() = true
```