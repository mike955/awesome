# Null

 * null 特指对象的值为设置，是 js 的基本类型
 * null 是一个字面量，而 undefined 是全局对象的一个属性
 * null 指示变量未指向任何对象
 * 使用一个未定义的变量，则该变量值为 null
 * 使用一个已定义，但未赋值的变量，则变量值为 undefined

```js
foo 
"ReferenceError: foo is not defined"
```

```js
typeof null        // "object" (因为一些以前的原因而不是'null')
typeof undefined   // "undefined"
null === undefined // false
null  == undefined // true
undefined == undefined //true
undefined === undefined //true
null === null // true
null == null // true
!null //true
isNaN(1 + null) // false
isNaN(1 + undefined) // trueS
```