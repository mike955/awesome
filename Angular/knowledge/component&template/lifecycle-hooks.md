# 生命周期钩子

---

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

- [生命周期钩子](#%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E9%92%A9%E5%AD%90)
    - [组件生命周期钩子概览](#%E7%BB%84%E4%BB%B6%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E9%92%A9%E5%AD%90%E6%A6%82%E8%A7%88)
    - [生命周期的顺序](#%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E7%9A%84%E9%A1%BA%E5%BA%8F)
    - [接口时可选的（严格来说）](#%E6%8E%A5%E5%8F%A3%E6%97%B6%E5%8F%AF%E9%80%89%E7%9A%84%EF%BC%88%E4%B8%A5%E6%A0%BC%E6%9D%A5%E8%AF%B4%EF%BC%89)
    - [其它生命周期钩子](#%E5%85%B6%E5%AE%83%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E9%92%A9%E5%AD%90)
    - [生命周期范例](#%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E8%8C%83%E4%BE%8B)
    - [Peek-a-boo:全部钩子](#peek-a-boo%E5%85%A8%E9%83%A8%E9%92%A9%E5%AD%90)
    - [OnInit() 和 OnDestory 钩子](#oninit-%E5%92%8C-ondestory-%E9%92%A9%E5%AD%90)
        - [OnInit() 钩子](#oninit-%E9%92%A9%E5%AD%90)
        - [OnDestory() 钩子](#ondestory-%E9%92%A9%E5%AD%90)
    - [OnChanges() 钩子](#onchanges-%E9%92%A9%E5%AD%90)
    - [DoCheck() 钩子](#docheck-%E9%92%A9%E5%AD%90)
    - [AfterView 钩子](#afterview-%E9%92%A9%E5%AD%90)
    - [AfterContent 钩子](#aftercontent-%E9%92%A9%E5%AD%90)
  <!-- code_chunk_output -->

## 组件生命周期钩子概览

- 指令和组件的实例有一个生命周期：新建、更新、销毁
- 通过实现一个或多个 Angular core 库里定义的生命周期钩子接口，开发者可以介入该生命周期中的这些关键时刻
- 每个接口都有唯一的一个钩子方法，它们的名字是由接口名再加上 ng 前缀构成的
- 只有在指令/组件中定义过的钩子方法才会被 Angualr 调用

```ts
// OnInit 接口的钩子方法叫做 ngOnInit， Angular 在创建组件后立刻调用它
export class PeekABoo implements OnInit {
  constructor(private logger: LoggerService) {}

  // implement OnInit's `ngOnInit` method
  ngOnInit() {
    this.logIt(`OnInit`);
  }

  logIt(msg: string) {
    this.logger.log(`#${nextId++} ${msg}`);
  }
}
```

## 生命周期的顺序

- 当 Angualr 使用构造函数新建一个组件或指令后，会按顺序在特定时刻调用生命周期钩子方法

| 钩子                    | 用途及时机                                                                                                                                                                     |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ngOnchanges()           | 当 Angular（重新）设置数据绑定输入属性时响应。 该方法接受当前和上一属性值的 SimpleChanges 对象 <br> 当被绑定的输入属性的值发生变化时调用，首次调用一定会发生在 ngOnInit() 之前 |
| ngOnInit()              | 在 Angular 第一次显示数据绑定和设置指令/组件的输入属性之后，初始化指令/组件 <br>在第一轮 ngOnChanges() 完成之后调用，只调用一次                                                |
| ngDoCheck()             | 检测，并在发生 Angular 无法或不愿意自己检测的变化时作出反应 <br> 在每个 Angular 变更检测周期中调用                                                                             |
| ngAfterContentInit()    | 当把内容投影进组件之后调用 <br> 第一次 ngDoCheck() 之后调用，只调用一次                                                                                                        |
| ngAfterContentChecked() | 每次完成被投影组件内容的变更检测之后调用 <br> ngAfterContentInit() 和每次 ngDoCheck() 之后调用                                                                                 |
| ngAfterViewInit()       | 初始化完组件视图及其子视图之后调用 <br> 第一次 ngAfterContentChecked() 之后调用，只调用一次                                                                                    |
| ngAfterViewChecked()    | 每次做完组件视图和子视图的变更检测之后调用 <br> ngAfterViewInit() 和每次 ngAfterContentChecked() 之后调用                                                                      |
| ngOnDestory()           | 当 Angular 每次销毁指令/组件之前调用并清扫。 在这儿反订阅可观察对象和分离事件处理器，以防内存泄漏 <br> 在 Angular 销毁指令/组件之前调用                                        |

## 接口时可选的（严格来说）

 * 生命周期钩子接口函数时可选的，只有定义了才会执行

## 其它生命周期钩子
 
 * Angular 子系统可以有子集的生命周期钩子
 * 第三方库也可以有子集的钩子

## 生命周期范例

## Peek-a-boo:全部钩子

## OnInit() 和 OnDestory 钩子

### OnInit() 钩子

 * 执行 OnInit() 时，属性已经被正常赋值

### OnDestory() 钩子

 * 在组件消失之前调用

## OnChanges() 钩子

 * 检测到组件(或指令)的输入属性发生了变化，会执行

## DoCheck() 钩子

 * 检测 Angular 自身无法捕获的变更并采取行动

## AfterView 钩子

 * 在每次创建了子组建的子视图后调用

## AfterContent 钩子

 * 在外来内容被投影到组件中之后调用它们
