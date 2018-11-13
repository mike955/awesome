# 基础类型

```ts
let isDone:boolean = false;                 // boolean    

let decLiteral:number = 6;                  // number, 十进制
let hexLiteral:number = 0xf0d;              // number，十六进制
let binaryLiteral:number = 0b1010;          // number，二进制
let octalLiteral:number = 0ox744;           // number，八进制

let name:string = 'red';                     // string
let color:string = `${red} is beauty`;       // string

let list1: number[] = [1, 2, 3];            // Array
let list2: Array<string> = ['str', 'str1']; // Array，使用 数组泛型 定义
let list:number[] = [12, 'ds']              // 报错，不能将 string 类型值赋给 number 类型数组

// tuple，元组(实际上是一个数组)允许表示一个已知元素数量和类型的 数组，各元素的类型不必相同，比如，可以定义一对值，分别为 string 和 number
let x:[string, number];                     // tuple
x = ['string', 10];                         // ok
x = ['string', 'string'];                   // error
x[3] = 'world';                             // 元组数量超过定义时的数量时，越界元素可以为元组中定义类型的任何类型
x[5] = true;                                // 报错，因为 x 中类型只能为 string  或 number

// 下面一段代码编译后运行，输出：
let x:[string, number] = ['string', 10];    
console.log(x);                             // [ 'string', 10 ]
console.log(x instanceof Array)             // true
console.log(x[0]);                          // string
console.log(x[1]);                          // 10
// 上面代码运行后输出结果表明 元组 实际上是一个数组


enum Color {red, green, blue}               // enum
let c:Color = Color.green
let g:Color = Color[0]                      // 下表默认从 0 开始，也可以在声明枚举时定义

let foo:any                                 // any,在变量生命周期中，变量可更改为任何类型

function wan(): void{                       // void 表示没有任何类型，用在函数声明中，表示函数没有返回值

}

// undefined 和 null 是所有类型的子类型，可以把这两个值赋值给所有的类型
let u:undefined = undefined;                // undefined
let n:null = null;                          // null

// object 表示非原始类型（number、string、boolean、symbol、null、undefined），

// 类型断言相当于类型转换，不进行数据检查，只在编译阶段起作用
let some:any = 'i am a string';
let strLength1:number = (<string>some).length    // 将 any 类型转换为 number
let strLength2:number = (some as string).length    // 将 any 类型转换为 number
```