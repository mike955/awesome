# JavaScript深入理解之闭包

关于闭包有不同的的定义，主要有以下三种，这三种定义的含义差不多

- 闭包是一个函数外加上该函数所创建时多建立的作用域
- 闭包是指有权访问另一个函数作用域中变量的函数
- 闭包是实现外部作用域访问内部作用域中变量的方法

闭包作用 

 - 闭包用来突破作用域链

创建闭包方式 

- 创建闭包的常见方式是在一个函数内创建另一个函数

闭包主要有四种情况 
###### 情况一
```
function AA(propertyName) {
	return function() {
		var kk = propertyName;
		return kk;
	}
}

var aa = AA();
aa(123);		// => 123
```
上例中：内部返回函数能够获取propertyName，因为内部返回函数的作用域链中包括了AA的作作用域 
##### 情况二
```
var a = 'global';
var F = function() {
	var b = 'local';
	var N = function() {
		var c = 'inner';
		return b;
	}
	return N;
}

var inner = F();
console.log(inner()); 	// => 'local'
console.log(b); 		// =>  b is not defined

```
上例中: a为全局变量，b和N为全局变量下一级目录，且b对N是可见的，a对b和N都可见，inner为全局变量，b和N对inner来说是不可见的，但是最后inner是获取到了b得值，怎么获取到的呢，就是通过闭包，此时的N就是一个闭包，将F的返回值赋值给了一个全局变量inner，因此inner可以访问F的私有空间。 

##### 情况三
```
var inner;
var F = function() {
	var b = 'local';
	var N = function() {
		return b;
	}
	inner = N;
}

F();		// 要先运行F，否则inner为undefined，因为inner没有值
console.log(inner());	// => 'local'
```
 上例中：inner为全局变量，b和N为全局变量下一级，b和N对inner来说是不可见的，即inner不是不能访问到b和N的，但是最后inner得到了b的值，为什么呢，因为在F中定义了一个新的函数N，并将N赋值给了全局变量inner，因此N升级为全局变量，N既可以访问F的私有变量，又可以访问全局变量，赋值后的inner就是一个闭包 

##### 情况四: 循环中的闭包
```
var arr = [];

function F(){
	var i;
	for(i = 0; i < 3; i++){
		arr[i] = function() {
			return i;
		}
	}
	return arr;
}

F();
console.log(arr[0]());	// => 3
console.log(arr[1]());	// => 3
console.log(arr[2]());	// => 3

/*
执行完F()后，arr为：
arr = [
	function() { return 3 },
	function() { return 3 },
	function() { return 3 }
]
 */

```
上例中：我们创建了三个闭包，它们都指向了一个共同的局部变量i，但是，闭包不会记录它们的值，记录是的对它们的引用，当F执行完之后i的值为3，当闭包函数arr[i]去寻找i时，会沿着作用域链向上逐级寻找距离最近的i，又由于循环结束后i为3，因此三个闭包函数记录的都是对同一个i的引用，都指向数字3，解决这种情况可以使用立即执行函数或者通过一个中间变量来传递i(ps:作用域链本质上是一个指向变量对象的指针列表，它只引用但不实际包含变量对象) 

##### 关于闭包注意点

 - 闭包会携带其它函数的作用域，因此会占用比较多的内存，建议必要时才使用
 
 [JavaScript作用域链理解](http://blog.csdn.net/zza000000/article/details/54098137)