# function


```ts
function foo(name:string, age?:number){ // 可选擦数

}

function bar(name:string, age=16){      // 默认参数
    
}

function vam(name:string, ...restOfName: string[]){

}
```

## 重载
根据不同的参数返回不同的数据类型，使用函数重载时，只能是最下面一个函数有内容，上面的函数都只有定义；
```ts
function pickCard(x:number):number;
function pickCard(x:string):string;
function pickCard(x):any{
    return x
}
```            