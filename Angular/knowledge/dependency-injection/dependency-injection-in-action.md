# DI 实用技巧

---

- [DI 实用技巧](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)
    - [依赖注入](#%E4%BE%9D%E8%B5%96%E6%B3%A8%E5%85%A5)
    - [应用程序全局依赖](#%E5%BA%94%E7%94%A8%E7%A8%8B%E5%BA%8F%E5%85%A8%E5%B1%80%E4%BE%9D%E8%B5%96)
    - [外部模块配置](#%E5%A4%96%E9%83%A8%E6%A8%A1%E5%9D%97%E9%85%8D%E7%BD%AE)
    - [@Injectable 和嵌套服务依赖](#injectable-%E5%92%8C%E5%B5%8C%E5%A5%97%E6%9C%8D%E5%8A%A1%E4%BE%9D%E8%B5%96)
        - [@Injectable()注释](#injectable%E6%B3%A8%E9%87%8A)
    - [把服务作用域限制到一个组件支树](#%E6%8A%8A%E6%9C%8D%E5%8A%A1%E4%BD%9C%E7%94%A8%E5%9F%9F%E9%99%90%E5%88%B6%E5%88%B0%E4%B8%80%E4%B8%AA%E7%BB%84%E4%BB%B6%E6%94%AF%E6%A0%91)
    - [多个服务实例(sandboxing)](#%E5%A4%9A%E4%B8%AA%E6%9C%8D%E5%8A%A1%E5%AE%9E%E4%BE%8Bsandboxing)
    - [使用@Optional()和 Host()修饰器来限定依赖查找方式](#%E4%BD%BF%E7%94%A8optional%E5%92%8C-host%E4%BF%AE%E9%A5%B0%E5%99%A8%E6%9D%A5%E9%99%90%E5%AE%9A%E4%BE%9D%E8%B5%96%E6%9F%A5%E6%89%BE%E6%96%B9%E5%BC%8F)
    - [注入组件的 DOM 元素](#%E6%B3%A8%E5%85%A5%E7%BB%84%E4%BB%B6%E7%9A%84-dom-%E5%85%83%E7%B4%A0)
    - [使用提供商来定义依赖](#%E4%BD%BF%E7%94%A8%E6%8F%90%E4%BE%9B%E5%95%86%E6%9D%A5%E5%AE%9A%E4%B9%89%E4%BE%9D%E8%B5%96)
        - [定义提供商](#%E5%AE%9A%E4%B9%89%E6%8F%90%E4%BE%9B%E5%95%86)
    - [备选提供商令牌:类-接口和 InjectionToken](#%E5%A4%87%E9%80%89%E6%8F%90%E4%BE%9B%E5%95%86%E4%BB%A4%E7%89%8C%E7%B1%BB-%E6%8E%A5%E5%8F%A3%E5%92%8C-injectiontoken)
        - [类-接口](#%E7%B1%BB-%E6%8E%A5%E5%8F%A3)
        - [InjectionToken 值](#injectiontoken-%E5%80%BC)
    - [注入到派生类](#%E6%B3%A8%E5%85%A5%E5%88%B0%E6%B4%BE%E7%94%9F%E7%B1%BB)
    - [通过注入来找到一个父组件](#%E9%80%9A%E8%BF%87%E6%B3%A8%E5%85%A5%E6%9D%A5%E6%89%BE%E5%88%B0%E4%B8%80%E4%B8%AA%E7%88%B6%E7%BB%84%E4%BB%B6)
        - [找到已知类型的父组件](#%E6%89%BE%E5%88%B0%E5%B7%B2%E7%9F%A5%E7%B1%BB%E5%9E%8B%E7%9A%84%E7%88%B6%E7%BB%84%E4%BB%B6)
        - [无法通过它的基类找到一个父级](#%E6%97%A0%E6%B3%95%E9%80%9A%E8%BF%87%E5%AE%83%E7%9A%84%E5%9F%BA%E7%B1%BB%E6%89%BE%E5%88%B0%E4%B8%80%E4%B8%AA%E7%88%B6%E7%BA%A7)
        - [通过类-接口找到父组件](#%E9%80%9A%E8%BF%87%E7%B1%BB-%E6%8E%A5%E5%8F%A3%E6%89%BE%E5%88%B0%E7%88%B6%E7%BB%84%E4%BB%B6)
        - [通过父级树找到父组件](#%E9%80%9A%E8%BF%87%E7%88%B6%E7%BA%A7%E6%A0%91%E6%89%BE%E5%88%B0%E7%88%B6%E7%BB%84%E4%BB%B6)
        - [Parent 类-接口](#parent-%E7%B1%BB-%E6%8E%A5%E5%8F%A3)
        - [provideParent()助手函数](#provideparent%E5%8A%A9%E6%89%8B%E5%87%BD%E6%95%B0)

## 依赖注入

 * 依赖注入是一个用来管理代码的强大模式

## 应用程序全局依赖

 * 服务本身的 @Injectable() 修饰器中注册哪些被应用程序全局使用的依赖提供商
 * 提供商用来新建或者交付服务，Angular 拿到“类提供商”后，会通过 new 操作类新建服务实例

```ts
// app/heroes/hero.service.ts
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
上面代码中，providedIn 告诉 Angular，由根注入器负责创建 HeroService 的实例，所有用这种方式提供的服务，都会自动在整个应用中可用，而不用显示的引入
这类服务可以充当自己的提供商，只要你把它们定义在 @Injectable 修饰器中就算注册成功

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

## 外部模块配置

 - 如果某个提供商没有在服务的 @Injectable 修饰器中配置，则需要在根模块 AppModule 中把它注册为全应用级的提供商而不是在 AppComponent
 - 通常情况，应该在 NgModule 中注册提供商，而不是在应用程序根组件中
 - 有三种情况会使用外部模块配置
    - 当用户明确选择所有的服务时
    - 在惰性加载的上下文中提供该服务时
    - 在应用启动配置之前配置应用中的另一个全局服务时

```ts
// 使用外部配置 HashLocationStrategy
providers: [
  { provide: LocationStrategy, useClass: HashLocationStrategy }
]
```
[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

## @Injectable 和嵌套服务依赖

 * 被注入服务的消费者不需要知道如何创建这个服务，新建和缓存这个服务时依赖注入器的工作
 * 如果一个服务依赖其它服务，其它服务又依赖另外的服务，框架会按顺序解析这些嵌套的服务，依赖者只需要关系自己的构造函数中的声明，而不用关注它的依赖

```ts
// /app/app.component.ts
// 框架会帮你完成 UserContextService 服务的依赖工作
constructor(logger: LoggerService, public userContext: UserContextService) {
  userContext.loadUser(this.userId);
  logger.logInfo('AppComponent initialized');
}

// user-context.service.ts
@Injectable()
export class UserContextService {
  constructor(private userService: UserService, private loggerService: LoggerService) {
  }
}
```

### @Injectable()注释

 * @Injectable 修饰器会向 Angular DI 系统指明应该为 UserContextService 创建一个实例还是多个实例

```ts
@Injectable()
export class UserContextService {
}
```
[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

## 把服务作用域限制到一个组件支树

 * 所有被注入的服务依赖都是单例，在任意一个依赖注入器('injector')中，每个服务都只有唯一的实例
 * 被注入的服务时实例，一个服务被注入多个应用，互不影响
 * 一个组件中注入的服务依赖，会在该组件的所有子组件中可见，并且 Angular 会把同样的服务实例注入到需要该服务的子组件中
 * 在根部的 AppComponent 提供的依赖单例能被注入到应用程序中任何地方的任何组件
 * 通过在组件树的子级根组件中提供服务，可以把一个被注入服务的作用域限制在应用程序结构中的某个分支中

```ts
// 新建 HeroesBaseComponent 的时候，它会同时新建一个 HeroService 实例，该实例只在该组件及其子组件(如果有)中可见
@Component({
  selector: 'app-unsorted-heroes',
  template: `<div *ngFor="let hero of heroes">{{hero.name}}</div>`,
  providers: [HeroService]
})
export class HeroesBaseComponent implements OnInit {
  constructor(private heroService: HeroService) { }
}
```
[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

## 多个服务实例(sandboxing)

 * 在同一级别的组件树里，需要一个服务的多个实例时，每个组件应该有自己的状态，与其它服务和状态隔离，叫做沙箱化，每个服务和组件实例都在自己的沙箱里运行
 * 在每个组件自己的元数据(metadata)providers数组里面列出提供商，每个组件就能独立拥有自己的服务实例

```ts
// HeroBiosComponent 依赖多个 hero-bio 组件
@Component({
  selector: 'app-hero-bios',
  template: `
    <app-hero-bio [heroId]="1"></app-hero-bio>
    <app-hero-bio [heroId]="2"></app-hero-bio>
    <app-hero-bio [heroId]="3"></app-hero-bio>`,
  providers: [HeroService]
})
export class HeroBiosComponent {
}


// 在 hero-bio 组件中列出 注入的服务, 每个 hero-bio 会在自己的沙箱里运行
@Component({
  selector: 'app-hero-bio',
  template: `
    <h4>{{hero.name}}</h4>
    <ng-content></ng-content>
    <textarea cols="25" [(ngModel)]="hero.description"></textarea>`,
  providers: [HeroCacheService]
})

export class HeroBioComponent implements OnInit  {
  @Input() heroId: number;

  constructor(private heroCache: HeroCacheService) { }

  ngOnInit() { this.heroCache.fetchCachedHero(this.heroId); }

  get hero() { return this.heroCache.hero; }
}
```
[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

## 使用@Optional()和 Host()修饰器来限定依赖查找方式

 * 组件寻找依赖时会从自身开始沿着依赖注入器的树往上找，可以通过单独或联合使用 @Host 和 @Optional 限定型装饰器，修改 Angular 的查找行为
 * 当 Angular 找不到依赖时，@Optional 装饰器会告诉 Angular 继续执行。Angular 把此注入参数设置为 null(而不用默认的抛出错误的行为)
 * @Host 装饰器将把往上搜索的行为截止在宿主组件

```ts
@Component({
  selector: 'app-hero-contact',
  template: `
  <div>Phone #: {{phoneNumber}}
  <span *ngIf="hasLogger">!!!</span></div>`
})
export class HeroContactComponent {

  hasLogger = false;

  constructor(
      @Host() // limit to the host component's instance of the HeroCacheService
      private heroCache: HeroCacheService,

      @Host()     // limit search for logger; hides the application-wide logger
      @Optional() // ok if the logger doesn't exist
      private loggerService: LoggerService
  ) {
    if (loggerService) {
      this.hasLogger = true;
      loggerService.logInfo('HeroContactComponent can log!');
    }
  }

  get phoneNumber() { return this.heroCache.hero.phone; }

}
```
@Host 函数是 heroCache 属性的装饰器，确保从其父组件 HeroBioComponent 得到一个缓存服务，如果该父组件不存在这个服务，Angular 就会抛出错误，即使组件树里的再上级有某个组件拥有这个服务，Angular 也会抛出错误。

@Host() 函数是属性 loggerService 的装饰器。 在本应用程序中只有一个在 AppComponent 级提供的 LoggerService 实例。 该宿主 HeroBioComponent 没有自己的 LoggerService 提供商。

如果没有同时使用 @Optional() 装饰器的话，Angular 就会抛出错误。多亏了 @Optional()，Angular 把 loggerService 设置为 null，并继续执行组件而不会抛出错误。

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

## 注入组件的 DOM 元素
 
 * 修改一个组件对应的 DOM 元素

```ts
import { Directive, ElementRef, HostListener, Input } from '@angular/core';

@Directive({
  selector: '[appHighlight]'
})
export class HighlightDirective {

  @Input('appHighlight') highlightColor: string;

  private el: HTMLElement;

  constructor(el: ElementRef) {
    this.el = el.nativeElement;
  }

  @HostListener('mouseenter') onMouseEnter() {
    this.highlight(this.highlightColor || 'cyan');
  }

  @HostListener('mouseleave') onMouseLeave() {
    this.highlight(null);
  }

  private highlight(color: string) {
    this.el.style.backgroundColor = color;
  }
}
```
Angular 把构造函数参数 el 设置为注入的 ElementRef，该ElementRef代表了宿主的 DOM 元素，它的 nativeElement 属性把该 DOM 元素暴露给了指令

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

## 使用提供商来定义依赖

 * 在组件元数据中注入提供商

```ts
// 在该服务的 @Injectable 装饰器中，或在 NgModule 或 Directive 元数据的 providers 数组中注入提供商
providers: [ LoggerService, UserContextService, UserService ]

// 在组件中注入提供商
constructor(logger: LoggerService) {
  logger.logInfo('Creating HeroBiosComponent');
}
```

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

### 定义提供商

 * 建议直接在服务类的 @Injectable 修饰器中定义服务提供商
 * 备选在 @NgModule 的 provides 数组中引用类

```ts
// 在服务类中定义服务提供商
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root',
})
export class HeroService {
  constructor() { }
}

// 在 @NgModule 中引用类
providers: [HeroService]
```

下面带代码列出了提供商的一些用法
```ts
import { Component, Inject } from '@angular/core';

import { DateLoggerService } from './date-logger.service';
import { Hero }              from './hero';
import { HeroService }       from './hero.service';
import { LoggerService }     from './logger.service';
import { MinimalLogger }     from './minimal-logger.service';
import { RUNNERS_UP,
         runnersUpFactory }  from './runners-up';

@Component({
  selector: 'app-hero-of-the-month',
  templateUrl: './hero-of-the-month.component.html',
  providers: [  // provide对象需要一个令牌和一个定义 对象,令牌通常是一个类，但不一定；下面每个对象中 provide 的值是一个令牌，如 Hero
    { provide: Hero,          useValue:    someHero },          // 使用值提供商，需要立即定义
    { provide: TITLE,         useValue:   'Hero of the Month' },// 使用值提供商，需要立即定义
    { provide: HeroService,   useClass:    HeroService },       // 使用类提供商
    { provide: LoggerService, useClass:    DateLoggerService }, // 使用类提供商
    { provide: MinimalLogger, useExisting: LoggerService },     // 使用别名
    { provide: RUNNERS_UP,    useFactory:  runnersUpFactory(2), deps: [Hero, HeroService] } // 使用工厂提供商
  ]
})
export class HeroOfTheMonthComponent {
  logs: string[] = [];

  constructor(
      logger: MinimalLogger,
      public heroOfTheMonth: Hero,
      @Inject(RUNNERS_UP) public runnersUp: string,
      @Inject(TITLE) public title: string)
  {
    this.logs = logger.logs;
    logger.logInfo('starting up');
  }
}
```

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

## 备选提供商令牌:类-接口和 InjectionToken

 * Angular 依赖注入当令牌是类的时候最简单，该类同时也是返回的依赖对象的类型(通常称为服务)
 * 令牌不一定是类，即使是一个类，也不一定返回类型相同的对象

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

### 类-接口

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

### InjectionToken 值

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

## 注入到派生类

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

## 通过注入来找到一个父组件

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

### 找到已知类型的父组件

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

### 无法通过它的基类找到一个父级

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

### 通过类-接口找到父组件

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

### 通过父级树找到父组件

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

### Parent 类-接口

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)

### provideParent()助手函数

[Back To TOC](#di-%E5%AE%9E%E7%94%A8%E6%8A%80%E5%B7%A7)
