# 路由与导航

 * Angular 的路由器能让用户从一个试图导航到另一个试图


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

   - [路由与导航](#路由与导航)
    - [概览](#概览)

## 概览

## 基础知识

### <base href> 元素

 * 传统的路由导航通过设置 href 值来设置路由路径

### 从路由库中导入配置

 * Angular 的路由器为一个可选服务，不是核心库的一部分，使用时需要引入

```ts
 import { RouterModule, Routes } from '@angular/router'
```

### 配置

 * 每个带路由的 Angular 应用都由一个 Router 服务的单例对象
 * 当浏览器的 url 变化时，路由器查找对应的 Route，并显示相应的组件
 * 路由器需要先配置才能使用

```ts
// src/app/app.module.ts

const appRoutes: Routes = [
    {path: 'crisis-center', component: CrisisListComponent},
    {path : 'hero/:id', component: HeroDetailComponent},
    {
        path: 'heroes',
        component: HeroListComponent,
        data: { title: 'Heroes List' }
    },
    {   path: '',
        redirectTo: '/heroes',
        pathMatch: 'full'
    },
    { path: '**', component: PageNotFoundComponent }
];

@NgModule({
  imports: [
    RouterModule.forRoot(
      appRoutes,
      { enableTracing: true } // <-- debugging purposes only
    )
    // other imports here
  ],
  ...
})
export class AppModule { }
```
上面的例子中，appRoutes定义了五个路由，用来描述如何进行导航，并用 RouterModule.foRoot 方法来配置路由器，并发返回值添加到 AppModule 的 imports 数组中

每个 Route 都会把一个 URL 的 path 映射到一个组建，path 不能以斜杠(/)开头，路由器会为解析和构建最终的 URL

第二个路由中的 :id 是一个路由参数的令牌(Token)，比如 /hero/42 这个 URL 中 "42"是 id 的参数，该 URL 对应的 HeroDetailComponent 组建将据此查找和展现 id 为 42 的英雄

第三个路由中的 data 用来存放每个具体路由有关的任意信息，该数据可以被任何一个激活路由访问，并能用来存放诸如页标题、面包屑以及其它静态只读数据

第四个路由中的空路径 ('') 表示应用的默认路径，当 URL 为空时就会访问哪里

第五个路由中的 ** 路径是一个通配符，当所有请求的 URL 不匹配前面定义的路由表中的任何路径时，路由器就会悬着此路由

把 enableTracing: true 选项作为第二个参数传给 RouterModule.forRoot() 方法可以把整个导航声明周期中的事件输出到浏览器的控制台，可以用于调试

### 路由出口

### 路由链接

 * 通过给标签添加 routeLink 属性来控制导航跳转路径

 ```ts
 template: `
  <h1>Angular Router</h1>
  <nav>
    <a routerLink="/crisis-center" routerLinkActive="active">Crisis Center</a>
    <a routerLink="/heroes" routerLinkActive="active">Heroes</a>
  </nav>
  <router-outlet></router-outlet>
`
 ```
 routerLinkActive 指令可以帮助用户在外观上区分出当前选中的“活动”路径

### 路由器状态

 * 在导航时的每个生命周期成功完成时，路由器会构建出一个 ActivatedRoute 组成的树，它表示路由器的当前状态，可以在应用中的任何地发用 Router 服务及其 routerState 属性来访问当前的 RouterState 值
 * RouterState 中的每个 ActivatedRoute 都提供了从任意激活路由开始向上或向下遍历路由数的一种方式，以获得关于父、子、兄弟路由的信息

### 激活的路由

 * 激活的路由的路径和参数可以通过注入进来的一个名叫 ActivatedRoute 的路由服务来获取，它由一大堆由用的信息，如下表:

|属性|说明|
|---|---|
|url|路由路径的 Observable 对象，是一个由路由路径中的各个部分组成的字符串数组|
|data|一个 Observable，其中包含提供给路由的 data 对象，也包含由解析守卫(resolve guard)解析而来的值|
|paramsMap|一个 Observable,其中包含一个由当前路由的必要参数和可选参数组成的 map 对象，用这个 map 可以获取来自同名参数的单一值或多重值|
|queryParamMap|一个 Observable,其中包含一个对所有路由都有效的查询参数组成的 map 对象，用这个 map 可以获取来自查询参数的单一值或多重值|
|fragment|一个适用于所有路由的 URL 的 fragment(片段)的 Observable|
|outlet|要把该路由渲染到的 RouterOutlet 的名字，对于无名路由，它的路由名是 primary，而不是空串|
|routeConfig|用于该路由的路由配置信息，其中包含原始路径|
|parent|当该路由是一个子路由时，表示该路由的父级 ActivatedRoute|
|firstChild|包含该路径的子路由列表中的第一个 ActivatedRoute|
|children|包含当前路由下所有已激活的子路由|

### 路由事件

 * 在每次导航周，Router 都会通过 Router.events 属性发布一些导航事件，这些事件的范围涵盖了从开始到导航结束之间的很多时间点，如下表：

|路由器事件|说明|
|--|--|
|NavigationStart|在导航开始时触发|
|RoutesRecognized|在路由器解析完 URL,并识别出相应的路由时触发|
|RouteConfigLoadStart|在 Router 对一个路由配置进行惰性加载之前触发|
|RouteConfigLoadEnd|在路由被惰性加载之后触发|
|NavigationEnd|在导航成功结束之后触发|
|NavigationCancel|在导航被取消之后触发，可能是因为在导航期间某个路由守卫返回了 false|
|NavigationError|在导航由于意外之外的错误而失败时触发|

### 小结

 * 对应用配置过一个路由器后，外壳组建中由一个 RouterOutlet，它能显示路由器所生成的试图，它还有一些 RouterLink，可以点击它们，来通过路由器进行导航
 * 路由器中的关键词汇及其含义如下表:

|路由器部件|含义|
|--|--|
|Router (路由器)|为激活的 URL 显示应用组件，管理从一个组建到另一个组建的导航|
|RouterModule|一个独立的 Angular 模块，用于提供多需的服务提供商，以及用来在应用视图之间进行导航的指令|
|Routes (路由数组)|定义了一个路由数组，每个都会把一个 URL 路径映射到一个组件 |
|Route (路由))|定义路由器该如何根据 URL 模式(pattern) 来导航到组建，大多数都由路径和组建类构成)|
|RouterOutlet (路由出口)|指令 (<router-outlet>) 用来标记该路由器在哪里显示视图|
|RouterLink (路由链接)|这个指令把可点击的 HTML 元素绑定到某个路由。点击带有 routerLink 的元素时就会触发一次导航|
|RouterLinkActive （活动路由链接）|当 HTML 元素上或元素内的 routerLink 变为激活或非激活状态时，该指令为这个 HTML 元素添加或移除 CSS 类|
|ActivatedRoute (激活的路由)|为每个路由组件提供的一个服务，包含特定于路由的信息，比如路由参数、静态数据、解析数据、全局查询参数和全局碎片 (fragment)|
|RouterState (路由器状态)|路由器的当前状态包括了一颗由程序中激活的路由构成的树，包含一些用于遍历路由树的快捷方法|
|链接参数数组|这个数组会被路由解析成一个路由操作指南。可以把一个 RouterLink 绑定到该数组，或者把它作为参数传给 Router.navigate 方法|
|路由组件|一个带有 RouterOutlet 的 Angular 组建，它根据路由器的导航来显示相应的视图|
