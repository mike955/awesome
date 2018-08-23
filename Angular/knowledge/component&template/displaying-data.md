<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
# 显示数据
<!-- code_chunk_output -->

* [显示数据](#显示数据)
	* [使用插值表达式显示组件属性](#使用插值表达式显示组件属性)
	* [内联模版与模板文件](#内联模版与模板文件)
	* [构造函数与变量初始化](#构造函数与变量初始化)
	* [ngFor 显示数组属性](#ngfor-显示数组属性)
	* [为数据创建一个类](#为数据创建一个类)
	* [通过 NgIf 进行条件显示](#通过-ngif-进行条件显示)

<!-- /code_chunk_output -->


## 使用插值表达式显示组件属性

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

[Back to TOC](#显示数据)

## 内联模版与模板文件

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

[Back to TOC](#显示数据)

## 构造函数与变量初始化

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

[Back to TOC](#显示数据)

## ngFor 显示数组属性

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

[Back to TOC](#显示数据)

## 为数据创建一个类

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

[Back to TOC](#显示数据)

## 通过 NgIf 进行条件显示

- 条件显示视图和视图的一部分
- ngIf 指令会根据一个布尔条件来显示或移除一个元素

```ts
// 当 heroes数组的长度大于 3 时，显示下面的 p 标签
template: `
  <p *ngIf="heroes.length > 3">There are many heroes!</p>
`;
```

[Back to TOC](#显示数据)
