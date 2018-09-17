#JavaScript深入理解之强制类型转换

*在我们写代码中，常常会遇见需要进行类型转换的时候，有时是对函数参数进行类型转换，有时是对函数返回值进行类型转换，下面来聊一聊JS里面的类型转换，JS里面的类型转换分为两种，一种是显示强制类型转换，一种是隐式强制类型转换.*
```
let a = 9;

let b = a + '';		// 隐式强制类型转换
let c = String(a);	// 显示强制类型转换
```

将非字符串（数字、数组、JSON格式）转换为字符串-----toString()
```
let a = 9.99 * 10000000000 * 10000000000000000000000;

let aa = a.toString();
console.dir(aa);		// => '9.99e+32'


let b = [1, 2, 3];

let bb = b.toString();
console.dir(bb);		// => '1,2,3'


let c = {
	a: 1,
	b: 2
}

let cc = JSON.stringify(c);
console.dir(cc);		// => '{"a":1, "b":2}'
```
将非数字类转换为数字----- Number()
```
let a = '42';
let aa = Number(a);

console.dir(aa);		// =>42


Number(true);			// 1
Number(false);			// 0
Number(undefined);		// NaN
Number(null);			// 0
```
将非布尔值转换为布尔值-----Boolean()
```
Boolean(something);

当something为 undefined、null、false、+0、-0、NaN、''六个值时返回false，
其它时候返回true

```
将字符串转换为数字----  +或-
```
let c = "123";
let d = +c;
console.dir(d) 	// => 123

let a = -c;		// -会反转数值符号位
console.dir(a) 	// => -123

let e = - -c;
console.dir(e);	// => 123
```

解析数字字符串-----  parseInt()、parseFloat()
```
let a = '123fd';
let aa = parseInt(a);
console.log(aa);		// => 123

let b = '123.4fd';

let bb = parseInt(b);	
let bbb = parseFloat(b);


console.dir(bb);		// => 123
console.dir(bbb);		// => 123.4
```
其它情况
```
'123' + 5    	// => '1235'
'123' - 1		// => 122
[1,2] + 4		// => '1,24'
[1,2] - 4		// => NaN
[1] - 4			// => -3
[1,2] + [4,5]   // => '1,24,5'
```

&& 和 ||
在JavaScript语言中，&&和||返回两个操作数其中一个的值，在C和PHP中返回的是true或false
```
 42 || 'abc'	// 42
 42 && 'abc'	// 'abc'

 null || 'abc'	// 'abc'
 null && 'abc'	// null
```

 - ||和&&首先会对第一个操作数进行判断，如果不是布尔值，先进行强制类型转换为布尔值
 - 对于||，如果第一个操作数转换的布尔值为true，返回第一个操作数，否则返回第二个操作符
 - 对于&&，如果第一个操作数转换的布尔值为true，返回第二个操作数，否则返回第一个操作符


== 和 ===
对于==和===的区别，常见的解释是“==检查值是否相等，===检查值和类型是否相等”，个人感觉这个解释比较表面，但能说明==和===的区别，深层次的解释是“==允许在相等比较中进行强制类型转换，而===不允许在相等比较中进行类型转换”，在进行开发时，不建议使用==，如果需要进行比较和类型转换，建议先转换后在进行比较。