# 特性模块的分类

 * 模块特性有五个常用分类
    * 领域特性模块
    * 带路由的特性模块
    * 路由模块
    * 服务特性模块
    * 可视不见特性模块

模块特性每种类型的使用及其典型特征，实际使用中可以混合，如下表

| 特性模块 | 指导原则                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 领域     | 领域特性模块用来给用户提供应用程序领域中他有的用户体验，比如编辑客户信息或下订单等. <br> 它们通常会有一个顶级组件来充当该特性的根组件，并且通常是私有的，用来支持它的各级子组件. <br> 领域特性模块大部分由 declarations 组成，只有顶级组件会被导出. <br> 领域特性模块很少会有服务提供商，如果有，哪么这些服务的生命周期必须和该模块的生命周期完全相同. <br> 领域特性模块通常会由更高一级的特性模块导出且只能导出一次. <br> 对于缺少路由的小型应用，它们可能只会被根模块 AppModule 导入一次                                                                                                                                                                                                                                                                                        |
| 路由     | 带路由的特性模块是一种特殊的领域特性模块，但它的顶层组件会作为路由导航时的目标组件. <br> 根据这个定义，所有惰性加载的模块都是路由特性模块. <br> 带路由的特性模块不会带出任何东西，因为它们的组件永远不会出现在外部组件的模版中. <br> 惰性假造的路由特性模块必须被其它模块导入，如果那样做就会导致它被立即加载，破坏了惰性加载的设计用途，也就是说你应该永远不会看到它们在 AppModule 的 imports 中被引用，立即加载的路由特性模块很少会被其它模块导入，以便编译器能了解它所包含的组件. <br> 路由特性模块很好会有服务提供商，因为如果那样，那么它所提供的服务的生命周期必须与该模块的声明周期完全相同，不要在路由特性模块或被路由特性模块所导入的模块中提供全应用级的单例服务                                                                                                        |
| 路由     | 路由模块为其它模块提供路由配置，并且版路由这个关注点从它的配置模块中分离出来，路由模块通常会做下面一些事情：<br> 1.定义路由 <br> 2.把路由配置添加到该模块的 imports 中 <br> 3.把路由守卫和解析器的服务提供商添加 到该模块的 providers 中 <br> 4.路由模块应该与其配套模块同名，但是加上 Routing 后缀，比如，foo.module.ts 中的 FooModule 就有一个位于 foo-routing.module.ts 文件中 FooRoutingModule 路由模块，如果其配套模块是根模块 AppModule, AppRoutingModule 就要使用 RouterModule.forRoot(routes) 来把路由器配置添加到它的 imports 中，所有其它路由模块都是子模块，要使用 RouterModule.forChild(routes) <br> 5.按照惯例，路由模块后重新导出这个 RouterModule，以便其配套模块中的组件可以访问路由器指令，比如 RouterLink 和 RouterOutlet <br> 路由模块值应该被它的配套模块导入 |
| 窗口部件 | 窗口不见模块为外部模块提供组件、指令、管道，很多第三方 UI组件库都是窗口不见模块 <br> 窗口部件模块应该完全由可声明对象组成，它们中的大部分都应该被导出 <br> 窗口不见模块很少会有服务提供商 <br> 如果任何模块的组件模块中需要用到这些窗口部件，就请导入响应的窗口部件模块                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |


下表为各种特性模块类型的关键特征

|特性模块|声明 declarations|提供商 providers|导出什么|被谁导入|
|--|--|--|--|--|
|领域|有|罕见|顶级组件|特性模块，AppModule|
|路由|有|罕见|无|无|
|路由|无|是（守卫）|RouterModule|特性（供路由使用）|
|服务|无|有|无|AppModule|
|窗口部件|有|罕见|有|特性|