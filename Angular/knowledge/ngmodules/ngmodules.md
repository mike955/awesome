
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
- [NgModule 简介](#ngmodule-%E7%AE%80%E4%BB%8B)
- [Angular 模块化](#angular-%E6%A8%A1%E5%9D%97%E5%8C%96)
- [基本的模块](#%E5%9F%BA%E6%9C%AC%E7%9A%84%E6%A8%A1%E5%9D%97)


# NgModule 简介

 * Angular 模块(NgModule) 用于配置注入器和编译器，并把相关的东西组织在一起
 * NgModule 是一个带有 @NgModule 修饰器的类，@NgModule 的参数时一个元数据对象，用来描述如何编译组件的模板，以及如何在运行时创建注入器
 * NgModule 会标出该模块自己的组件、指令、管道，通过 exports 属性公开其中的一部分，让外部组件使用
 * NgModule 还能把一些服务提供商添加到应用的以来注入器

# Angular 模块化

 * 模块化是组织应用和使用外部库扩展应用的最佳途径
 * Angular 自己的库都是 NgModule，如 FromsModule、HttpClientModule 和 RouterModule；很多第三方库也是 NgModule，如：Material Design、Ionic、AngularFire2
 * Angular 模块把组件、指令、管道打包成内聚的功能块，每个模块聚焦于一个特性区域、业务区域、工作流或通用工具
 * 模块还可以把服务添加到应用中，服务可以时自己编写的或来自于外部(Angular 的路由和 HTTP 客户端))
 * 模块可以在应用启动时立即加载，也可以由路哟偶器进行异步的惰性加载
 * NgModule 的元数据会做下面的事情:
    * 声明某些组件、指令和管道属于这个模块
    * 暴露其中的部分组件、指令和管道，让其它模块中的组件模板可以使用
    * 导入其它带有组件、指令和管道的模块供本组件使用
    * 提供一些供应用中的其它组建使用的服务
 * 每个 Angular 应用至少由一个模块，即根模块;通过引导根模块来启动该应用

# 基本的模块
CLI 在创建新应用时会生成下列基本的应用模块

```ts
// imports
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';
import { ItemDirective } from './item.directive';

// NgModule配置
// @NgModule decorator with its metadata
@NgModule({
  declarations: [   // 指令
    AppComponent,
    ItemDirective
  ],
  imports: [        // 使用了哪些模块
    BrowserModule,
    FormsModule,
    HttpClientModule
  ],
  providers: [],    // 服务提供商
  bootstrap: [AppComponent]     // 启动组件(根模块)
})
export class AppModule { }
```
