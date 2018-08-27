
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
- [JS 模块 vs NgModule](#js-%E6%A8%A1%E5%9D%97-vs-ngmodule)
  - [JS Module](#js-module)
  - [NgModules](#ngmodules)
  - [NgModule 类与 JS 模块对比](#ngmodule-%E7%B1%BB%E4%B8%8E-js-%E6%A8%A1%E5%9D%97%E5%AF%B9%E6%AF%94)


# JS 模块 vs NgModule

 * Angular 应用同时依赖 JS Module 和 NgModule

## JS Module

 * 在 JS 中，模块是内含 JS 代码的独立文件，要让其能够被使用，需要导出该模块

```js
// export js module
export class AppComponent { ... }
// import js module
import { AppComponent } from './app.component';
```

## NgModules

 * NgModule 是*一些*(不是一个)带有 @NgModule 修饰器的类
 * NgModule 修饰器的 imports 数组表示哪些 NgModule 是当前 Angular 应用多需要的，imports 数组中的模块是 NgModule 而不是 JS Module;
 * 带有 @NgModule 修饰器的类通常会习惯性的放在单独的文件中，因为带有 @NgModule 修饰器和元数据，用户区分

Angular CLI 生成的 AppModule 如下：
```ts
/* These are JavaScript import statements. Angular doesn’t know anything about these. */
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';

/* The @NgModule decorator lets Angular know that this is an NgModule. */
@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [     /* These are NgModule imports. */
    BrowserModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

## NgModule 类与 JS 模块对比

 * Angular 模块只绑定了可声明的类，这些可声明的类只是供 Angular 编译器用的
 * 与 JS 类把它所有的成员类都放在一个巨型文件中不同，NgModule 需要把该模块的类列在它的 @NgModule.declarations 列表中
 * Angular 模块只能导出可声明的类，这可能时它自己拥有的也可能时从其它模块中导入的，它不会声明或导出其它类型的类
 * 与 JS 模块不同，NgModule 可以通过把服务提供商加到 @NgModule.providers 列表中，来用服务扩展整个应用