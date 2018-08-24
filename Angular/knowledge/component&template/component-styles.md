# 组件样式

 * Angular 使用标准的 CSS来这只样式
 * Angualr 还能把组件样式捆绑在组件上
---

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [组件样式](#组件样式)
	* [使用组件样式](#使用组件样式)
	* [范围化的样式](#范围化的样式)
	* [特殊的选择器](#特殊的选择器)
		* [:host 选择器](#host-选择器)
		* [:host-context 选择器](#host-context-选择器)
		* [已废弃/deep/、>>>、::ng-deep](#已废弃deep-ng-deep)
	* [把样式加载进数组中](#把样式加载进数组中)
		* [元数据中的样式](#元数据中的样式)
		* [组件元数据中的样式文件](#组件元数据中的样式文件)
		* [模版内联样式](#模版内联样式)
		* [模板中的 link 标签](#模板中的-link-标签)
		* [CSS@imports 语法](#cssimports-语法)
		* [外部以及全局样式文件](#外部以及全局样式文件)
		* [非 CSS 样式文件](#非-css-样式文件)
	* [控制视图的封装模式:原生(Native)、仿真(Emulated)、无(None)](#控制视图的封装模式原生native-仿真emulated-无none)
	* [查看仿真(Emulated)模式下生成的 CSS](#查看仿真emulated模式下生成的-css)


## 使用组件样式

 * 在组员的元数据中设置 styles 属性
 * styles 属性可以接受一个包含 CSS 代码的字符串数组，*注意：styles 值时字符串数组*

```ts
@Component({
  selector: 'app-root',
  template: `
    <h1>Tour of Heroes</h1>
    <app-hero-main [hero]="hero"></app-hero-main>
  `,
  styles: ['h1 { font-weight: normal; }']
})
export class HeroAppComponent {
/* . . . */
}
```

[Back TO TOC](#组件样式)

## 范围化的样式(组件样式)

 * 在 @Component 的元数据中指定的样式只会对改组件的模板生效
 * 范围化样式既不会被模板中嵌入的组件继承，也不会被通过内容投影(如:ng-content)嵌进来的组件集成
 * 范围化样式特性
    * 可以使用对每个组件最有意义的 CSS 类名和选择器
    * 类名和选择器时仅属于组件内部的，不会和应用中其它地方的类名和选择器出现冲突
    * 组件的样式不会因为别的地方修改了样式而被意外修改
    * 可以让每个组件的 CSS 代码和它的 TS、HTML 代码放在一起，促成清爽整洁的目录结构
    * 修改或移除组件的 CSS 代码，不会对其它组件造成影响

[Back TO TOC](#组件样式)

## 特殊的选择器

 * 从影子(Shadow) DOM 样式范围领域引入的特殊选择器
 
[Back TO TOC](#组件样式)

### :host 选择器

 * 选择宿主元素中的元素(相对组件模板内部的元素)

```css
:host {
  display: block;
  border: 1px solid black;
}

/* 把宿主元素作为目标，但是只有当它同时带有 active CSS 类的时候才会生效 */
:host(.active) {
  border-width: 3px;
}
```

[Back TO TOC](#组件样式)

### :host-context 选择器


[Back TO TOC](#组件样式)
### 已废弃/deep/、>>>、::ng-deep


[Back TO TOC](#组件样式)
## 把样式加载进数组中

 * 有三种方式把样式加入组件
    * 设置 styles 或 styleUrls 元数据
    * 内联在模板 HTML 中
    * 通过 CSS 文件导入

[Back TO TOC](#组件样式)
### 元数据中的样式

 * 给 @Component 装饰器添加一个 styles 数组型属性
 * 这个数组中的每一个字符串（通常也只有一个）定义一份 CSS
 * 样式只对当前组件生效，不会作用域模板中嵌入的组件，也不会作用与投影进来的组件

```ts
@Component({
  selector: 'app-root',
  template: `
    <h1>Tour of Heroes</h1>
    <app-hero-main [hero]="hero"></app-hero-main>
  `,
  styles: ['h1 { font-weight: normal; }']
})
export class HeroAppComponent {
/* . . . */
}
```

使用 --inline-styles 标识创建组件时，cli 会定义一个空的 styles 数组
```sh
ng generate component hero-app --inline-style
```

[Back TO TOC](#组件样式)

### 组件元数据中的样式文件

 * 把外部 CSS 文件添加到 @Component 的 styleUrls 属性中来加载外部样式
 * 样式只对当前组件生效，不会作用域模板中嵌入的组件，也不会作用与投影进来的组件
 * 可以指定多个样式文件，甚至可以组合使用 style 和 styleUrls 方式

```ts
@Component({
  selector: 'app-root',
  template: `
    <h1>Tour of Heroes</h1>
    <app-hero-main [hero]="hero"></app-hero-main>
  `,
  styleUrls: ['./hero-app.component.css']
})
export class HeroAppComponent {
/* . . . */
}
```

```css
/* hero-app.component.css */
h1 {
  font-weight: normal;
}
```
[Back TO TOC](#组件样式)

### 模版内联样式

 * 在组件的 HTML 模板中嵌入 <style> 标签

```ts
@Component({
  selector: 'app-hero-controls',
  template: `
    <style>
      button {
        background-color: white;
        border: 1px solid #777;
      }
    </style>
    <h3>Controls</h3>
    <button (click)="activate()">Activate</button>
  `
})
```
[Back TO TOC](#组件样式)

### 模板中的 link 标签

 * 在组件的 HTML 模板中写 <link> 标签
 * 使用 CLI 进行构建时，要确保这个链接到的样式表文件被复制到了服务器上。参见

```ts
@Component({
  selector: 'app-hero-team',
  template: `
    <!-- We must use a relative URL so that the AOT compiler can find the stylesheet -->
    <link rel="stylesheet" href="../assets/hero-team.component.css">
    <h3>Team</h3>
    <ul>
      <li *ngFor="let member of hero.team">
        {{member}}
      </li>
    </ul>`
})
```

[Back TO TOC](#组件样式)

### CSS@imports 语法

 * 利用标准的 CSS @import 规则来把其它 CSS 文件导入到 CSS 文件中
 * URL 是相对于你正在导入的 CSS 文件的

```css
/* The AOT compiler needs the `./` to show that this is local */
@import './hero-details-box.css';
```

[Back TO TOC](#组件样式)

### 外部以及全局样式文件

 * 当使用 CLI 进行构建时，你必须配置 angular.json 文件，使其包含所有外部资源
 * 在它的 styles 区注册这些全局样式文件，默认情况下，它会有一个预先配置的全局 styles.css 文件

```json
{
  "$schema": "./node_modules/@angular/cli/lib/config/schema.json",
  "version": 1,
  "newProjectRoot": "projects",
  "projects": {
    "angular-tour-of-heroes": {
      "architect": {
        "build": {
            ...
            "styles": [
              "src/styles.css"
            ],
            "scripts": []
          }
        },
        "test": {
          "builder": "@angular-devkit/build-angular:karma",
          "options": {
            "styles": [
              "src/styles.css"
            ]
            ...
          }
        },
      }
    }
  },
  "defaultProject": "angular-tour-of-heroes"
}
```

[Back TO TOC](#组件样式)

### 非 CSS 样式文件

 * 使用 CLI 进行构建，那么你可以用 sass、less 或 stylus 来编写样式，并使用相应的扩展名（.scss、.less、.styl）把它们指定到 @Component.styleUrls 元数据中
 * CLI 的构建过程会运行相关的预处理器

```ts
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
...
```

CLI 构建

```sh
ng new sassy-project --style=sass
```

[Back TO TOC](#组件样式)

## 控制视图的封装模式:原生(Native)、仿真(Emulated)、无(None)

 * 在组件的元数据上设置视图封装模式，你可以分别控制每个组件的封装模式
 * Native 视图包装模式使用浏览器原生 Shadow DOM 的一个废弃实现
 * Emulated 模式（默认值）通过预处理（并改名）CSS 代码来模拟 Shadow DOM 的行为，以达到把 CSS 样式局限在组件视图中的目的
 * None 意味着 Angular 不使用视图封装。 Angular 会把 CSS 添加到全局样式中。而不会应用上前面讨论过的那些作用域规则、隔离和保护等
 * 通过组件元数据中的 encapsulation 属性来设置组件封装模式

```ts
// 通过组件元数据中的 encapsulation 属性来设置组件封装模式
// warning: few browsers support shadow DOM encapsulation at this time
import { Component, ViewEncapsulation } from '@angular/core';

@Component({
  selector: 'my-app',
  template: `
    <h4>Welcome to Angular World</h4>
    <p class="greet">Hello {{name}}</p>
  `,
  styles: [`
    .greet {
      background: #369;
      color: white;
    }
  `],
  encapsulation: ViewEncapsulation.None // None | Emulated | Native
})
export class AppComponent {
  name: string = 'Semlinker';
}
```

[Back TO TOC](#组件样式)

## 查看仿真(Emulated)模式下生成的 CSS

 * 使用默认的仿真模式时，Angular 会对组件的所有样式进行预处理，让它们模仿出标准的 Shadow CSS 作用域规则
 * 启用了仿真模式的 Angular 应用的 DOM 树中，每个 DOM 元素都被加上了一些额外的属性