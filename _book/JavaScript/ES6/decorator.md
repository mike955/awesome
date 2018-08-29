# Decorator

---
 * 修饰器，用于修改类的行为
 * 本质是一个函数
 * 不修改类原有接口

### 1.类的修饰

```js
@testable
class TestClass {

}

function testable(target) {
    target.isTest = true;
}

TestClass.isTest //true
```
*上面代码中，@testable是一个修饰器，修改了 TestClass 类的行为，给它加上了静态属性 isTest， testable 函数的参数 target 是 TestClass 类本身*

```js
@decorator
class A {}

// 等同于

class A {}
A = decorator(A) || A;
```
*类的修饰等价于上面这样*

```js
// mixins.js
export function mixins(...list) {
  return function (target) {
    Object.assign(target.prototype, ...list)
  }
}

// main.js
import { mixins } from './mixins'

const Foo = {
  foo() { console.log('foo') }
};

@mixins(Foo)
class MyClass {}

let obj = new MyClass();
obj.foo() // 'foo'
```
*通过修饰器 mixins， 把 Foo 对象的方法添加到 MyClass 实例上*

### 2.方法的修饰

