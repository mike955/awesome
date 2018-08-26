# 引导启动

## 启动过程

 * NgModule 用于描述应用的各个部分如何组织在一起，每个应用至少有一个 Angular 模块，根模块是用来启动此应用的模块，命名通常为 AppModule

使用 CLI 生成的应用，默认的 AppModule 如下:
```ts
/* JavaScript imports */
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { AppComponent } from './app.component';

/* the AppModule class with the @NgModule decorator */
@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

@NgModule 修饰器表明 AppModule 是一个 NgModule类，@NgModule 获取一个元数据对象，它告诉 Angualr 如何编译和启动本应用

    * declaration - 该应用所拥有的组件
    * imports - 导入 BrowserModule 以获取浏览器特有的服务，比如 DOM 渲染、无害化处理和位置(location)
    * providers - 各种服务提供商
    * bootstrap - 根组件，Angular 创建它并插入 index.html 宿主页面

默认的 CLI 应用只有一个组件 AppComponent，所以它会同时出现在 declarations 和 bsststrap 数组中

## declarations 数组

 * declarations 数组表示哪些组件属于该模块，创建新模块时，应该把其加入 declarations 中
 * 每个组件都应该(且只能)声明在一个 NgModule 类中，使用为声明的组件会报错
 * declarations 数组只能接收可声明对象，可声明对象包括组件、指令和管道;一个模块的所有声明对象都必须放在 declarations 数组中;可声明对象必须只能属于一个模块，同一个类被声明在多个模块中会报错
 * 可声明类在当前模块中时可见的，对其它模块中的组件是不可见的
 * 每个可声明对象就只能属于一个模块，只能把它声明在一个 @NgModule 中

### 通过 @NgModule 使用指令

 * 使用 declarations 数组声明指令，在模块中使用指令、组件或管道步骤如下：
    * 从编写的文件中导出指令、组件、或管道
    * 把它导入到适当的模块中
    * 在 @NgModule 的 declarations 数组中声明它

```ts
// 导出指令
import { Directive } from '@angular/core';

@Directive({
  selector: '[appItem]'
})
export class ItemDirective {
// code goes here
  constructor() { }

}

// 导入指令
import { ItemDirective } from './item.directive';

// 把指令添加到 @NgModule 的 declarations 数组中
declarations: [
  AppComponent,
  ItemDirective
],

// 经过上面三个步骤后就可以在组件中使用 ItemDirective 指令了
```

## imports 数组

 * 模块的 imports 数组只会出现在 @NgModule 元数据对象中
 * 列表中的模块导出了本模块中的各个组件模板中所引用的各个组件、指令或管道

## providers 数组

 * providers 数组中列出了该应用所需的服务，当直接把服务列在这里时，它们时全应用范围的

## bootstrap 数组

 * 应用时通过引导根模块 AppModule 来启动的，根模块还引用了 entryComponent; 引导过程还会创建 bootstrap 数组中列出的组件，并把它们逐个插入到浏览器的 DOM 中
 * 每个被引导的组件都是它自己的组件树的根，插入一个被引导的组件通常触发一系列组件的创建并形成组件树
 * 大多数应用只有一个组件树，并且只从一个根组件开始引导，根组件通常叫做 AppComponent,并且位于根模块的 bootstrap 数组中