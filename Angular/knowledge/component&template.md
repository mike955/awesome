# 组件与模板

---

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- /code_chunk_output -->

- [组件与模板](#%E7%BB%84%E4%BB%B6%E4%B8%8E%E6%A8%A1%E6%9D%BF)
  - [显示数组](#%E6%98%BE%E7%A4%BA%E6%95%B0%E7%BB%84)
    - [使用插值表达式显示组件属性](#%E4%BD%BF%E7%94%A8%E6%8F%92%E5%80%BC%E8%A1%A8%E8%BE%BE%E5%BC%8F%E6%98%BE%E7%A4%BA%E7%BB%84%E4%BB%B6%E5%B1%9E%E6%80%A7)
    - [内联模版与模板文件](#%E5%86%85%E8%81%94%E6%A8%A1%E7%89%88%E4%B8%8E%E6%A8%A1%E6%9D%BF%E6%96%87%E4%BB%B6)
    - [构造函数与变量初始化](#%E6%9E%84%E9%80%A0%E5%87%BD%E6%95%B0%E4%B8%8E%E5%8F%98%E9%87%8F%E5%88%9D%E5%A7%8B%E5%8C%96)
    - [ngFor 显示数组属性](#ngfor-%E6%98%BE%E7%A4%BA%E6%95%B0%E7%BB%84%E5%B1%9E%E6%80%A7)
    - [为数据创建一个类](#%E4%B8%BA%E6%95%B0%E6%8D%AE%E5%88%9B%E5%BB%BA%E4%B8%80%E4%B8%AA%E7%B1%BB)
    - [通过 NgIf 进行条件显示](#%E9%80%9A%E8%BF%87-ngif-%E8%BF%9B%E8%A1%8C%E6%9D%A1%E4%BB%B6%E6%98%BE%E7%A4%BA)
  - [模板语法](#%E6%A8%A1%E6%9D%BF%E8%AF%AD%E6%B3%95)
    - [插值表达式](#%E6%8F%92%E5%80%BC%E8%A1%A8%E8%BE%BE%E5%BC%8F)
    - [模板表达式](#%E6%A8%A1%E6%9D%BF%E8%A1%A8%E8%BE%BE%E5%BC%8F)
      - [表达式上下文](#%E8%A1%A8%E8%BE%BE%E5%BC%8F%E4%B8%8A%E4%B8%8B%E6%96%87)
      - [表达式指南](#%E8%A1%A8%E8%BE%BE%E5%BC%8F%E6%8C%87%E5%8D%97)
    - [模板语句](#%E6%A8%A1%E6%9D%BF%E8%AF%AD%E5%8F%A5)
      - [语句上下文](#%E8%AF%AD%E5%8F%A5%E4%B8%8A%E4%B8%8B%E6%96%87)
      - [语句指南](#%E8%AF%AD%E5%8F%A5%E6%8C%87%E5%8D%97)
    - [绑定语法](#%E7%BB%91%E5%AE%9A%E8%AF%AD%E6%B3%95)
      - [HTML attribute 与 DOM property 的比较](#html-attribute-%E4%B8%8E-dom-property-%E7%9A%84%E6%AF%94%E8%BE%83)
      - [绑定目标](#%E7%BB%91%E5%AE%9A%E7%9B%AE%E6%A0%87)
    - [属性绑定](#%E5%B1%9E%E6%80%A7%E7%BB%91%E5%AE%9A)
      - [单向输入](#%E5%8D%95%E5%90%91%E8%BE%93%E5%85%A5)
      - [绑定目标](#%E7%BB%91%E5%AE%9A%E7%9B%AE%E6%A0%87)
      - [返回恰当的类型](#%E8%BF%94%E5%9B%9E%E6%81%B0%E5%BD%93%E7%9A%84%E7%B1%BB%E5%9E%8B)
      - [一次性字符串初始化](#%E4%B8%80%E6%AC%A1%E6%80%A7%E5%AD%97%E7%AC%A6%E4%B8%B2%E5%88%9D%E5%A7%8B%E5%8C%96)
      - [属性绑定与插值表达式](#%E5%B1%9E%E6%80%A7%E7%BB%91%E5%AE%9A%E4%B8%8E%E6%8F%92%E5%80%BC%E8%A1%A8%E8%BE%BE%E5%BC%8F)
      - [内容安全](#%E5%86%85%E5%AE%B9%E5%AE%89%E5%85%A8)
    - [attribute、class 和 style 绑定](#attributeclass-%E5%92%8C-style-%E7%BB%91%E5%AE%9A)
      - [attribute 绑定](#attribute-%E7%BB%91%E5%AE%9A)
      - [CSS 类绑定](#css-%E7%B1%BB%E7%BB%91%E5%AE%9A)
      - [样式绑定](#%E6%A0%B7%E5%BC%8F%E7%BB%91%E5%AE%9A)
    - [事件绑定](#%E4%BA%8B%E4%BB%B6%E7%BB%91%E5%AE%9A)
      - [目标事件](#%E7%9B%AE%E6%A0%87%E4%BA%8B%E4%BB%B6)
      - [$event 和事件处理语句](#event-%E5%92%8C%E4%BA%8B%E4%BB%B6%E5%A4%84%E7%90%86%E8%AF%AD%E5%8F%A5)
      - [使用 EventEmitter 实现自定义事件](#%E4%BD%BF%E7%94%A8-eventemitter-%E5%AE%9E%E7%8E%B0%E8%87%AA%E5%AE%9A%E4%B9%89%E4%BA%8B%E4%BB%B6)
    - [双向数据绑定](#%E5%8F%8C%E5%90%91%E6%95%B0%E6%8D%AE%E7%BB%91%E5%AE%9A)
    - [内置指令](#%E5%86%85%E7%BD%AE%E6%8C%87%E4%BB%A4)
    - [内置属性型指令](#%E5%86%85%E7%BD%AE%E5%B1%9E%E6%80%A7%E5%9E%8B%E6%8C%87%E4%BB%A4)
      - [NgClass](#ngclass)
      - [NgStyle](#ngstyle)
      - [NgModule](#ngmodule)
    - [内置结构型指令](#%E5%86%85%E7%BD%AE%E7%BB%93%E6%9E%84%E5%9E%8B%E6%8C%87%E4%BB%A4)
      - [NgIf](#ngif)
      - [NgForOf](#ngforof)
      - [模板输入变量](#%E6%A8%A1%E6%9D%BF%E8%BE%93%E5%85%A5%E5%8F%98%E9%87%8F)
      - [带索引的 *ngFor](#%E5%B8%A6%E7%B4%A2%E5%BC%95%E7%9A%84-ngfor)
      - [带 trackBy 的 *ngFor](#%E5%B8%A6-trackby-%E7%9A%84-ngfor)
      - [NgSwitch 指令](#ngswitch-%E6%8C%87%E4%BB%A4)
    - [模板引用变量（#var）](#%E6%A8%A1%E6%9D%BF%E5%BC%95%E7%94%A8%E5%8F%98%E9%87%8Fvar)
    - [输入和输出属性](#%E8%BE%93%E5%85%A5%E5%92%8C%E8%BE%93%E5%87%BA%E5%B1%9E%E6%80%A7)
      - [声明输入与输出属性](#%E5%A3%B0%E6%98%8E%E8%BE%93%E5%85%A5%E4%B8%8E%E8%BE%93%E5%87%BA%E5%B1%9E%E6%80%A7)
      - [输入还是输出](#%E8%BE%93%E5%85%A5%E8%BF%98%E6%98%AF%E8%BE%93%E5%87%BA)
      - [给输入输出起别名](#%E7%BB%99%E8%BE%93%E5%85%A5%E8%BE%93%E5%87%BA%E8%B5%B7%E5%88%AB%E5%90%8D)
    - [模板表达式](#%E6%A8%A1%E6%9D%BF%E8%A1%A8%E8%BE%BE%E5%BC%8F)
      - [管道操作符 (|)](#%E7%AE%A1%E9%81%93%E6%93%8D%E4%BD%9C%E7%AC%A6)
      - [安全导航操作符(?.)和空属性路径](#%E5%AE%89%E5%85%A8%E5%AF%BC%E8%88%AA%E6%93%8D%E4%BD%9C%E7%AC%A6%E5%92%8C%E7%A9%BA%E5%B1%9E%E6%80%A7%E8%B7%AF%E5%BE%84)
      - [非空断言操作符 (!)](#%E9%9D%9E%E7%A9%BA%E6%96%AD%E8%A8%80%E6%93%8D%E4%BD%9C%E7%AC%A6)
    - [类型转换](#%E7%B1%BB%E5%9E%8B%E8%BD%AC%E6%8D%A2)
  - [生命周期钩子](#%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E9%92%A9%E5%AD%90)
  - [组件交互](#%E7%BB%84%E4%BB%B6%E4%BA%A4%E4%BA%92)
  - [组件样式](#%E7%BB%84%E4%BB%B6%E6%A0%B7%E5%BC%8F)
  - [Angular 自定义元素](#angular-%E8%87%AA%E5%AE%9A%E4%B9%89%E5%85%83%E7%B4%A0)
  - [动态组件](#%E5%8A%A8%E6%80%81%E7%BB%84%E4%BB%B6)
  - [属性型组件指令](#%E5%B1%9E%E6%80%A7%E5%9E%8B%E7%BB%84%E4%BB%B6%E6%8C%87%E4%BB%A4)
  - [结构型指令](#%E7%BB%93%E6%9E%84%E5%9E%8B%E6%8C%87%E4%BB%A4)
  - [管道](#%E7%AE%A1%E9%81%93)
  - [动画](#%E5%8A%A8%E7%94%BB)

## 显示数组

### 使用插值表达式显示组件属性

要显示组件的属性，最简单的方式就是通过*插值表达式*（双花括号）来绑定属性名

```ts
<!-- src/app/app.component.ts -->
import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  template: `
    <h1>{{title}}</h1>
    <h2>My favorite hero is: {{myHero}}</h2>
    `
})
export class AppComponent {
  title = 'Tour of Heroes';     // title 的值会在渲染时填充到上面 @Component 的 template 中的 {{title}}
  myHero = 'Windstorm';     // myHero 的值会在渲染时填充到上面 @Component 的 template 中的 {{myHero}}
}
```

[Back to TOC](#组件与模板)

### 内联模版与模板文件

```ts
import { Component } from '@angular/core';

// 内敛模板形式
@Component({
  selector: 'app-root',
  template: `
    <h1>{{title}}</h1>
    <h2>My favorite hero is: {{myHero}}</h2>
    `
})

// 模板文件形式
<!-- templ.html -->
<h1>{{title}}</h1>
<h2>My favorite hero is: {{myHero}}</h2>

@Component({
  selector: 'app-root',
  templateUrl: 'templ.html'
})
```

[Back to TOC](#组件与模板)

### 构造函数与变量初始化

```ts
import { Component } from "@angular/core";

@Component({
  selector: "app-root",
  template: `
    <h1>{{title}}</h1>
    <h2>My favorite hero is: {{myHero}}</h2>
    `
})

// 变量初始化
export class AppComponent {
  title = "Tour of Heroes";
  myHero = "Windstorm";
}

//构造函数
export class AppCtorComponent {
  title: string;
  myHero: string;

  constructor() {
    this.title = "Tour of Heroes";
    this.myHero = "Windstorm";
  }
}
```

[Back to TOC](#组件与模板)

### ngFor 显示数组属性

_ngFor 可以为任何可迭代的(iterable)对象重复渲染条目_

```ts
import { Component } from "@angular/core";

@Component({
  selector: "app-root",
  template: `
        <h1>{{title}}</h1>
        <h2>My favorite hero is: {{myHero}}</h2>
        <p>Heroes:</p>
        <ul>
            <li *ngFor="let hero of heroes">
            {{ hero }}
            </li>
        </ul>
    `
})

// 变量初始化
export class AppComponent {
  title = "Tour of Heroes";
  heroes = ["Windstorm", "Bombasto", "Magneta", "Tornado"];
  myHero = this.heroes[0];
}
```

[Back to TOC](#组件与模板)

### 为数据创建一个类

- 在组件内部之间定义数据不是最佳实践
- 创建一个类用于定义数据结构
- _ng g class hero_ 命令创建一个名为 Hero 的类

```ts
<!-- src/app/hero.ts -->
export class Hero {
  constructor(
    public id: number,
    public name: string) { }
}

<!-- src/app/app.component.ts (heroes) -->
import { Hero } from '../hero';     // 导入 Hero 类
heroes = [                          // 类型化的 Hero 对象
  new Hero(1, 'Windstorm'),
  new Hero(13, 'Bombasto'),
  new Hero(15, 'Magneta'),
  new Hero(20, 'Tornado')
];
myHero = this.heroes[0];
```

[Back to TOC](#组件与模板)

### 通过 NgIf 进行条件显示

- 条件显示视图和视图的一部分
- ngIf 指令会根据一个布尔条件来显示或移除一个元素

```ts
// 当 heroes数组的长度大于 3 时，显示下面的 p 标签
template: `
  <p *ngIf="heroes.length > 3">There are many heroes!</p>
`;
```

[Back to TOC](#组件与模板)

## 模板语法

- Angular 应用管理者用户之所见和所为，通过 Component 类的实例（组件）和面向用户的模板来与用户交互
- Angualr 中，组件扮演着控制器或视图的角色，模板扮演视图的角色
- script 标签在 Angular 中被禁用，防止脚本注入攻击

[Back to TOC](#组件与模板)
### 插值表达式

- Angular 会先对插值表达式中的模板表达式进行求值，再转换为字符串

```ts
<p>My current hero is {{currentHero.name}}</p>      // 赋值

<p>The sum of 1 + 1 is {{1 + 1}}</p>                // he sum of 1 + 1 is 2

<p>The sum of 1 + 1 is not {{1 + 1 + getVal()}}</p> // 调用宿主件方法 The sum of 1 + 1 is not 4
```
[Back to TOC](#组件与模板)

### 模板表达式

- 模板表达式产生一个值，Angular 执行这个表达式，并把它赋值给绑定目标的属性
- {{1 + 1}} 中所包含的模板表达式是 1 + 1
- 禁止使用的模板表达式
  - =、+=、-=
  - new
  - ; 或 ,
  - ++、--
- 不支持的 | 和 &
- 具有新的模板表达式运算符，比如 _|_ 、_?_. 和 _!_

[Back to TOC](#组件与模板)

#### 表达式上下文

- 表达式上下文是各种绑定值的来源
- 表达式的上下文可以包括组件之外的对象，比如*模板输入变量*和*模板引用变量*
- 表达式中的上下文变量由模板变量、指令的上下文变量(如果有)和组件的成员叠加而成的，如果你要引用的变量名存在于一个以上的命名空间中，那么，模板变量是最优先的，其次是指令的上下文变量，最后是组件的成员

```html
<!-- 组件具有一个名叫 hero 的属性，而 *ngFor 声明了一个也叫 hero 的模板变量。 在 {{hero.name}} 表达式中的 hero 实际引用的是模板变量，而不是组件的属性 -->
<div *ngFor="let hero of heroes">{{hero.name}}</div>
<input #heroInput> {{heroInput.value}}
```

[Back to TOC](#组件与模板)

#### 表达式指南

表达式请遵循下列指南：

- 没有可见的副作用：模板表达式除了目标属性的值以外，不应该改变应用的任何状态
- 执行迅速
- 非常简单：尽量简单
- 幂等性：表达式应是幂等的，即相同的输入一定返回相同的输出

[Back to TOC](#组件与模板)

### 模板语句

- 模板语句用来响应由绑定目标（ HTML 元素、组件或指令）触发的实践，出现在 = 号右侧的引号中，类似：(event)="statement"
- 模板语句有副作用

[Back to TOC](#组件与模板)

#### 语句上下文

- 语句只能引用语句上下文中 -- 通常是正在绑定事件的那个组件实例
- 典型的语句上下文就是当前组件的实例，(click)="deleteHero()"中的 deleteHero 就是这个数据绑定组件上的一个方法
- 语句上下文可以引用模板自身上下文中的属性
- 模板上下文中的变量名的优先级高于组件上下文中的变量名

```html
<!-- 在下面的例子中，就把模板的 $event 对象、模板输入变量 (let hero)和模板引用变量 (#heroForm)传给了组件中的一个事件处理器方法 -->

<button (click)="onSave($event)">Save</button>
<button *ngFor="let hero of heroes" (click)="deleteHero(hero)">{{hero.name}}</button>
<form #heroForm (ngSubmit)="onSubmit(heroForm)"> ... </form>

<!-- 在上面的 deleteHero(hero) 中，hero 是一个模板输入变量，而不是组件中的 hero 属性 -->
```
[Back to TOC](#组件与模板)

#### 语句指南

- 避免写复杂的模板语句

[Back to TOC](#组件与模板)

### 绑定语法

- 数据绑定是一种机制，用来协调用户所见和应用数据
- Angular 的绑定类型根据数据流的方向可以分成三类：从数据源到视图、从视图到数据源、从视图到数据源再到视图(双向)

| 数据方向               | 语法                                                                    | 绑定类型                                                 |
| ---------------------- | ----------------------------------------------------------------------- | -------------------------------------------------------- |
| 从数据源到视图         | {{expression}} <br> [target]="expression" <br> bind-target="expression" | 插值表达式 <br> 属性 <br> Attribute <br> CSS类 <br> 样式 |
| 从视图到数据源         | (target)="statement" <br> on-target="statement"                         | 事件                                                     |
| 从视图到数据源再到视图 | (target)="statement" <br>   on-target="statement"                       | 双向                                                     |

[Back to TOC](#组件与模板)

#### HTML attribute 与 DOM property 的比较

#### 绑定目标

 * 数据绑定的目标是 DOM 中的某些东西。这个目标可能是（元素|组件|指令的）property、（元素|组件|指令的）事件，或（极少数情况下）attribute 名

|绑定类型|目标|范例|
|-|-|-|
|属性|元素的 property <br> 组件的property <br> 指令的property| <img [src]="heroImageUrl"> <br> <app-hero-detail [hero]="currentHero"></app-hero-detail> <br> <div [ngClass]="{'special': isSpecial}"></div>|
|事件|元素的事件 <br> 组件的事件 <br> 指令的事件|<img [src]="heroImageUrl"> <br> <app-hero-detail [hero]="currentHero"></app-hero-detail> <br> <div [ngClass]="{'special': isSpecial}"></div>|
|双向|事件与 property|<input [(ngModel)]="name">|
|Attribute| attribute（例外情况）|<button [style.color]="isSpecial ? 'red' : 'green'">|
|CSS类|class property|<button [style.color]="isSpecial ? 'red' : 'green'">|
|样式|style property|<button [style.color]="isSpecial ? 'red' : 'green'">|

[Back to TOC](#组件与模板)

### 属性绑定

 * 把元素的属性设置为组件属性的值
 * 设置指令的属性
 * 设置自定义组件的模型属性（父子组件通讯）
 * [属性名]="属性值"

```html
<!-- 把元素属性设置为组件属性的值，image 元素的 src 属性会被绑定到组件的 heroImageUrl 属性上 -->
<img [src]="heroImageUrl">

<!-- 元素属性绑定 -->
<button [disabled]="isUnchanged">Cancel is disabled</button>

<!-- 设置指令属性 -->
<div [ngClass]="classes">[ngClass] binding to the classes property</div>

<!-- 设置自定义组件的模型属性 -->
<app-hero-detail [hero]="currentHero"></app-hero-detail>
```
[Back to TOC](#组件与模板)

#### 单向输入

 * 即属性绑定，值从组件的数据属性流动到目标元素的属性
 * 不能使用属性绑定来从目标元素拉取值，不能绑定到目标元素的属性来读取它，只能设置它

[Back to TOC](#组件与模板)

#### 绑定目标

 * 包裹在防括号中的元素属性名标记着目标的属性

```html
<!-- 目标属性是 image 元素的 src 属性 , 不要忘记方括号-->
<img [src]="heroImageUrl">

<!-- 与上面的 【src] 形式等价 -->
<img bind-src="heroImageUrl">
```

[Back to TOC](#组件与模板)

#### 返回恰当的类型

 * 目标属性需要什么类型值，模板表达式就应该返回什么类型值

```html
<!-- HeroDetail 组件的 hero 属性想要一个 Hero 对象，那就在属性绑定中精确地给它一个 Hero 对象 -->
<app-hero-detail [hero]="currentHero"></app-hero-detail>
```

[Back to TOC](#组件与模板)

#### 一次性字符串初始化

 * 下列情况应省略属性名的方括号
    * 目标属性接受字符串值
    * 字符串是个固定值，可以合并到模块中
    * 这个初始值永不变

```html
<!-- 设置 prefix 初始值 -->
<app-hero-detail prefix="You are my" [hero]="currentHero"></app-hero-detail>
```

[Back to TOC](#组件与模板)

#### 属性绑定与插值表达式

```html
<!-- 下面的四段代码功能一样 -->
<!-- 在渲染视图前， Angualr 会把插值表达式翻译成想要的属性绑定 -->

<p><img src="{{heroImageUrl}}"> is the <i>interpolated</i> image.</p>
<p><img [src]="heroImageUrl"> is the <i>property bound</i> image.</p>

<p><span>"{{title}}" is the <i>interpolated</i> title.</span></p>
<p>"<span [innerHTML]="title"></span>" is the <i>property bound</i> title.</p>
```

[Back to TOC](#组件与模板)

#### 内容安全

 * Angualr 数据绑定不允许带有 script 标签的 HTML 泄漏到浏览器

[Back to TOC](#组件与模板)

### attribute、class 和 style 绑定

 * Angualr 为那些不太适合属性绑定的场景提供了专门的单向数据绑定形式

[Back to TOC](#组件与模板)

#### attribute 绑定

 * attribute 绑定的语法与属性绑定类似。 但方括号中的部分不是元素的属性名，而是由attr前缀，一个点 (.) 和 attribute 的名字组成
```html
<!-- create and set an aria attribute for assistive technology -->
<button [attr.aria-label]="actionName">{{actionName}} with Aria</button>
```
[Back to TOC](#组件与模板)

#### CSS 类绑定

 * 借助 CSS 类绑定，可以从元素的 class attribute 上添加和移除 CSS 类名
 * CSS 类绑定绑定的语法与属性绑定类似。 但方括号中的部分不是元素的属性名，而是由class前缀，一个点 (.)和 CSS 类的名字组成， 其中后两部分是可选的
 * 可以使用 NgClass 指令来实现同样功能

```html
<!-- standard class attribute setting  -->
<div class="bad curly special">Bad curly special</div>

<!-- toggle the "special" class on/off with a property -->
<div [class.special]="isSpecial">The class binding is special</div>

<!-- binding to `class.special` trumps the class attribute -->
<div class="special"
     [class.special]="!isSpecial">This one is not so special</div>
```

[Back to TOC](#组件与模板)

#### 样式绑定

 * 通过样式绑定，可以设置内联样式
 * 样式绑定的语法与属性绑定类似。 但方括号中的部分不是元素的属性名，而由style前缀，一个点 (.)和 CSS 样式的属性名组成
 * 可以使用 NgStyle 指令来实现同样功能

```html
<button [style.color]="isSpecial ? 'red': 'green'">Red</button>
<button [style.background-color]="canSave ? 'cyan': 'grey'" >Save</button>

<!-- 设置单位 -->
<button [style.font-size.em]="isSpecial ? 3 : 1" >Big</button>
<button [style.font-size.%]="!isSpecial ? 150 : 50" >Small</button>
```

[Back to TOC](#组件与模板)

### 事件绑定

 * 实现数据从元素流向组件
 * (目标事件)="事件名" 形式

```html
<button (click)="onSave()">Save</button>
```
[Back to TOC](#组件与模板)

#### 目标事件

 * 圆括号中的名称 -- 比如（click）

```html
<!-- 下面两种形式等价 -->
<button (click)="onSave()">Save</button>
<button on-click="onSave()">On Save</button>
```
[Back to TOC](#组件与模板)

#### $event 和事件处理语句

 * 事件绑定中， Angular 会为目标事件设置事件处理器
 * 事件触发时，处理器执行模板语句
 * 绑定会通过名叫 $event 的事件对象传递此事件的信息
 * 事件对象的形态取决于目标事件，如果目标事件是原生 DOM 元素事件，$event 就是 DOM 事件对象，具有 target 和 target.value 属性

```html
<!-- 
    下面代码把输入框的 value 属性绑定到 name 属性，用户修改输入触发 input 事件，在包含了 DOM 事件对象($event)的上下文中执行这条语句，
    更新 name 属性，通过路径 $event.target.value 来获取更改后的值
 -->
<input [value]="currentHero.name"
       (input)="currentHero.name=$event.target.value" >
```
[Back to TOC](#组件与模板)

#### 使用 EventEmitter 实现自定义事件

 * 指令使用 Angualr EventEmitter 来触发自定义事件
 * 指令创建一个 EventEmitter 实例，并把它作为属性暴露出来
 * 指令调用 EventEmitter.omit(payload) 来出发事件，可以传入任何东西作为消息载荷
 * 父指令通过绑定到这个属性来监听事件，并通过 $event 对象来访问载荷

```ts
/**
 * HeroDetailComponent 按钮绑定delete事件，它是一个 EventEmitter实例，用户点击按钮触发 delete 方法，
 * 让 EventEmitter 发出一个 Hero 对象，父组件绑定了 HeroDetailComponent 的 deleteRequest 事件，当 
 * deleteRequest 事件触发时，Angular 调用父组件的 deleteHero 方法， 在 $event 变量中传入要删除的英雄
 **/

// src/app/hero-detail.component.ts (template)
template: `
<div>
  <img src="{{heroImageUrl}}">
  <span [style.text-decoration]="lineThrough">
    {{prefix}} {{hero?.name}}
  </span>
  <button (click)="delete()">Delete</button>
</div>`

// src/app/hero-detail.component.ts (deleteRequest)
// This component makes a request but it can't actually delete a hero.
deleteRequest = new EventEmitter<Hero>();

delete() {
  this.deleteRequest.emit(this.hero);
}

// src/app/app.component.html (event-binding-to-component)
<app-hero-detail (deleteRequest)="deleteHero($event)" [hero]="currentHero"></app-hero-detail>
```
[Back to TOC](#组件与模板)

### 双向数据绑定

 * [(x)] : 盒子里的香蕉
 * 具有设置属性和监听事件的特性
 * 双向绑定实际上是属性绑定和事件绑定的语法糖

```ts
// src/app/sizer.component.ts
import { Component, EventEmitter, Input, Output } from '@angular/core';

@Component({
  selector: 'app-sizer',
  template: `
  <div>
    <button (click)="dec()" title="smaller">-</button>
    <button (click)="inc()" title="bigger">+</button>
    <label [style.font-size.px]="size">FontSize: {{size}}px</label>
  </div>`
})
export class SizerComponent {
  @Input()  size: number | string;
  @Output() sizeChange = new EventEmitter<number>();

  dec() { this.resize(-1); }
  inc() { this.resize(+1); }

  resize(delta: number) {
    this.size = Math.min(40, Math.max(8, +this.size + delta));
    this.sizeChange.emit(this.size);
  }
}
```

```html
<!-- fontSize 被双向绑定到 SizerComponent -->
<app-sizer [(size)]="fontSizePx"></app-sizer>
<div [style.font-size.px]="fontSizePx">Resizable Text</div>

<!-- Angular 讲上面的双向绑定解释成下面这样 -->
<app-sizer [size]="fontSizePx" (sizeChange)="fontSizePx=$event"></app-sizer>
<div [style.font-size.px]="fontSizePx">Resizable Text</div>

<!-- $event 变量包含了 SizerComponent.sizeChange 事件的荷载。 当用户点击按钮时，Angular 将 $event 赋值给 AppComponent.fontSizePx -->
```

[Back to TOC](#组件与模板)

### 内置指令

 * Angualr 包含超过 70 个内置指令
 * 指令分为 属性型指令 和 结构型指令

[Back to TOC](#组件与模板)

### 内置属性型指令

 * 属性型指令会监听和修改其它 HTML 元素或组件的行为、元素属性（Attribute）、DOM 属性（Property
 * 下面主要介绍三种最常用的属性型指令
    * NgClass - 添加或移除一组 CSS 类
    * NgClass - 添加或移除一组 CSS样式
    * NgModule - 双向绑定到 HTML 表单元素

[Back to TOC](#组件与模板)

#### NgClass

 *  ngClass 绑定到一个 key:value 形式的控制对象。这个对象中的每个 key 都是一个 CSS 类名，如果它的 value 是 true，这个类就会被加上，否则就会被移除

```ts
// src/app/app.component.ts
currentClasses: {};
setCurrentClasses() {
  // CSS classes: added/removed per current state of component properties
  this.currentClasses =  {
    'saveable': this.canSave,
    'modified': !this.isUnchanged,
    'special':  this.isSpecial
  };
}
```

把 NgClass 属性绑定到 currentClasses，根据它来设置此元素的 CSS 类
```html
<div [ngClass]="currentClasses">This div is initially saveable, unchanged, and special</div>
```
[Back to TOC](#组件与模板)

#### NgStyle

 * NgStyle 需要绑定到一个 key:value 控制对象。 对象的每个 key 是样式名，它的 value 是能用于这个样式的任何值

```ts
currentStyles: {};
setCurrentStyles() {
  // CSS styles: set per current state of component properties
  this.currentStyles = {
    'font-style':  this.canSave      ? 'italic' : 'normal',
    'font-weight': !this.isUnchanged ? 'bold'   : 'normal',
    'font-size':   this.isSpecial    ? '24px'   : '12px'
  };
}
```

把 NgStyle 属性绑定到 currentStyles，以据此设置此元素的样式
```html
<div [ngStyle]="currentStyles">
  This div is initially italic, normal weight, and extra large (24px).
</div>
```
[Back to TOC](#组件与模板)

#### NgModule

 * 在使用 ngModel 指令进行双向数据绑定之前，你必须导入 FormsModule 并把它添加到 Angular 模块的 imports 列表中

```ts
import { NgModule } from '@angular/core';
import { BrowserModule }  from '@angular/platform-browser';
import { FormsModule } from '@angular/forms'; // <--- JavaScript import from Angular

/* Other imports */

@NgModule({
  imports: [
    BrowserModule,
    FormsModule  // <--- import into the NgModule
  ],
  /* Other module metadata */
})
export class AppModule { }
```

```html
<input [(ngModel)]="currentHero.name">

<!-- 等价于 -->
<input
  [ngModel]="currentHero.name"
  (ngModelChange)="currentHero.name=$event">
```
[Back to TOC](#组件与模板)

### 内置结构型指令

 * 结构型指令的职责是 HTML 布局，它们塑造或重塑 DOM 的结构
 * 主要介绍下面三个指令
    * NgIf - 根据条件把一个元素添加到 DOM 中或从 DOM 移除
    * NgSwitch - 一组指令，用来在多个可选视图之间切换
    * NgForOf - 对列表中的每个条目重复套种同一个模板

[Back to TOC](#组件与模板)

#### NgIf

 * 隐藏子树与 NgIf 不通
    * 隐藏子树时，它仍然留在 DOM 中，NgIf 为 false 时，Angular 会从 DOM 中物理移除这个元素子树，节约资源
    * ngIf 可以用来防范空指针错误，显示/隐藏方式无法防范，当一个表达式尝试访问空值的属性时，Angular 就会抛出一个异常

```html
<!-- 使用 ngIf -->
<app-hero-detail *ngIf="isActive"></app-hero-detail>

<!-- 使用样式或类绑定 -->
<!-- isSpecial is true -->
<div [class.hidden]="!isSpecial">Show with class</div>
<div [class.hidden]="isSpecial">Hide with class</div>

<!-- HeroDetail is in the DOM but hidden -->
<app-hero-detail [class.hidden]="isSpecial"></app-hero-detail>

<div [style.display]="isSpecial ? 'block' : 'none'">Show with style</div>
<div [style.display]="isSpecial ? 'none'  : 'block'">Hide with style</div>

<!-- 防范空指针错误 -->
<div *ngIf="currentHero">Hello, {{currentHero.name}}</div>
<div *ngIf="nullHero">Hello, {{nullHero.name}}</div>
```
[Back to TOC](#组件与模板)

#### NgForOf

 * 展开显示列表

```html
<!-- 应用在 标签上 -->
<div *ngFor="let hero of heroes">{{hero.name}}</div>

<!-- 应用在组件元素上 -->
<app-hero-detail *ngFor="let hero of heroes" [hero]="hero"></app-hero-detail>
```
[Back to TOC](#组件与模板)

#### 模板输入变量

 * hero 前的 let 关键字创建了一个名叫 hero 的模板输入变量
 * 你可以在 ngFor 的宿主元素（及其子元素）中引用模板输入变量 hero

```html
<div *ngFor="let hero of heroes">{{hero.name}}</div>
<app-hero-detail *ngFor="let hero of heroes" [hero]="hero"></app-hero-detail>
```
[Back to TOC](#组件与模板)

#### 带索引的 *ngFor

 * NgFor 指令上下文中的 index 属性返回一个从零开始的索引，表示当前条目在迭代中的顺序

```html
<div *ngFor="let hero of heroes; let i=index">{{i + 1}} - {{hero.name}}</div>
```
[Back to TOC](#组件与模板)

#### 带 trackBy 的 *ngFor

[Back to TOC](#组件与模板)

#### NgSwitch 指令

 * NgSwitch 指令类似于 JavaScript 的 switch 语句。 它可以从多个可能的元素中根据switch 条件来显示某一个。 Angular 只会把选中的元素放进 DOM 中
 * NgSwitch 实际上包括三个相互协作的指令：NgSwitch、NgSwitchCase 和 NgSwitchDefault
 * NgSwitch 是一个属性型指令，而不是结构型指令，因为修改的时原生的行为，没有直接接触 DOM 结构
 * *ngSwitchCase 和 *ngSwitchDefault NgSwitchCase 和 NgSwitchDefault 指令都是结构型指令

```html
<div [ngSwitch]="currentHero.emotion">
  <app-happy-hero    *ngSwitchCase="'happy'"    [hero]="currentHero"></app-happy-hero>
  <app-sad-hero      *ngSwitchCase="'sad'"      [hero]="currentHero"></app-sad-hero>
  <app-confused-hero *ngSwitchCase="'confused'" [hero]="currentHero"></app-confused-hero>
  <app-unknown-hero  *ngSwitchDefault           [hero]="currentHero"></app-unknown-hero>
</div>
```
[Back to TOC](#组件与模板)

### 模板引用变量（#var）

 * 模板引用变量通常用来引用模板中的某个 DOM 元素，它还可以引用 Angular 组件或指令或 Web Component
 * 使用井号（#）来声明引用变量，或者 *ref-* 
 * 可以在模板中的任何地方引用模板变量
 * 模板变量的作用范围是整个模板，不要在同一个模板中多次定义同一个变量

```html
<!-- #phone 的意思就是生命一个名叫 phone 的变量来引用 <input> 元素 -->
<input #phone placeholder="phone number">


<!-- -------分割线-------- -->

<!-- 在 <input> 上声明 phone 变量可以在模板的另一侧的 <button> 上使用 -->
<input #phone placeholder="phone number">

<!-- lots of other elements -->

<!-- phone refers to the input element; pass its `value` to an event handler -->

<!-- button 标签中的 phone.value 值就是 input 标签输入的值-->
<button (click)="callPhone(phone.value)">Call</button>
```
[Back to TOC](#组件与模板)

### 输入和输出属性

 * 输入属性是一个带用 @Input 修饰器的可设置属性，当它通过*属性绑定*的形式被绑定时，值会“流入”这个属性
 * 输出属性是一个带有 @Output 修饰器的可观察对象型的属性，这个属性几乎总是返回 Angular 的EventEmitter，当它通过*事件绑定*的形式被绑定时，值会“流出”这个属性
 * 只能通过输入和输出属性将其绑定到其它组件
 * 所有的组件都是指令
 * 在同一个组件中，模板可以绑定组件的公共属性，不用设置 input 或 output
 * 将一个组件的属性绑定到另一个属性需要使用 input 或 output

```html
<!-- iconUrl 和 onSave 是组件的成员,不需要使用 input 和 output -->
<img [src]="iconUrl"/>
<button (click)="onSave()">Save</button>

<!-- hero 不是 hero-detail 组件属性，这样使用会报错 -->
<app-hero-detail [hero]="currentHero" (deleteRequest)="deleteHero($event)">
</app-hero-detail>
```
[Back to TOC](#组件与模板)

#### 声明输入与输出属性

```ts
// src/app/hero-detail.component.ts
@Input()  hero: Hero;
@Output() deleteRequest = new EventEmitter<Hero>();
```

```html
<!-- hero-detail 组件声明了 hero 为输入属性，deleteRequest 为输出属性，所有使用不会报错 -->
<app-hero-detail [hero]="currentHero" (deleteRequest)="deleteHero($event)"></app-hero-detail>
```
[Back to TOC](#组件与模板)

#### 输入还是输出

 * 输入属性通常指接受数据
 * 输出属性暴露事件产生者，如 EventEmitter 对象
 * 输入和输出是从目标指令的角度来说的

```html
<!-- 从 HeroDetailComponent 角度来看，HeroDetailComponent.hero 是个输入属性， 因为数据流从模板绑定表达式流入那个属性。 -->

<!-- 从 HeroDetailComponent 角度来看，HeroDetailComponent.deleteRequest 是个输出属性， 因为事件从那个属性流出，流向模板绑定语句中的处理器。 -->
<app-hero-detail [hero]="currentHero" (deleteRequest)="deleteHero($event)"></app-hero-detail>
```
[Back to TOC](#组件与模板)

#### 给输入输出起别名

 * 让输入/输出属性的公共名字不同于内部名字

```html
<div (myClick)="clickMessage=$event" clickable>click with myClick</div>
```

```ts
// 下面两种形式都将指令 clicks 对应别名 myClick
@Output('myClick') clicks = new EventEmitter<string>(); //  @Output(alias) propertyName = ...

@Directive({
  outputs: ['clicks:myClick']  // propertyName:alias
})
```
[Back to TOC](#组件与模板)

### 模板表达式

 * 模板表达式使用了 JavaScript 语法的子集

[Back to TOC](#组件与模板)

#### 管道操作符 (|)

 * 对表达式结果进行转换
 * 可以多个管道串联

```html
<!-- 把 title 的值变成大写 -->
<div>Title through uppercase pipe: {{title | uppercase}}</div>

<!-- Pipe chaining: convert title to uppercase, then to lowercase -->
<div>
  Title through a pipe chain:
  {{title | uppercase | lowercase}}
</div>

<!-- 使用参数  -->
<!-- pipe with configuration argument => "February 25, 1970" -->
<div>Birthdate: {{currentHero?.birthdate | date:'longDate'}}</div>

<!-- 使用jsan -->
<div>{{currentHero | json}}</div>
```
[Back to TOC](#组件与模板)

#### 安全导航操作符(?.)和空属性路径

```html
<!-- 当 currentHero 的name 为空时，保护视图渲染器，让它免于失败  -->
<!-- 支持长属性路径 current?.name?.age -->
The current hero's name is {{currentHero?.name}}
```
[Back to TOC](#组件与模板)

#### 非空断言操作符 (!)

```html
<!--hero属性一定不为空，防止 Angular 编译器把你的模板转换成 TS 代码时，报错-->
<div *ngIf="hero">
  The hero's name is {{hero!.name}}
</div>
```
[Back to TOC](#组件与模板)

### 类型转换

 * 消除绑定类型时，类型不匹配报错
 * 使用 $any 把表达式转换为 any 类型
  
```html
<!-- Accessing an undeclared member -->
<!-- <div>
  The hero's marker is {{$any(hero).marker}}
</div> -->
```
[Back to TOC](#组件与模板)

## 生命周期钩子

## 组件交互

## 组件样式

## Angular 自定义元素

## 动态组件

## 属性型组件指令

## 结构型指令

## 管道

## 动画
