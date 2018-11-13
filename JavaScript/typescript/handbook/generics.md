# 范型
范型是指再定义函数、接口或类的时候，不预先指定具体的类型，而是在使用的时候再指定类型的特性。

```ts
// 创建一个范型函数，T 用于捕获用户传入的类型，然后设置函数的参数和返回参数为 T
function identity<T>(arg:T):T {
    return arg;
}

let output = identity<string>('string');        // 使用范型函数时，执行类型
let output = identity('string');                // 让编译器推断类型

// T 只用于捕获数据类型，我们还可以向下面一样使用
function foo<T>(arg:T[]):T {
    return arg;
}

```
范型类
```ts
class GenericNumber<T> {
    zeroValue: T;
    add:(x: T) => T;
}
ler myGeneric = new GenericNumber<number>();
```

范型约束
```ts
interface Leng{
    length: number;
}

function logging<T extends Leng>(arg: T):T {
    return 
}
```