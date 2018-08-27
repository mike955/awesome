# 服务提供商

---
 * 服务提供商相当于说明书，用来指导 DI 系统该如何获取某个依赖的值，大多数情况下，这些依赖就是你要创建和提供的那些服务

## 提供服务

```ts
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',   // 指定该服务应该在根注入器中提供
})
export class UserService {
}
```
修饰器 @Injectable 用 providerIn 属性进行配置，它会为该服务创建一个提供商

## 提供商作用域

 * 如果把服务提供商添加到应用的根注入器中，它就能在整个应用程序中被使用，同时，这些服务提供商也同样对整个应用中的类是可用的(如果有服务令牌)
 * 应该始终在根注入器中提供这些服务

## providedIn 与 NgModule
