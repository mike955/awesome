# Symbol

---

 * symbol 是一种基本数据类型(string、number、boolean、null、undefined、symbol)
 * Symbol() 函数会返回 symbol 类型的值，改类型具有静态属性和静态方法
 * 每个从 Symbol() 返回的值都是唯一的
 * 一个 symbol 值能作为对象属性的标识符，这是改数据类型仅有的目的
 * Symbol([description])
 * 使用 Symbol() 创建的的变量不会跨文件

```js
const symbol1 = Symbol();
const symbol2 = Symbol(42);
const symbol3 = Symbol('foo');

console.log(typeof symbol1);
// expected output: "symbol"

console.log(symbol3.toString());
// expected output: "Symbol(foo)"

console.log(Symbol('foo') === Symbol('foo'));
// expected output: false
```