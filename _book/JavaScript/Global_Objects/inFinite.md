# isFinite

* 全局函数
* 判断传入的参数是否为一个有限数值，返回 true 或 false
* 可能会进行隐式转换

```js
isFinite(NaN)       // false
isFinite(0)         // true
isFinite('0')       // true
isFinite(2e64)      // true

Number.isFinite('0')    //false
Number.isFinite(2e64)   false
```