# Javascript深入理解之this
this取决与函数的调用位置，而不是定义的位置，这点很重要

#### 1.判断函数是否在new中调用，如果是，this绑定的是新创建的对象
```
function foo(something) {
	this.a = something;
}

var baz = new foo(3);
console.log(typeof baz);  	// => object
console.log(baz);			// => {'a':3}
console.log(baz.a);  		// => 3
```
上例中：对于baz来说，this只想的是baz本生

#### 2.函数是否通过call、apply(显示绑定)或者是硬绑定调用？如果是的话，this绑定的是指定的对象
```
// 显示绑定--call()
function foo() {
	return this;
}

var obj = {a: 2};

var baz = foo.call(obj); 
console.log(typeof baz);  	// => object
console.log(baz);			// => {'a': 2}
console.log(baz.a);  		// => 2

```
上例中：通过call(..), 我们可以在调用foo时强制把它的this绑定到obj上
```
// 硬绑定--bind()
function foo(something) {
	console.log(something);
	return this;
}

var obj = {a: 2};

var baz = foo.bind(obj);   	// baz为一个新的函数 [Function: bound foo]
var bar = baz(4);
console.log(bar);			// => {'a': 2}


// 函数baz为
function baz(something)　{
	console.log(something);
	return {'a': 2};
}
```
上例中：bind(..)会返回一个硬编码的函数，它会把参数设置为this的上下文，并且调用原始的函数
```
// API里调用的上下文
function foo(el) {
	console.log(el, this.id);
}

var obj = {
	id: "awe";
}

[1, 2, 3].forEach( foo, obj);  //此处的foo里面的this指向的是obj
// => 1 awe  2 awe  3 awe
```
上例中：javascript和宿主环境中的一些内置函数，都提供了可选的参数，通常被称为上下午，其作用和bind一样，确保你的回掉函数使用指定的this

#### 3.函数是否在某个上下文对象中调用(隐士绑定)？如果是的话，this绑定的是指定的对象
```
// 隐式绑定
function foo() {
	return this.a;
}

var obj = {
	a: 2,
	foo: foo
}

obj.foo();  // => 2
```
上例中，当函数被当作某个对象的方法调用时，this指向那个对象
```
// 隐士丢失
function foo() {
	console.log(this.a);
}

var obj = {
	a: 2,
	foo: foo
}

var bar = obj.foo;
var a = 'oop';
bar();  	// => 'oop'
```
上例中：bar是obj.foo的一个引用，引用的是函数本身，因此此时的bar是一个不带任何修饰的函数，应该实用默认绑定，此时，非严格模式下this指向全局global/window， 严格模式下为undefined**
#### 4.如果前三种情况都不是的话，则为默认绑定，严格模式下，绑定到undefined，非严格模式下指向全局对象
```
function foo() {
	console.log(this.a);
}

var a = 2;
foo();  	// => 2
```
 上例中：非严格模式下this指向全局global/window， 严格模式下为undefined

#### 5.this绑定优先级
new > 硬绑定 > 隐式绑定

#### 6.绑定例外
1.箭头函数根据外层作用域来决定this，即箭头函数会继承外层函数调用的this绑定，且箭头函数的绑定无法被修改
2.把null或undefined作为this的绑定对象传入call、apply、bind，这些值调用时会被忽略，实际应用的是默认绑定