# class

继承
```ts
class Animal {
    protected name:string;
    constructor(name:string){
        this.name = name;
    }
    print() {
        console.log(this.name)
    }
}

class Dog extends Animal {
    constructor(){
        /**
         1.派生类（子类）必须在构造函数内调用 super()，它会执行基类的构造函数，并且在构造函数里访问 this 属性之前一定要调用 super()，
         2.派生类没有自己的 this，只有在构造函数内执行 super() 后才能使用基类的 this
         3.下面的 super() 必须携带一个参数，因为 super() 执行基类的构造函数，积累的构造函数有一个参数
        */
        super(name)
    }

    bark() {
        console.log(this.name)
    }
}
```

存取器
```ts
class Animal {
    protected name:string;
    constructor(name:string){
        this.name = name;
    }
    print() {
        console.log(this.name)
    }
    get name():string{
        return this.name;
    }
    set name(name:string):string{
        this.name = name;
    }
}
```

静态属性
```ts
class Animal {
    protected name:string;
    constructor(name:string){
        this.name = name;
    }
    static print() {        // 静态属性只能被类使用，不能被实例使用
        console.log(this.name)
    }
    get name():string{
        return this.name;
    }
    set name(name:string):string{
        this.name = name;
    }
}
```