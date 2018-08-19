# parseInt

* 全局函数
* 解析字符串，返回一个指定基数的整数，基数默认为10，解析错误返回 NaN
* parseInt()

```js
parseInt('0xF', 16)         // 15
parseInt('F', 16)           // 15
parseInt('17', 8)           // 15
parseInt('015', 10)         // 15
parseInt('15 * 3', 10)      // 15
    // parseInt('15 * 3', 10) = parseInt('15', 10) * parseInt('3', 10)
parseInt('')

parseInt('0x5', 10)         // 0,字符串参数与基数不匹配，返回0
parseInt('0x5', 16)         // 5
```