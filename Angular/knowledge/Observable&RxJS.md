# Observable 与 RxJS


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

- [Observable 与 RxJS](#observable-%E4%B8%8E-rxjs)
  - [可观察对象 (Observable)](#%E5%8F%AF%E8%A7%82%E5%AF%9F%E5%AF%B9%E8%B1%A1-observable)
    - [基本用法和词汇](#%E5%9F%BA%E6%9C%AC%E7%94%A8%E6%B3%95%E5%92%8C%E8%AF%8D%E6%B1%87)
    - [定义观察者](#%E5%AE%9A%E4%B9%89%E8%A7%82%E5%AF%9F%E8%80%85)
    - [订阅](#%E8%AE%A2%E9%98%85)
    - [创建可观察对象](#%E5%88%9B%E5%BB%BA%E5%8F%AF%E8%A7%82%E5%AF%9F%E5%AF%B9%E8%B1%A1)
    - [多播](#%E5%A4%9A%E6%92%AD)
    - [错误处理](#%E9%94%99%E8%AF%AF%E5%A4%84%E7%90%86)
  - [RxJS 库](#rxjs-%E5%BA%93)
    - [创建可观察对象的函数](#%E5%88%9B%E5%BB%BA%E5%8F%AF%E8%A7%82%E5%AF%9F%E5%AF%B9%E8%B1%A1%E7%9A%84%E5%87%BD%E6%95%B0)
    - [操作符](#%E6%93%8D%E4%BD%9C%E7%AC%A6)
      - [常用操作符](#%E5%B8%B8%E7%94%A8%E6%93%8D%E4%BD%9C%E7%AC%A6)
    - [错误处理](#%E9%94%99%E8%AF%AF%E5%A4%84%E7%90%86)
      - [重试失败的可观察对象](#%E9%87%8D%E8%AF%95%E5%A4%B1%E8%B4%A5%E7%9A%84%E5%8F%AF%E8%A7%82%E5%AF%9F%E5%AF%B9%E8%B1%A1)
    - [可观察对象的命名约定](#%E5%8F%AF%E8%A7%82%E5%AF%9F%E5%AF%B9%E8%B1%A1%E7%9A%84%E5%91%BD%E5%90%8D%E7%BA%A6%E5%AE%9A)
  - [Angular 中的可观察对象](#angular-%E4%B8%AD%E7%9A%84%E5%8F%AF%E8%A7%82%E5%AF%9F%E5%AF%B9%E8%B1%A1)
    - [事件发送器 EventEmitter](#%E4%BA%8B%E4%BB%B6%E5%8F%91%E9%80%81%E5%99%A8-eventemitter)
    - [HTTP](#http)
    - [Async 管道](#async-%E7%AE%A1%E9%81%93)
    - [路由器 (router)](#%E8%B7%AF%E7%94%B1%E5%99%A8-router)
    - [响应式表单(reactive forms)](#%E5%93%8D%E5%BA%94%E5%BC%8F%E8%A1%A8%E5%8D%95reactive-forms)
  - [用法实战](#%E7%94%A8%E6%B3%95%E5%AE%9E%E6%88%98)
    - [输入提示 (type-ahead) 建议](#%E8%BE%93%E5%85%A5%E6%8F%90%E7%A4%BA-type-ahead-%E5%BB%BA%E8%AE%AE)
    - [指数化退避](#%E6%8C%87%E6%95%B0%E5%8C%96%E9%80%80%E9%81%BF)
  - [与其它技术的比较](#%E4%B8%8E%E5%85%B6%E5%AE%83%E6%8A%80%E6%9C%AF%E7%9A%84%E6%AF%94%E8%BE%83)
    - [可观察对象vs.承诺](#%E5%8F%AF%E8%A7%82%E5%AF%9F%E5%AF%B9%E8%B1%A1vs%E6%89%BF%E8%AF%BA)
    - [可观察对象与承诺实现同样功能接口对比如下](#%E5%8F%AF%E8%A7%82%E5%AF%9F%E5%AF%B9%E8%B1%A1%E4%B8%8E%E6%89%BF%E8%AF%BA%E5%AE%9E%E7%8E%B0%E5%90%8C%E6%A0%B7%E5%8A%9F%E8%83%BD%E6%8E%A5%E5%8F%A3%E5%AF%B9%E6%AF%94%E5%A6%82%E4%B8%8B)

## 可观察对象 (Observable)

 * 可观察对象支持在应用中的发布者和订阅者之间传递消息
 * 可观察对象是声明式的，只有消费时才会被执行
 * 可观察对象可以发送多个任意类型的值 -- 字面量、消息、事件

### 基本用法和词汇

 * 创建一个 Observable 实例，实例会定义一个订阅者 (subscriber) 函数，当消费者调用 subscriber() 方法时，该函数会被执行，订阅者函数用于定义“如何获取或生成那些要发布的值或消息”
 * 从可观察对象中接收消息需要调用它的 subscriber() 方法，并传入一个观察者(observer)，observer 是一个 js 对象，定义接收消息的处理器(handler)
 * subscribe() 调用会返回一个 Subscription 对象，该对象具有一个 unsubscribe() 方法，调用该方法时，会停止接收通知

```ts
// 使用可观察对象对当前地理位置进行更新
// Create an Observable that will start listening to geolocation updates
// when a consumer subscribes.
const locations = new Observable((observer) => {
  // Get the next and error callbacks. These will be passed in when
  // the consumer subscribes.
  const {next, error} = observer;
  let watchId;

  // Simple geolocation API check provides values to publish
  if ('geolocation' in navigator) {
    watchId = navigator.geolocation.watchPosition(next, error);
  } else {
    error('Geolocation not available');
  }

  // When the consumer unsubscribes, clean up data ready for next subscription.
  return {unsubscribe() { navigator.geolocation.clearWatch(watchId); }};
});

// Call subscribe() to start listening for updates.
const locationsSubscription = locations.subscribe({
  next(position) { console.log('Current Position: ', position); },
  error(msg) { console.log('Error Getting Location: ', msg); }
});

// Stop listening for location after 10 seconds
setTimeout(() => { locationsSubscription.unsubscribe(); }, 10000);
```

### 定义观察者

 * 用于接收可观察对象通知的处理器要实现 Observer 接口，这个对象定义了一些毁掉函数来处理可观察对象可能会发来的三种通知
 * 观察者对象可以定义这三种处理器的任意组合，如果部位某种通知类型提供处理器，这个观察者就会忽略相应类型的通知

|通知类型|说明|
|--|--|
|next|必要，用于处理每个送达值，在开始执行后可能执行另次或多次|
|error|可选，用于处理错误通知，错误会终端这个可观察对象实例的执行过程|
|complete|可选，用与处理执行完毕(complete)通知)，当执行完毕后，这些值就会继续传给下一个处理器|

### 订阅

 * 只有 Observable 实例被订阅时，实例才会发布
 * 订阅时需要先调用该实例的 subscribe() 方法，并把一个观察者对象传给它，用来接收通知
 * Observable 由一个构造函数可以创建新实例
 * 下面使用 Observable 上定义的一些静态方法来爱创建一些常用的简单可观察对象：
    * Observable.of(...items) -- 返回一个 Observable 实例，它用同步的方法把参数中提供的这些值发送出来
    * Observable.from(iterable) -- 把它的参数转换成一个 Observable 实例，该方法通常用于把一个数组转换成一个（发送多个值的）可观察对象

```ts
// 创建并订阅一个简单的可观察对象，它的观察者会把接收到的消息记录到控制台
// create simple observable that emits three values
const myObservable = Observable.of(1,2,3);

// create observer object
const myObserver = {
    next: x => console.log('Observer got a next value: ' + x),
    error: err => console.log('Observer got an error:' + err),
    complete: () => console.log('Observer got a complete notification')
};

// Execute with the observer object
myObservable.subscribe(myObserver);
// Logs:
// Observer got a next value: 1
// Observer got a next value: 2
// Observer got a next value: 3
// Observer got a complete notificatio

// subscribe() 方法还可以接收定义在统一行中的回调函数，无论 next、error 还是 complete 处理器，比如，下面的 subscribe() 调用和前面指定预订义观察者的例子时等价的
myObservable.subscribe(
  x => console.log('Observer got a next value: ' + x),
  err => console.error('Observer got an error: ' + err),
  () => console.log('Observer got a complete notification')
);
```
next 处理器是必要的，而 error 和 complete 处理是可选的

next() 函数可以接收消息字符串、事件对象、数字值或各种结构，具体类型取决于上下文;可观察对象发布出来的数据统称为流

### 创建可观察对象

 * 使用 Observable 构造函数可以创建任何类型的可观察流
 * 执行可观察对象的 subscribe() 方法时，构造函数会把它接收到的参数作为订阅函数来运行，订阅函数会接收一个 Observer 对象，并把值发布给观察者的 next() 方法

```ts
// This function runs when subscribe() is called
function sequenceSubscriber(observer) {
  // synchronously deliver 1, 2, and 3, then complete
  observer.next(1);
  observer.next(2);
  observer.next(3);
  observer.complete();

  // unsubscribe function doesn't need to do anything in this
  // because values are delivered synchronously
  return {unsubscribe() {}};
}

// Create a new Observable that will deliver the above sequence
const sequence = new Observable(sequenceSubscriber);

// execute the Observable and print the result of each notification
sequence.subscribe({
  next(num) { console.log(num); },
  complete() { console.log('Finished sequence'); }
});

// Logs:
// 1
// 2
// 3
// Finished sequence
```
下面时一个加强例子，创建一个用来发布事件的可观察对象,订阅函数使用内联方式定义
```ts
// Create with custom fromEvent function
function fromEvent(target, eventName){
    return new Observable((observer) => {
        const handler = (e) => observer.next(e);

        // add the event handler to the target
        target.addEventListener(eventName, handler);

        return () => {
            // Detach the event handler from the target
            target.removeEventListener(eventName, handler);
        }
    })
}

// use custom fromEvent function
const ESC_KEY = 27;
const nameInput = document.getElementById('name) as HTMLInputElement;

const subscription = fromEvent(nameInput, 'keydown')
    .subscribe((e:keyboardEvent) => {
        if (e.keyCode === ESC_KEY) {
            nameInput.value = '';
        }
    })
```

### 多播

 * 典型的可观察对象会为每一个观察者创建一次新的、独立的执行当观察者进行订阅时，该观察者对象会连上一个事件处理器，并且向那个观察者发送一些值；当第二个观察者订阅时，这个可观察对象就会连上上一个新的事件处理器，并独立执行一次，把这些值发送给第二个可观察对象
 * 多播可以让观察者在一次执行中同时广播给多个订阅者，通过支持多播的可观察者对象，不用注册多个监听器，通过复用第一个(next)监听器，把值发给各个订阅者

```ts
function multicastSequenceSubscriber() {
  const seq = [1, 2, 3];
  // Keep track of each observer (one for every active subscription)
  const observers = [];
  // Still a single timeoutId because there will only ever be one
  // set of values being generated, multicasted to each subscriber
  let timeoutId;

  // Return the subscriber function (runs when subscribe()
  // function is invoked)
  return (observer) => {
    observers.push(observer);
    // When this is the first subscription, start the sequence
    if (observers.length === 1) {
      timeoutId = doSequence({
        next(val) {
          // Iterate through observers and notify all subscriptions
          observers.forEach(obs => obs.next(val));
        },
        complete() {
          // Notify all complete callbacks
          observers.slice(0).forEach(obs => obs.complete());
        }
      }, seq, 0);
    }

    return {
      unsubscribe() {
        // Remove from the observers array so it's no longer notified
        observers.splice(observers.indexOf(observer), 1);
        // If there's no more listeners, do cleanup
        if (observers.length === 0) {
          clearTimeout(timeoutId);
        }
      }
    };
  };
}

// Run through an array of numbers, emitting one value
// per second until it gets to the end of the array.
function doSequence(observer, arr, idx) {
  return setTimeout(() => {
    observer.next(arr[idx]);
    if (idx === arr.length - 1) {
      observer.complete();
    } else {
      doSequence(observer, arr, ++idx);
    }
  }, 1000);
}

// Create a new Observable that will deliver the above sequence
const multicastSequence = new Observable(multicastSequenceSubscriber());

// Subscribe starts the clock, and begins to emit after 1 second
multicastSequence.subscribe({
  next(num) { console.log('1st subscribe: ' + num); },
  complete() { console.log('1st sequence finished.'); }
});

// After 1 1/2 seconds, subscribe again (should "miss" the first value).
setTimeout(() => {
  multicastSequence.subscribe({
    next(num) { console.log('2nd subscribe: ' + num); },
    complete() { console.log('2nd sequence finished.'); }
  });
}, 1500);

// Logs:
// (at 1 second): 1st subscribe: 1
// (at 2 seconds): 1st subscribe: 2
// (at 2 seconds): 2nd subscribe: 2
// (at 3 seconds): 1st subscribe: 3
// (at 3 seconds): 1st sequence finished
// (at 3 seconds): 2nd subscribe: 3
// (at 3 seconds): 2nd sequence finished
```

### 错误处理

 * 因为可观察对象会异步生成值，所以 try/catch 无法捕获错误，因该在观察者中指定一个 error 回调来处理错误，发生错误时还会导致可观察对象清理现有的订阅，并且停止生成值;可观察对象可以生成值(调用next回调)，也可以调用 complete 或 error 回调来主动结束

```ts
myObservable.subscribe({
  next(num) { console.log('Next num: ' + num)},
  error(err) { console.log('Received an errror: ' + err)}
});
```

## RxJS 库

 * RxJS（响应式扩展的 JavaScript 版）是一个使用可观察对象进行响应式编程的库，RxJS 让组合异步代码和基于回调的代码变得更简单
 * RxJS 提供了一种对 Observable 类型的实现，直到 Observable 成为了 JavaScript 语言的一部分并且浏览器支持之前，它时由必要的，这个库还提供了一些工具函数，用于创建和使用可观察对象，这些工具可用于
    * 把现有的异步代码转换为可观察对象
    * 迭代流中的各个值
    * 把这些值映射成其它类型
    * 对流进行过流
    * 组合多个流

### 创建可观察对象的函数

 * RxJS 提供了一些函数创建可观察对象，这些函数可以简化创建可观察对象的过程，比如事件、定时器、承诺等

```ts
// Create an observable from a promise
import { fromPromise } from 'rxjs';

// create an Observable out of a promise
const data = fromPormise(fetch('/api/endpoint'));
//subscribe to begin listening for result
data.subscribe({
    next(response) {console.log(response);},
    error(err) {console.log('Error:' + err);},
    complete() {console.log('completed');}
});


// create an observable from a counter
import {interval} from 'rxjs';
// create an observable that will publish a value on an interval
const secondsCounter = interval(1000);
//subscribe to begin publishing values
secondsCounter.subscribe(n => {
    console.log(`it's been ${n} seconds since subscribing!`);
});


// create an observable from an event
import {fromEvent} from 'rxjs';
const el = document.getElementById('my-element')
// create an observable that publish mouse movemoments
const mouseMoves = fromEvent(el, 'mousemove');
// subscribe to start listening for mouse-moev events
const subscription = mouseMoves.subscribe((evt:MouseEvent) => {
    // log coords of mouse movements
    console.log(`coords: ${evt.clientX} X ${evt.clientY}`);
});
// when the mouse is over the upper-left of the screen
//unsubscribe to stop listening for mouse movements
if(evt.clientX < 40 && evt.clientY < 40){
    subscription.unsubscribe();
}

// Create an observable that creates an AJAX request
import { ajax } from 'rxjs/ajax';

// Create an Observable that will create an AJAX request
const apiData = ajax('/api/data');
// Subscribe to create the request
apiData.subscribe(res => console.log(res.status, res.response));
```

### 操作符

 * 操作符时基于可观察对象构建的一些堆积和进行复杂操作的函数
 * RxJS 定义了一些操作符，如 map()、filter()、concat()、flatMap()
 * 操作符接收一些配置项，然后返回一个以来源可观察对象为参数的函数，当执行这个返回的函数时，操作符会观察来源可观察对象中发出的值，转换它们，并返回由转换后的值组成的新的可观察对象

```ts
// map operator
import { map } from 'rxjs/operators';

const nums = of(1, 2, 3);

const squareValues = map((val: number) => val * val);
const squaredNums = squareValues(nums);

squaredNums.subscribe(x => console.log(x));

// Logs
// 1
// 4
// 9


// 使用管道把操作符链接起来
import { filter, map } from 'rxjs/operators';

const nums = of(1, 2, 3, 4, 5);

// Create a function that accepts an Observable.
const squareOddVals = pipe(
  filter((n: number) => n % 2 !== 0),
  map(n => n * n)
);

// 上面函数等价于下面函数，因为 pipe 函数也是 RxJS 的 observable 上的方法
const squareOdd = of(1, 2, 3, 4, 5)
  .pipe(
    filter(n => n % 2 !== 0),
    map(n => n * n)
  );

// Create an Observable that will run the filter and map functions
const squareOdd = squareOddVals(nums);

// Suscribe to run the combined functions
squareOdd.subscribe(x => console.log(x));
```

#### 常用操作符

 * 对 Angular 应用来说，推荐使用管道操作符，不推荐使用链式写法
 * 常用操作符列表和用法如下表

|操作符|操作|
|---|---|
|创建|from、fromPromise、fromEvent、of|
|组合|combineLatest、concat、merge、startWith、withLatestFrom、zip|
|过滤|dubounceTime、distinctUntilChanged、filter、take、takeUntil|
|转换|bufferTime、concatMap、map、mergeMap、scan、switchMap|
|工具|tap|
|多播|share|

### 错误处理

 * error() (Observable)用于在订阅时进行错误处理
 * RxJS 提供 catchError 操作符，用于在管道中处理已知错误

```ts
import { ajax } from 'rxjs/ajax';
import { map, catchError } from 'rxjs/operators';
// Return "response" from the API. If an error happens,
// return an empty array.
const apiData = ajax('/api/data').pipe(
  map(res => {
    if (!res.response) {
      throw new Error('Value expected!');
    }
    return res.response;
  }),       // 此处时逗号
  catchError(err => of([]))
);

apiData.subscribe({
  next(x) { console.log('data: ', x); },
  error(err) { console.log('errors already caught... will not run'); }
});
```

#### 重试失败的可观察对象

 * catchError 提供了一种简单的方式进行恢复
 * retry 操作符可以对对失败的请求进行重试
 * 在 catchError 之前使用 retry 可以对失败的操作进行重新尝试

```ts
import { ajax } from 'rxjs/ajax';
import { map, retry, catchError } from 'rxjs/operators';

const apiData = ajax('/api/data').pipe(
  retry(3), // Retry up to 3 times before failing
  map(res => {
    if (!res.response) {
      throw new Error('Value expected!');
    }
    return res.response;
  }),
  catchError(err => of([]))
);

apiData.subscribe({
  next(x) { console.log('data: ', x); },
  error(err) { console.log('errors already caught... will not run'); }
});
```

### 可观察对象的命名约定

 * 可观察对象的名字通常以"$"符号结尾
 * 如果想用一个属性来存储可观察对象的最近一个值，该属性名字应该与可观察对象同名，但是不带"$"后缀

```ts
import { Component } from '@angular/core';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-stopwatch',
  templateUrl: './stopwatch.component.html'
})
export class StopwatchComponent {

  stopwatchValue: number;
  stopwatchValue$: Observable<number>;  // 可观察对象名字以 $ 结尾

  start() {
    this.stopwatchValue$.subscribe(num =>
      this.stopwatchValue = num  // 可观察对象值
    );
  }
}
```

## Angular 中的可观察对象

 * 可观察对象在 Angular 中用于处理各种常用的异步操作：
    * EventEmitter 类派生自 Observable
    * HTTP 模块使用可观察对象对象来处理 Ajax 请求响应
    * 路由器和表单模块使用可观察对象来监听对用户输入事件的响应

### 事件发送器 EventEmitter

 * Angular 提供了一个 EventEmitter 类，它用来从组件的 @Output() 属性中发布一些值
 * EventEmitter 扩展了 Observable，并添加了一个 emit() 方法，使得它可以发送任意值
 * 调用 emit()时，EventEmitter 会把所发送的值传给订阅上来的观察者的 next() 方法

```ts
@Component({
  selector: 'zippy',
  template: `
  <div class="zippy">
    <div (click)="toggle()">Toggle</div>
    <div [hidden]="!visible">
      <ng-content></ng-content>
    </div>
  </div>`})

export class ZippyComponent {
  visible = true;
  @Output() open = new EventEmitter<any>();
  @Output() close = new EventEmitter<any>();

  toggle() {
    this.visible = !this.visible;
    if (this.visible) {
      this.open.emit(null);
    } else {
      this.close.emit(null);
    }
  }
}
```

### HTTP

 * Angular 的 HttpClient 从 HTTP 方法调用中返回了可观察对象
 * http 返回可观察对象，先比 promise 有以下优点：
    * 可观察对象不会修改服务器的响应(和在 promise 上串联起来的 .then() 调用一样)，但是，可以使用一系列操作符来按需转换这些值
    * HTTP 请求可以通过 unsubscribe() 方法来取消
    * 请求可以进行配置，以获取进度事件的变化
    * 失败的请求可以很简单的进行重试

### Async 管道

 * AsyncPipe 会订阅一个可观察对象或承诺，并返回其发出的最后一个值，当发出新值时，该管道会把这个组建标记为需要进行变更的检查的(可能会导致刷新界面)

```ts
// 把 time 这个可观察试图对象绑定到组件的试图中，可观察对象会不断使用当前事件更新组建的试图

@Component({
    selector: 'async-observable-pipi',
    template: `<div><code>observable|sync</code>:
        Time: {{ time |async }}
    </div>`
})

export class AsyncObservablePipeComponent {
    time = new Observable(observer => 
        setInterval(() => observer.next(new Date().toString()), 1000)
    )
}
```

### 路由器 (router)

 * Router.events 以可观察对象的形式提供了其事件
 * 可以使用 RxJS 中的 filter() 操作符来找到感兴趣的事件，并订阅它们
 * ActivatedRoute 是一个可注入的路由器服务，使用可观察对象来获取关于路由器和路由参数的信息

```ts
// Router.events
import { Router, NavigationStart } from '@angular/router';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-routable',
  templateUrl: './routable.component.html',
  styleUrls: ['./routable.component.css']
})
export class Routable1Component implements OnInit {

  navStart: Observable<NavigationStart>;

  constructor(private router: Router) {
    // Create a new Observable the publishes only the NavigationStart event
    this.navStart = router.events.pipe(
      filter(evt => evt instanceof NavigationStart)
    ) as Observable<NavigationStart>;
  }

  ngOnInit() {
    this.navStart.subscribe(evt => console.log('Navigation Started!'));
  }
}

// ActivateRoute.url 包含一个用于汇报路由路径的可观察对象
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-routable',
  templateUrl: './routable.component.html',
  styleUrls: ['./routable.component.css']
})
export class Routable2Component implements OnInit {
  constructor(private activatedRoute: ActivatedRoute) {}

  ngOnInit() {
    this.activatedRoute.url
      .subscribe(url => console.log('The URL changed to: ' + url));
  }
}
```

### 响应式表单(reactive forms)

 * 响应式表单具有一些属性，它们使用可观察对象来监听表单控件的值
 * FormControl 的 valueChanges 属性和 statusChanges 属性包含了会发出变更事件的可观察对象
 * 订阅可观察的表单控件属性时在组建类中触发应用逻辑的途径之一

```ts
import { FormGroup } from '@angular/forms';

@Component({
  selector: 'my-component',
  template: 'MyComponent Template'
})
export class MyComponent implements OnInit {
  nameChangeLog: string[] = [];
  heroForm: FormGroup;

  ngOnInit() {
    this.logNameChange();
  }
  logNameChange() {
    const nameControl = this.heroForm.get('name');
    nameControl.valueChanges.forEach(
      (value: string) => this.nameChangeLog.push(value)
    );
  }
}
```

## 用法实战

### 输入提示 (type-ahead) 建议

 * 可观察对象可以简化输入提示建议的实现方式，典型的输入提示要完成一系列独立的任务：
    * 从输入中监听数据
    * 移除输入值前后的空白字符，并确认它达到了最小长度
    * 防抖(防止连续按键时每次按键都发起 API 请求)
    * 如果输入值没有变化，则不应该发起请求
    * 如果已发出的 ajax 请求的结果会因为后续的修改而变得无效，应该取消它

```ts
import { fromEvent } from 'rxjs';
import { ajax } from 'rxjs/ajax';
import { map, filter, debounceTime, distinctUntilChanged, switchMap } from 'rxjs/operators';

const searchBox = document.getElementById('search-box');

const typeahead = fromEvent(searchBox, 'input').pipe(
  map((e: KeyboardEvent) => e.target.value),
  filter(text => text.length > 2),
  debounceTime(10),
  distinctUntilChanged(),
  switchMap(() => ajax('/api/endpoint'))
);

typeahead.subscribe(data => {
 // Handle the data from the API
});
```

### 指数化退避

 * 指数化退避时一种失败后重试 API 的技巧，它会在每次连续的失败之后让重试时间逐渐变长，超过最大重试次数之后就会彻底放弃

```ts
import { pipe, range, timer, zip } from 'rxjs';
import { ajax } from 'rxjs/ajax';
import { retryWhen, map, mergeMap } from 'rxjs/operators';

function backoff(maxTries, ms) {
 return pipe(
   retryWhen(attempts => range(1, maxTries)
     .pipe(
       zip(attempts, (i) => i),
       map(i => i * i),
       mergeMap(i =>  timer(i * ms))
     )
   )
 );
}

ajax('/api/endpoint')
  .pipe(backoff(3, 250))
  .subscribe(data => handleData(data));

function handleData(data) {
  // ...
}
```

## 与其它技术的比较

* 可观察对象和 承诺(promise) 都用来处理异步操作

### 可观察对象vs.承诺

 * 可观察对象是声明式的，在被订阅之前，不会开始执行;promise 在创建时就立即执行，因此可观察对象可以用于定义那些应该按需执行的菜谱
 * 可观察对象能提供多个值，promise 只能提供一个
 * 可观察对象会区分串联处理和订阅语句; promise 只有 then() 串联处理（await例外）

### 可观察对象与承诺实现同样功能接口对比如下

|操作|可观察对象|promsie|
|---|---|---|
|创建|new Observable(observer) => {observer.next(123)}|new Promise((resolve,reject) => {resolve(123)})|
|转换|obs.map((value) => value*2)|promise.then((value) => value *2)|
|订阅|sub = obs.subscribe((value) => {console.log(value)})|promsie.then((value) => console.log(value))|
|取消订阅|sub.unsubscribbe()|承诺被解析时隐式完成|