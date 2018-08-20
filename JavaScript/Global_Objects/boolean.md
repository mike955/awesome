# Boolean

---
* 是一个布尔值的对象包装器
* length属性的值为 1
* new Boolean([value])

```js
var x = new Boolean(false);

// 当 Boolean 对象用于条件语句的时候（译注：意为直接应用于条件语句），任何不是 undefined 和 null 的对象，包括值为 false 的 Boolean 对象，都会被当做 true 来对待
if (x) {
  // 这里的代码会被执行
}
```