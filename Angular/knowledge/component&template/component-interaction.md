# 组件交互

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [组件交互](#%E7%BB%84%E4%BB%B6%E4%BA%A4%E4%BA%92)
    - [通过输入型绑定把数据从父组件传入到子组件](#%E9%80%9A%E8%BF%87%E8%BE%93%E5%85%A5%E5%9E%8B%E7%BB%91%E5%AE%9A%E6%8A%8A%E6%95%B0%E6%8D%AE%E4%BB%8E%E7%88%B6%E7%BB%84%E4%BB%B6%E4%BC%A0%E5%85%A5%E5%88%B0%E5%AD%90%E7%BB%84%E4%BB%B6)
    - [通过 setter 截听输入属性值的变化](#%E9%80%9A%E8%BF%87-setter-%E6%88%AA%E5%90%AC%E8%BE%93%E5%85%A5%E5%B1%9E%E6%80%A7%E5%80%BC%E7%9A%84%E5%8F%98%E5%8C%96)
    - [通过 ngOnChange()来截听输入属性值的变化](#%E9%80%9A%E8%BF%87-ngonchange%E6%9D%A5%E6%88%AA%E5%90%AC%E8%BE%93%E5%85%A5%E5%B1%9E%E6%80%A7%E5%80%BC%E7%9A%84%E5%8F%98%E5%8C%96)
    - [父组件监听子组件的事件](#%E7%88%B6%E7%BB%84%E4%BB%B6%E7%9B%91%E5%90%AC%E5%AD%90%E7%BB%84%E4%BB%B6%E7%9A%84%E4%BA%8B%E4%BB%B6)
    - [父组件与子组件通过本地变量互动](#%E7%88%B6%E7%BB%84%E4%BB%B6%E4%B8%8E%E5%AD%90%E7%BB%84%E4%BB%B6%E9%80%9A%E8%BF%87%E6%9C%AC%E5%9C%B0%E5%8F%98%E9%87%8F%E4%BA%92%E5%8A%A8)
    - [父组件调用 @ViewChild()](#%E7%88%B6%E7%BB%84%E4%BB%B6%E8%B0%83%E7%94%A8-viewchild)
    - [父组件和子组件通过服务来通讯](#%E7%88%B6%E7%BB%84%E4%BB%B6%E5%92%8C%E5%AD%90%E7%BB%84%E4%BB%B6%E9%80%9A%E8%BF%87%E6%9C%8D%E5%8A%A1%E6%9D%A5%E9%80%9A%E8%AE%AF)

## 通过输入型绑定把数据从父组件传入到子组件

子组件

```ts
// app/hero-child.component.ts
import { Component, Input } from "@angular/core";

import { Hero } from "./hero";

@Component({
  selector: "app-hero-child",
  template: `
    <h3>{{hero.name}} says:</h3>
    <p>I, {{hero.name}}, am at your service, {{masterName}}.</p>
  `
})
export class HeroChildComponent {
  @Input()
  hero: Hero;
  @Input("master")
  masterName: string; // master 为别名，不建议
}
```

父组件

```ts
// app/hero-parent.component.ts
import { Component } from "@angular/core";

import { HEROES } from "./hero";

@Component({
  selector: "app-hero-parent",
  template: `
    <h2>{{master}} controls {{heroes.length}} heroes</h2>
    <app-hero-child *ngFor="let hero of heroes"
      [hero]="hero"
      [master]="master">
    </app-hero-child>
  `
})
export class HeroParentComponent {
  heroes = HEROES;
  master = "Master";
}
```

父组件 HeroParentComponent 把子组件的 HeroChildComponent 放到 \*ngFor 循环器中，把自己的 master 字符串属性绑定到子组件的 master 别名上，并把每个循环的 hero 实例绑定到子组件的 hero 属性

[Back TO TOC](#组件交互)

## 通过 setter 截听输入属性值的变化

- 使用一个输入属性的 setter，以拦截父组件中值的变化，并才去行动

子组件

```ts
import { Component, Input } from "@angular/core";

@Component({
  selector: "app-name-child",
  template: '<h3>"{{name}}"</h3>'
})
export class NameChildComponent {
  private _name = "";

  @Input()
  set name(name: string) {
    this._name = (name && name.trim()) || "<no name set>";
  }

  get name(): string {
    return this._name;
  }
}
```

父组件

```ts
import { Component } from "@angular/core";

@Component({
  selector: "app-name-parent",
  template: `
  <h2>Master controls {{names.length}} names</h2>
  <app-name-child *ngFor="let name of names" [name]="name"></app-name-child>
  `
})
export class NameParentComponent {
  // Displays 'Mr. IQ', '<no name set>', 'Bombasto'
  names = ["Mr. IQ", "   ", "  Bombasto  "];
}
```

子组件 NameChildComponent 的输入属性 name 上的这个 setter，会 trim 掉名字里的空格，并把空值替换成默认字符串

[Back TO TOC](#组件交互)

## 通过 ngOnChange()来截听输入属性值的变化

- 使用 OnChanges 生命周期钩子接口的 ngChanges() 方法来监测输入属性值的变化并作出回应
- 当需要检测多个、交互式输入属性的时候，本方法比用属性的 setter 更合适

子组件

```ts
import { Component, Input, OnChanges, SimpleChange } from "@angular/core";

@Component({
  selector: "app-version-child",
  template: `
    <h3>Version {{major}}.{{minor}}</h3>
    <h4>Change log:</h4>
    <ul>
      <li *ngFor="let change of changeLog">{{change}}</li>
    </ul>
  `
})
export class VersionChildComponent implements OnChanges {
  @Input()
  major: number;
  @Input()
  minor: number;
  changeLog: string[] = [];

  ngOnChanges(changes: { [propKey: string]: SimpleChange }) {
    let log: string[] = [];
    for (let propName in changes) {
      let changedProp = changes[propName];
      let to = JSON.stringify(changedProp.currentValue);
      if (changedProp.isFirstChange()) {
        log.push(`Initial value of ${propName} set to ${to}`);
      } else {
        let from = JSON.stringify(changedProp.previousValue);
        log.push(`${propName} changed from ${from} to ${to}`);
      }
    }
    this.changeLog.push(log.join(", "));
  }
}
```

父组件

```ts
import { Component } from "@angular/core";

@Component({
  selector: "app-version-parent",
  template: `
    <h2>Source code version</h2>
    <button (click)="newMinor()">New minor version</button>
    <button (click)="newMajor()">New major version</button>
    <app-version-child [major]="major" [minor]="minor"></app-version-child>
  `
})
export class VersionParentComponent {
  major = 1;
  minor = 23;

  newMinor() {
    this.minor++;
  }

  newMajor() {
    this.major++;
    this.minor = 0;
  }
}
```

VersionChildComponent 会监测输入属性 major 和 minor 的变化，并把这些变化编写成日志以报告这些变化。VersionParentComponent 提供 minor 和 major 值，把修改它们值的方法绑定到按钮上

[Back TO TOC](#组件交互)

## 父组件监听子组件的事件

- 子组件暴露一个 EventEmitter 属性，当事件发生时，子组件利用该属性 emits(向上弹射)事件。父组件绑定到这个事件属性，并在事件发生时作出回应
- 框架(Angular)把事件参数(用 $event 表示)传给事件处理方法，这个方法会处理

子组件

```ts
// 子组件的 EventEmitter 属性是一个输出属性，通常带有@Output 装饰器，就像在 VoterComponent 中看到的
// 点击按钮会触发 true 或 false(布尔型有效载荷)的事件
import { Component, EventEmitter, Input, Output } from "@angular/core";

@Component({
  selector: "app-voter",
  template: `
    <h4>{{name}}</h4>
    <button (click)="vote(true)"  [disabled]="didVote">Agree</button>
    <button (click)="vote(false)" [disabled]="didVote">Disagree</button>
  `
})
export class VoterComponent {
  @Input()
  name: string;
  @Output()
  voted = new EventEmitter<boolean>();
  didVote = false;

  vote(agreed: boolean) {
    this.voted.emit(agreed);
    this.didVote = true;
  }
}
```

父组件

```ts
// 父组件 VoteTakerComponent 绑定了一个事件处理器(onVoted())，用来响应子组件的事件($event)并更新一个计数器
import { Component } from "@angular/core";

@Component({
  selector: "app-vote-taker",
  template: `
    <h2>Should mankind colonize the Universe?</h2>
    <h3>Agree: {{agreed}}, Disagree: {{disagreed}}</h3>
    <app-voter *ngFor="let voter of voters"
      [name]="voter"
      (voted)="onVoted($event)">
    </app-voter>
  `
})
export class VoteTakerComponent {
  agreed = 0;
  disagreed = 0;
  voters = ["Mr. IQ", "Ms. Universe", "Bombasto"];

  onVoted(agreed: boolean) {
    agreed ? this.agreed++ : this.disagreed++;
  }
}
```
[Back TO TOC](#组件交互)

## 父组件与子组件通过本地变量互动

- 父组件不能使用数据绑定来读取子组件的属性或调用子组件的方法。但可以在父组件模板里，新建一个本地变量来代表子组件，然后利用这个变量来读取子组件的属性和调用子组件的方法

子组件

```ts
// 子组件 CountdownTimerComponent 进行倒计时，归零时发射一个导弹。start 和 stop 方法负责控制时钟并在模板里显示倒计时的状态信息
import { Component, OnDestroy, OnInit } from "@angular/core";

@Component({
  selector: "app-countdown-timer",
  template: "<p>{{message}}</p>"
})
export class CountdownTimerComponent implements OnInit, OnDestroy {
  intervalId = 0;
  message = "";
  seconds = 11;

  clearTimer() {
    clearInterval(this.intervalId);
  }

  ngOnInit() {
    this.start();
  }
  ngOnDestroy() {
    this.clearTimer();
  }

  start() {
    this.countDown();
  }
  stop() {
    this.clearTimer();
    this.message = `Holding at T-${this.seconds} seconds`;
  }

  private countDown() {
    this.clearTimer();
    this.intervalId = window.setInterval(() => {
      this.seconds -= 1;
      if (this.seconds === 0) {
        this.message = "Blast off!";
      } else {
        if (this.seconds < 0) {
          this.seconds = 10;
        } // reset
        this.message = `T-${this.seconds} seconds and counting`;
      }
    }, 1000);
  }
}
```

父组件

```ts
import { Component } from "@angular/core";
import { CountdownTimerComponent } from "./countdown-timer.component";

@Component({
  selector: "app-countdown-parent-lv",
  template: `
  <h3>Countdown to Liftoff (via local variable)</h3>
  <button (click)="timer.start()">Start</button>
  <button (click)="timer.stop()">Stop</button>
  <div class="seconds">{{timer.seconds}}</div>
  <app-countdown-timer #timer></app-countdown-timer>
  `,
  styleUrls: ["../assets/demo.css"]
})
export class CountdownLocalVarParentComponent {}
```

父组件不能通过数据绑定使用子组件的 start 和 stop 方法，也不能访问子组件的 seconds 属性。

把本地变量(#timer)放到(<countdown-timer>)标签中，用来代表子组件。这样父组件的模板就得到了子组件的引用，于是可以在父组件的模板中访问子组件的所有属性和方法。

这个例子把父组件的按钮绑定到子组件的 start 和 stop 方法，并用插值表达式来显示子组件的 seconds 属性。

[Back TO TOC](#组件交互)

## 父组件调用 @ViewChild()

- 当父组件需要读取子组件的属性值或调用子组件的方法，可以把子组件作为 ViewChild，注入到父组件里面

父组件

```ts
import { AfterViewInit, ViewChild } from "@angular/core";
import { Component } from "@angular/core";
import { CountdownTimerComponent } from "./countdown-timer.component";

@Component({
  selector: "app-countdown-parent-vc",
  template: `
  <h3>Countdown to Liftoff (via ViewChild)</h3>
  <button (click)="start()">Start</button>
  <button (click)="stop()">Stop</button>
  <div class="seconds">{{ seconds() }}</div>
  <app-countdown-timer></app-countdown-timer>
  `,
  styleUrls: ["../assets/demo.css"]
})
export class CountdownViewChildParentComponent implements AfterViewInit {
  @ViewChild(CountdownTimerComponent)
  private timerComponent: CountdownTimerComponent;

  seconds() {
    return 0;
  }

  ngAfterViewInit() {
    // Redefine `seconds()` to get from the `CountdownTimerComponent.seconds` ...
    // but wait a tick first to avoid one-time devMode
    // unidirectional-data-flow-violation error
    setTimeout(() => (this.seconds = () => this.timerComponent.seconds), 0);
  }

  start() {
    this.timerComponent.start();
  }
  stop() {
    this.timerComponent.stop();
  }
}
```

- 子组件视图插入到服组件类步骤
  - ViewChild 装饰器导入这个引用，并挂上 AfterViewInit 生命周期钩子
  - 通过 @ViewChild 属性装饰器，将子组件 CountdownTimerComponent 注入到私有属性 timerComponent 里面
  - ngAfterViewInit() 生命周期钩子是非常重要的一步。被注入的计时器组件只有在 Angular 显示了父组件视图之后才能访问

[Back TO TOC](#组件交互)

## 父组件和子组件通过服务来通讯

- 父组件和它的子组件共享一个服务，利用该服务在家庭内部实现双向通讯
- 该服务实例的作用域被限制在父组件和其子组件内，这个组件树之外的组件将无法访问改服务或者与它们通信

服务

- 这个 MissionService 把 MissionControlComponent 和多个 AstronautComponent 子组件连接起来

```ts
import { Injectable } from "@angular/core";
import { Subject } from "rxjs";

@Injectable()
export class MissionService {
  // Observable string sources
  private missionAnnouncedSource = new Subject<string>();
  private missionConfirmedSource = new Subject<string>();

  // Observable string streams
  missionAnnounced$ = this.missionAnnouncedSource.asObservable();
  missionConfirmed$ = this.missionConfirmedSource.asObservable();

  // Service message commands
  announceMission(mission: string) {
    this.missionAnnouncedSource.next(mission);
  }

  confirmMission(astronaut: string) {
    this.missionConfirmedSource.next(astronaut);
  }
}
```

父组件

- MissionControlComponent 提供服务的实例，并将其共享给它的子组件(通过 providers 元数据数组)，子组件可以通过构造函数将该实例注入到自身

```ts
import { Component } from "@angular/core";

import { MissionService } from "./mission.service";

@Component({
  selector: "app-mission-control",
  template: `
    <h2>Mission Control</h2>
    <button (click)="announce()">Announce mission</button>
    <app-astronaut *ngFor="let astronaut of astronauts"
      [astronaut]="astronaut">
    </app-astronaut>
    <h3>History</h3>
    <ul>
      <li *ngFor="let event of history">{{event}}</li>
    </ul>
  `,
  providers: [MissionService]
})
export class MissionControlComponent {
  astronauts = ["Lovell", "Swigert", "Haise"];
  history: string[] = [];
  missions = ["Fly to the moon!", "Fly to mars!", "Fly to Vegas!"];
  nextMission = 0;

  constructor(private missionService: MissionService) {
    missionService.missionConfirmed$.subscribe(astronaut => {
      this.history.push(`${astronaut} confirmed the mission`);
    });
  }

  announce() {
    let mission = this.missions[this.nextMission++];
    this.missionService.announceMission(mission);
    this.history.push(`Mission "${mission}" announced`);
    if (this.nextMission >= this.missions.length) {
      this.nextMission = 0;
    }
  }
}
```

子组件

- AstronautComponent 也通过自己的构造函数注入该服务。由于每个 AstronautComponent 都是 MissionControlComponent 的子组件，所以它们获取到的也是父组件的这个服务实例

```ts
import { Component, Input, OnDestroy } from "@angular/core";

import { MissionService } from "./mission.service";
import { Subscription } from "rxjs";

@Component({
  selector: "app-astronaut",
  template: `
    <p>
      {{astronaut}}: <strong>{{mission}}</strong>
      <button
        (click)="confirm()"
        [disabled]="!announced || confirmed">
        Confirm
      </button>
    </p>
  `
})
export class AstronautComponent implements OnDestroy {
  @Input()
  astronaut: string;
  mission = "<no mission announced>";
  confirmed = false;
  announced = false;
  subscription: Subscription;

  constructor(private missionService: MissionService) {
    this.subscription = missionService.missionAnnounced$.subscribe(mission => {
      this.mission = mission;
      this.announced = true;
      this.confirmed = false;
    });
  }

  confirm() {
    this.confirmed = true;
    this.missionService.confirmMission(this.astronaut);
  }

  ngOnDestroy() {
    // prevent memory leak when component destroyed
    this.subscription.unsubscribe();
  }
}
```
[Back TO TOC](#组件交互)
