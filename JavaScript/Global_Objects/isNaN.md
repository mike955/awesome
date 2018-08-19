# isNaN

* 全局函数
* 存在隐式转换

```js
isNaN(NaN)          // true
isNaN(undefined)    // true
isNaN({})           // false, 隐式转换为 0

isNaN(true)

isNaN('23')         // false, 隐式转换为 23
isNaN('37.,d')      // true
```