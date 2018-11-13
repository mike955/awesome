# 接口
定义一个 json 类型的数据接口，以 key/val 的形势指定，通常以大些字母开头

```ts
// 参数类型
interface Config{
    color: string,
    width?: number      // 表明 width 参数是可选的
}

function Color(config: Config){

}

let color = Color({color: 'red', width: 12})

// 函数类型
interface Func{
    (source: string): boolean
}
let mySearch:Func;
mySearch = function(source: string):boolean{
    return true;
}

```