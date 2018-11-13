# 其它相关知识

# ts 中 String 和 string 区别
 - String 是 JavaScript String 类型，可用于创建新字符串，但是一般没有人这么做，因为在 JavaScript 中使用字面量创建字符串被认为是最好的方式。
 - string 是 typescript 字符串类型，用于设置或声明变量类型

```js
// 下面两种生命字符串的结果一样
let str1 = new String('I am a string');
let str2 = 'I am a string';
```
```ts
// ts 中下面三种方式声明一个字符串的结果是一样
let str1:string = 'I am a string';
let ste2:string = String('I am a string');
let str3:String = new String('I am a string');
```

# public、private、protected区别
 - public: 表示变量能够在任何地方被访问 
 - private: 表示变量只能在它声明的类内访问
 - protected: 表示变量只能在其声明的类和派生类中访问