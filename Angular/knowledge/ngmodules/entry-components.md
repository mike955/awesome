# 入口文件


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
- [入口文件](#%E5%85%A5%E5%8F%A3%E6%96%87%E4%BB%B6)
    - [引导用的入口组件](#%E5%BC%95%E5%AF%BC%E7%94%A8%E7%9A%84%E5%85%A5%E5%8F%A3%E7%BB%84%E4%BB%B6)
    - [路由到入口组件](#%E8%B7%AF%E7%94%B1%E5%88%B0%E5%85%A5%E5%8F%A3%E7%BB%84%E4%BB%B6)
    - [entryComponents 数组](#entrycomponents-%E6%95%B0%E7%BB%84)
        - [entryComponents 和编译器](#entrycomponents-%E5%92%8C%E7%BC%96%E8%AF%91%E5%99%A8)

 * 从分类上来说，入口组件是 Angular 命令式加载的任意组件(也就是说你没有在模块中引种过它)，你可以在 NgModule 中引导它，或把它包含在路由中来指定入口组件
    * 组件被包含在模版中，它们是声明式的
    * 组件不是被包含在模版中，使用命令式加载它，这就是入口组件
 * 入口组件有两种主要类型
    * 引导用的根组件
    * 在路由定义中指定的组件

## 引导用的入口组件

 * 可引导组件是一个入口组件，Angular 会在引导过程中把它加载到 DOM 中，其它入口组件是在其它时机动态加载的，比如路由器
 * 引导用的组件必须是入口组件，因为引导过程是命令式的，所以它需要一个入口组件

```ts
// 指定一个引导用组件 AppComponent
@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent] // bootstrapped entry component
})
```
Angular 会动态加载根组件 AppComponent，因为它的类型作为参数传给了 @NgModule.bootstrap 函数

## 路由到入口组件

 * 入口组件的第二种类型出现在路由定义中
 * 所有的路由组件都必须是入口组件

```ts
const routes: Routes = [
  {
    path: '',
    component: CustomerListComponent
  }
];
```

## entryComponents 数组

 * @NgModule 修饰器具有一个 entryComponents 数组，大多数情况下你不用显示设置入口组件，因为 Angular 会自动把 @ngModule.bootstrap 中的组件以及路由定义中的组件添加到入口组件中

### entryComponents 和编译器

 * Angular 编译器只会为那些可以从 entryComponents 中直接或间接访问到的组件生成代码