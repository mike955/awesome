# Angular依赖注入

 * 依赖注入时用来创建对象及其依赖的其它对象的一种方式
 * 当依赖注入系统创建某个对象实例时，会负责提供该对象所依赖的对象（称为该对象的依赖）


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- /code_chunk_output -->

- [Angular依赖注入](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)
    - [创建一个可注入的 HeroService](#%E5%88%9B%E5%BB%BA%E4%B8%80%E4%B8%AA%E5%8F%AF%E6%B3%A8%E5%85%A5%E7%9A%84-heroservice)
    - [注入器](#%E6%B3%A8%E5%85%A5%E5%99%A8)
    - [@Injectable 的 providers 数组](#injectable-%E7%9A%84-providers-%E6%95%B0%E7%BB%84)
        - [@NgModule 中的 providers](#ngmodule-%E4%B8%AD%E7%9A%84-providers)
        - [在组件中注册提供商](#%E5%9C%A8%E7%BB%84%E4%BB%B6%E4%B8%AD%E6%B3%A8%E5%86%8C%E6%8F%90%E4%BE%9B%E5%95%86)
        - [@Injectable、@NgModule、@Component](#injectable%E3%80%81ngmodule%E3%80%81component)
    - [服务的提供商们](#%E6%9C%8D%E5%8A%A1%E7%9A%84%E6%8F%90%E4%BE%9B%E5%95%86%E4%BB%AC)
        - [把类作为它自己的提供商](#%E6%8A%8A%E7%B1%BB%E4%BD%9C%E4%B8%BA%E5%AE%83%E8%87%AA%E5%B7%B1%E7%9A%84%E6%8F%90%E4%BE%9B%E5%95%86)
        - [provide 对象字面量](#provide-%E5%AF%B9%E8%B1%A1%E5%AD%97%E9%9D%A2%E9%87%8F)
        - [备选的类提供商](#%E5%A4%87%E9%80%89%E7%9A%84%E7%B1%BB%E6%8F%90%E4%BE%9B%E5%95%86)
        - [带依赖的类提供商](#%E5%B8%A6%E4%BE%9D%E8%B5%96%E7%9A%84%E7%B1%BB%E6%8F%90%E4%BE%9B%E5%95%86)
        - [别名类提供商](#%E5%88%AB%E5%90%8D%E7%B1%BB%E6%8F%90%E4%BE%9B%E5%95%86)
        - [值提供商](#%E5%80%BC%E6%8F%90%E4%BE%9B%E5%95%86)
        - [工厂提供商](#%E5%B7%A5%E5%8E%82%E6%8F%90%E4%BE%9B%E5%95%86)
        - [可以被摇树优化的提供商](#%E5%8F%AF%E4%BB%A5%E8%A2%AB%E6%91%87%E6%A0%91%E4%BC%98%E5%8C%96%E7%9A%84%E6%8F%90%E4%BE%9B%E5%95%86)
    - [注入某个服务](#%E6%B3%A8%E5%85%A5%E6%9F%90%E4%B8%AA%E6%9C%8D%E5%8A%A1)
    - [单例服务](#%E5%8D%95%E4%BE%8B%E6%9C%8D%E5%8A%A1)
    - [组件的子注入器](#%E7%BB%84%E4%BB%B6%E7%9A%84%E5%AD%90%E6%B3%A8%E5%85%A5%E5%99%A8)
    - [测试组件](#%E6%B5%8B%E8%AF%95%E7%BB%84%E4%BB%B6)
    - [当服务需要别的服务时](#%E5%BD%93%E6%9C%8D%E5%8A%A1%E9%9C%80%E8%A6%81%E5%88%AB%E7%9A%84%E6%9C%8D%E5%8A%A1%E6%97%B6)
    - [依赖注入令牌](#%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5%E4%BB%A4%E7%89%8C)
        - [非类依赖](#%E9%9D%9E%E7%B1%BB%E4%BE%9D%E8%B5%96)
    - [可选依赖](#%E5%8F%AF%E9%80%89%E4%BE%9D%E8%B5%96)

## 创建一个可注入的 HeroService

```ts
// app/heroes/hero.service.ts
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class HeroService {
  constructor() { }
}
```

修改成如下代码

```ts
// src/app/heroes/hero.service.3.ts
import { Injectable } from '@angular/core';
import { HEROES }     from './mock-heroes';

@Injectable({
  // we declare that this service should be created
  // by the root application injector.

  providedIn: 'root',
})
export class HeroService {
  getHeroes() { return HEROES; }
}
```
@Injectable 修饰器时定义每个Angular 服务时的必备部分，把该类的其它部分改写为暴露一个方法

[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

## 注入器

 * 服务类注册进依赖注入器(injector)之前，是一个普通的类
 * Angular 的依赖注入器负责创建服务的实例，并把它们注入到像 HeroListComponent 这样的类中

## @Injectable 的 providers 数组

 * @Injectable 装饰器会指出这些服务或其它类是用来注入的，并且还能用于为这些服务提供配置项

使用类上的 @Injectable 修饰器为 HeroService 配置一个提供商

```ts
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class HeroService {
  constructor() { }
}
```
providedIn 告诉 Angular，它的根注入器要负责调用 HeroService 类的构造函数来创建一个实例，并让它在整个应用中都时可用的


@Injectable 修饰器用来配置一个服务提供商，它可以用在任何包含了 HeroModule 的注入器中
```ts
// /app/heroes/hero.service.ts

import { Injectable } from '@angular/core';
import { HeroModule } from './hero.module';
import { HEROES }     from './mock-heroes';

@Injectable({
  // we declare that this service should be created
  // by any injector that includes HeroModule.

  providedIn: HeroModule,
})
export class HeroService {
  getHeroes() { return HEROES; }
}
```
[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

### @NgModule 中的 providers

下面的代码中 AppModule 在自己的 providers 数组中注册了两个提供商

```ts
// /app/app.module.ts (providers)
providers: [
  UserService,  
  { provide: APP_CONFIG, useValue: HERO_DI_CONFIG }
],
```
第一条使用 UserService 这个注入令牌 (injection token) 注册了 UserService 类
第二条使用 APP_CONFIG 这个注入令牌注册了一个值 (HERO_DI_CONFIG)
通过这两条注册语句，Angualr 可以向它创建的任何类中注册 UserService 或 HERO_DI_CONFIG

[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

### 在组件中注册提供商

 * 除了提供给全应用级或特定的 @NgModule 中之外，服务还可以提供给指定的组件，在组件级提供的服务职能只能在改组件及其子组件的注入器中使用

下面的代码中，HeroesComponent 组件在自己的 providers 数组中注册了 HeroService

```ts
// app/heroes/heroes.component.ts

import { Component } from '@angular/core';
import { HeroService } from './hero.service';

@Component({
  selector: 'app-heroes',
  providers: [ HeroService ],
  template: `
    <h2>Heroes</h2>
    <app-hero-list></app-hero-list>
  `
})
export class HeroesComponent { }
```
[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

### @Injectable、@NgModule、@Component

 * @Injectable、@NgModule、@Component的区别在于最终的打包体积、服务的范围和服务的生命周期
 * 在服务本身的 @Injectable 中注册提供商时，优化可以执行摇树优化，移除所有没有在应用中使用过的服务。打包体积更小
 * 组件提供商(@Component)会注册到每个组件实例自己的注入器上，Angular 只能在该组件机器各级子组件的实例上注入这个服务，不能在其它地方注入这个服务实例；由组件提供的服务具有有限的生命周期，组件的每个服务都会有自己的服务实例，当组件实例被销毁时，服务的实例也会被销毁
 * Angular 模块中的 providers (@NgModule) 是注册在应用的根注入器下的，所以 Angular 可以往它所创建的任何类中注入相应的服务，一旦创建，服务的实例就会存在与改应用的全部生存期中，Angular 会把这一个服务实例注入到需求它的每个类中

[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

## 服务的提供商们

### 把类作为它自己的提供商

 * 服务需要一个提供商

```ts
// Logger 是一个对象，是一个类
providers: [Logger]
```
[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

### provide 对象字面量

```ts
// 下面两种形式等价
providers: [Logger]
[{ provide: Logger, useClass: Logger }]

// 对于上面的第二种形式，provide 属性保存的时令牌(token),它作为键值使用，用于定位依赖值和注册提供商
// 第二个时一个提供商定义对象
```
[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

### 备选的类提供商

 * 有时候，你会请求一个不同的类来提供服务

```ts
// 下面代码告诉注入器，有人请求 Logger 时，返回 BetterLogger
[{ provide: Logger, useClass: BetterLogger }]
```
[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

### 带依赖的类提供商

假设 EventBetterLogger 可以在日志消息中显示用户名，这个日志服务从注入的 UserService 中取得用户，UserService 通常也会在应用级注入

```ts
@Injectable()
export class EvenBetterLogger extends Logger {
  constructor(private userService: UserService) { super(); }

  log(message: string) {
    let name = this.userService.user.name;
    super.log(`Message to ${name}: ${message}`);
  }
}

// 配置
[ UserService,
  { provide: Logger, useClass: EvenBetterLogger }]
```
[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

### 别名类提供商

 * 给提供商起别名

```ts
[ NewLogger,
  // Alias OldLogger w/ reference to NewLogger
  { provide: OldLogger, useExisting: NewLogger}]
```
[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

### 值提供商

 * 将一个预先做好的对象作为提供商
定义对象
```ts
// An object in the shape of the logger service
export function SilentLoggerFn() {}

const silentLogger = {
  logs: ['Silent logger says "Shhhhh!". Provided via "useValue"'],
  log: SilentLoggerFn
};
```

使用对象
```ts
[{ provide: Logger, useValue: silentLogger }]
```
[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

### 工厂提供商

 * 当需要动态创建依赖值和注入的服务没法通过独立的源访问此信息时，使用工厂提供商

HeroService 的构造函数带上一个布尔型的标志，来控制是否显示隐藏的英雄，你可以注入 Logger，但不能注入逻辑型的isAuthorized，因此你需要通过工厂提供商创建这个 HeroServce 的新实例
```ts
// hero.service.ts (excerpt)
constructor(
  private logger: Logger,
  private isAuthorized: boolean) { }

getHeroes() {
  let auth = this.isAuthorized ? 'authorized ' : 'unauthorized';
  this.logger.log(`Getting heroes for ${auth} user.`);
  return HEROES.filter(hero => this.isAuthorized || !hero.isSecret);
}
```

工厂提供商需要一个工厂方法

```ts
// hero.service.provider.ts
let heroServiceFactory = (logger: Logger, userService: UserService) => {
  return new HeroService(logger, userService.user.isAuthorized);
};
```

HeroService 不能访问 UserService,但是工厂方法可以，把 Logger 和 UserService 注入到工厂提供商中，并且让注入器把它们传给工厂方法

```ts
// app/heroes/hero.service.provider.ts
export let heroServiceProvider =
  { provide: HeroService,
    useFactory: heroServiceFactory,
    deps: [Logger, UserService]
  };
```
UseFactory 字段告诉 Angular：这个提供商是一个工程方法

[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

### 可以被摇树优化的提供商

 * 摇树优化可以在最终打包时移除应用中从未引用过的代码
 * 要想创建可摇树优化的服务提供商，那些原本要通过模块来指定的信息就要改为在服务自身的 @Injectable 修饰器中提供

[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

## 注入某个服务

 * HeroListComponent 应该从 HeroService 中获取这些英雄，但是不应该使用 new 来创建 HeroService，而是应该注入 HeroService
 * 可以通过在构造函数中添加一个带有该依赖类型的参数来要求 Angular 把这个依赖注入到组件的构造函数中

下面是 HeroListComponent的构造函数，它要求注入 HeroService
```ts
constructor(heroService: HeroService)
```

使用 DI 的代码
```ts
// hero-list.component (with DI)
import { Component }   from '@angular/core';
import { Hero }        from './hero';
import { HeroService } from './hero.service';

@Component({
  selector: 'app-hero-list',
  template: `
    <div *ngFor="let hero of heroes">
      {{hero.id}} - {{hero.name}}
    </div>
  `
})
export class HeroListComponent {
  heroes: Hero[];

  constructor(heroService: HeroService) {
    this.heroes = heroService.getHeroes();
  }
}
```

没有使用 DI 的代码
```ts
// hero-list.component (without DI)
import { Component }   from '@angular/core';
import { HEROES }      from './mock-heroes';

@Component({
  selector: 'app-hero-list',
  template: `
    <div *ngFor="let hero of heroes">
      {{hero.id}} - {{hero.name}}
    </div>
  `
})
export class HeroListComponent {
  heroes = HEROES;
}
```
HeroListComponent 并不知道 HeroService 来自哪里

[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

## 单例服务

 * 服务在每个注入器的范围内是单例的
 * 任何一个注入器中，最多只会有同一个服务的一个实例
 * Angular 是一个多级注入系统，各级注入器可以创建它们自己的服务实例

[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

## 组件的子注入器

 * 组件注入器是彼此对立的，每一个都会为组件提供的服务创建单独的实例
 * 当 Angular 创建一个带有 @Component.provicers 的组件实例时，也会同时为这个实例创建一个新的子注入器
 * 当 Angular 销毁某个组件实例时，也会销毁改组件的注入器，以及该注入器中的服务实例
 * Angular 是多层注入器，可以把全应用级的服务注入到组件中，比如，Angular 可以把由 HeroComponent 提供的 HeroService 和由 AppModule 提供的 UserService 注入到 HeroService 中

[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

## 测试组件

## 当服务需要别的服务时

 * 同样用构造函数注入模式注入服务

```ts
import { Injectable } from '@angular/core';
import { HEROES }     from './mock-heroes';
import { Logger }     from '../logger.service';

@Injectable({
  providedIn: 'root',
})
export class HeroService {

  constructor(private logger: Logger) {  }

  getHeroes() {
    this.logger.log('Getting heroes ...');
    return HEROES;
  }
}
```
[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

## 依赖注入令牌

 * 当向注入器注入提供商时，实际上时把这个提供商和一个 DI 令牌关联起来了
 * 注入器委会一个内部的令牌-提供商映射表，这个映射表会在请求依赖时被引用到，令牌就是这个映射表总的键值

[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

### 非类依赖

 * 当要注入的依赖不是类时，使用值提供商来注册一个对象

[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)

## 可选依赖

 * 使用参数 null

```ts
constructor(@Inject(Token, null));
```
[Back To TOC](#angular%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)