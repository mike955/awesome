# 特性模块

 - 特性模块是用来对代码进行组织的模块


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
- [特性模块](#%E7%89%B9%E6%80%A7%E6%A8%A1%E5%9D%97)
    - [特性模块vs根模块](#%E7%89%B9%E6%80%A7%E6%A8%A1%E5%9D%97vs%E6%A0%B9%E6%A8%A1%E5%9D%97)
    - [如何制作特性模块](#%E5%A6%82%E4%BD%95%E5%88%B6%E4%BD%9C%E7%89%B9%E6%80%A7%E6%A8%A1%E5%9D%97)
    - [导入特性模块](#%E5%AF%BC%E5%85%A5%E7%89%B9%E6%80%A7%E6%A8%A1%E5%9D%97)
    - [渲染特性模块的组件模板](#%E6%B8%B2%E6%9F%93%E7%89%B9%E6%80%A7%E6%A8%A1%E5%9D%97%E7%9A%84%E7%BB%84%E4%BB%B6%E6%A8%A1%E6%9D%BF)

## 特性模块vs根模块

 * 特性模块时最佳的组织方式
 * 特性模块提供了聚焦于特定应用需求的一组功能，比如用户工作流、路由或表单
 * 通过特性模块把应用划分成一些聚焦的功能区让服务便于管理

## 如何制作特性模块

 * 通过 CLI 命令生成 
    * `ng g module CustomerDashboard` : 在当前目录创建一个名为 customer-dashboard  的文件夹，文件夹下有一个名为 customer-dashboard.module.ts的文件
    * `ng g component customer-dashboard/CustomerDashboard` ：在 customer-dashboard 目录下创建一个名为 customer-dashboard 的组件

```ts
// module-name.module.ts
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

@NgModule({
  imports: [
    CommonModule
  ],
  declarations: []
})
export class CustomerDashboardModule { }    // 暴露特性模块

// import the new component
import { CustomerDashboardComponent } from './customer-dashboard/customer-dashboard.component';
@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [
    CustomerDashboardComponent
  ],
})
```
 * 无论是根模块还是特性模块，其 NgModule 结构都时一样的
 * 特性模块导入 CommonModule，而不是 BrowserModule，BrowserModule 只应该在根模块中导入一次
 * declarations 数组用于添加这个模块的可声明对象(组件、指令、管道)

## 导入特性模块

 * 把特性模块添加到 AppModule 中即导入该特性模块

```ts
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

import { AppComponent } from './app.component';
// import the feature module here so you can add it to the imports array below
import { CustomerDashboardModule } from './customer-dashboard/customer-dashboard.module';


@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    CustomerDashboardModule // add the feature module here
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```
如果你往该特性模块中加入任何服务商，AppModule 也同样会知道

## 渲染特性模块的组件模板

 * 在 declarations 数组的下方，添加一个 exports 数组，并加入当前模块名字
 * 然后在 AppComponent 的 app.component.html 中加入标签 <app-cunstomer-dashboard>

```ts
// app/customer-dashboard/customer-dashboard.module.ts
@NgModule({
  imports: [
    CommonModule
  ],
  declarations: [
    CustomerDashboardComponent
  ],
  exports: [        // 添加到处模块
  CustomerDashboardComponent
]
})
```
```html
<!-- app/app.component.html -->
<h1>
  {{title}}
</h1>

<!-- add the selector from the CustomerDashboardComponent -->
<app-customer-dashboard></app-customer-dashboard>
```