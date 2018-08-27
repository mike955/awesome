
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
- [常用模块](#%E5%B8%B8%E7%94%A8%E6%A8%A1%E5%9D%97)
- [导入模块](#%E5%AF%BC%E5%85%A5%E6%A8%A1%E5%9D%97)
- [BrowserModule 和 CommonModule](#browsermodule-%E5%92%8C-commonmodule)

# 常用模块

- Angular 应用需要不止一个模块，但是它们都为根模块服务
- 要实现某些特性，可以添加响应的模块来实现

| NgModule            | 导入自                    | 为何使用                                 |
| ------------------- | ------------------------- | ---------------------------------------- |
| BrowserModule       | @angular/platfrom-browser | 当你想要在浏览器中运行应用时             |
| CommonModule        | @angular/common           | 当你想要使用 NgIf 和 NgFor 时            |
| FormsModule         | @angular/forms            | 当要构建模板驱动表单时 (它包含 NgModule) |
| ReactiveFormsModule | @angular/froms            | 当要构建响应式表单时                     |
| RouterModule        | @angular/router           | 当要使用和路由相关服务时                 |
| HttpClientModule    | @angular/common/http      | 当要和服务对话时                         |

# 导入模块

 * 使用 Angular 模块时，需要在 AppModule 中导入它们，并把它们列在当前 @NgModule 的imports 数组中

```ts
/* import modules so that AppModule can access them */
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [ /* add modules here so Angular knows to use them */
    BrowserModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

# BrowserModule 和 CommonModule

 * BrowserModule 导入了 CommonModule，它贡献了很多通用指令，如 ngIf 和 ngFor
 * BrowserModule 重新导出了 CommonModule，以便它所有的指令在任何导入了 browserModule 的 Angular 模块中都可以使用
 * 如果应用运行在浏览器中，必须在根模块 AppModule 导入 BrowserModule
 * 如果把 BrowserModule 导入了惰性加载的特性模块中，Angular 会返回一个错误，并告诉你应该改用 CommonModule