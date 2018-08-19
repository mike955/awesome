# eval()

 * eval() 是全局对象的一个函数属性
 * eval 函数会将传入的  *字符串* 当作 js 代码进行执行，返回代码制定代码执行之后的值，如果返回值为空，则返回 undefined
 * 如果 eval() 的参数不是字符串，则原封不动返回参数
 * 如果间接使用 eval()，则其工作在全局作用域下，不能使用本地作用域
 * eval() 必须调用 js 解释起，所以执行较慢

```js
eval("2 + 2")   // 4
eval(new String("2 + 2"))   // "2 + 2"，因为 eval 参数不是字符串，而是对象

function test() {
    let x = 2, y = 4;
    console.log(eval("x + y"))      //6，直接调用，使用本地作用域

    let geval = eval;
    console.log(geval("x + y"))     //Throw err, 间接调用，使用全局作用域，而 x，y 在全局作用域未被定义
}
```
