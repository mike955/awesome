# Node.js 时间循环、计时器与进程
原文链接:[https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick/](https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick/)

## 什么是事件循环
事件循环允许 Node.js 去执行非阻塞操作 -- 尽管 JavaScript 是单线程的 -- 通过将尽可能多的操作卸载到系统内核

由于绝大多数的现在系统都是多核的，因此它们可以处理在后台执行的多个操作，当一个操作完成时，将响应的回调添加到轮询队列中最终执行

## 事件循环详解
当 Node.js 启动时，它会初始化时间循环，对输入的脚本参数进行处理，可能会进行异步 API 调用，调用计时器或 process.nextTick()，然后开始处理事件循环

下图显示了事件操作循环的顺序
```pic
   ┌───────────────────────────┐
┌─>│           timers          │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
│  │     pending callbacks     │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
│  │       idle, prepare       │
│  └─────────────┬─────────────┘      ┌───────────────┐
│  ┌─────────────┴─────────────┐      │   incoming:   │
│  │           poll            │&lt;─────┤  connections, │
│  └─────────────┬─────────────┘      │   data, etc.  │
│  ┌─────────────┴─────────────┐      └───────────────┘
│  │           check           │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
└──┤      close callbacks      │
   └───────────────────────────┘
```
*上图中每一个方块表示事件循环中的一个阶段*

每一个阶段都有一个要执行的回调 FIFO(先进先出) 队列，虽然每个阶段有自己的特殊方式，但是通常情况下，当时间循环进入给定阶段时，它将执行特定于该阶段的任何操作，然后在该阶段的队列中执行回调，直到队列耗尽或最大回调数被执行，当队列耗尽或达到回调限制时，事件循环将移至下一阶段执行，以此类推。

由于这些操作中的任何一个可以调度更多操作，并且内核可以对轮询阶段中处理的新事件进行排队，因此轮询事件可以在处理，因此长时间运行的回调可以使轮询阶段事件运行的事件比计时器的阀值长的多

*注意：*Window 和 Unix / Linxu 实现之间存在轻微差异，实际有七到八个步骤，上面的六个步骤只是 Node.js 实际用到的

## 事件执行阶段

 * timers: 执行由 setTimeout() 和 setInterval() 发起的回调
 * pending callbacks: 执行延迟到下一个循环迭代的 I/O 回调
 * idle, prepare: 仅被内部使用
 * poll: 检索新的 I/O 事件，执行与 I/O 相关的回调(几乎所有的回调都是关闭回调，定时器和 setImmediate() 调度的回调)，节点会在适当的时候阻止该行为
 * check: setImmediate() 回调在该阶段被触发
 * close callbacks: 执行一些关闭回调，如 socket.on('close', ...)

在每次事件巡检执行之间，Node.js 会检查当前是否在等待任何异步 I/O 或定时器，如果有，则执行异步或定时器任务，如果没有，则关闭

## 每个阶段详细说明

### timers

计时器通过一个回调而不是希望执行回调的确切时间指定回调的阀值，定时器回调将在执行的时间过去后尽早安排，但是，操作系统调度或其他回调的运行可能会延迟它们。

*注意:*从技术上来说，轮训器控制定时器什么时候执行

看下面的例子，假设你计划在 100ms 阀值后执行超时，则脚本将异步读取一个需要 95ms 的文件
```js
const fs = require('fs');

function someAsyncOperation(callback) {
  // Assume this takes 95ms to complete
  fs.readFile('/path/to/file', callback);
}

const timeoutScheduled = Date.now();

setTimeout(() => {
  const delay = Date.now() - timeoutScheduled;

  console.log(`${delay}ms have passed since I was scheduled`);
}, 100);


// do someAsyncOperation which takes 95 ms to complete
someAsyncOperation(() => {
  const startCallback = Date.now();

  // do something that will take 10ms...
  while (Date.now() - startCallback < 10) {
    // do nothing
  }
});
```
当事件循环进入轮询阶段时，它有一个空队列(fs.readFlie()还未完成)，此时它将等待剩余的 ms 数，直到达到最快的计时器阀值，当它等待 95 毫秒传递时，fs.readFile() 完成读取文件，并且需要 10ms 才能完成回调被添加到轮询队列并执行。当回调结束时，队列中不再有回调，因此事件循环将看到已到达最快定时器的阀值，然后回绕到定时器阶段以执行定时器的回调，在上面的例子中，你将看到正在调度的计时器与正在执行的回调执行的总延时将为 105ms 。

*注意:*为了防止轮训阶段执行空事件循环，libuv(实现 Node.js 事件循环和平台的所有异步行为的 C 库)在停止轮询之间也具有硬最大值(取决于系统)

### pending callbacks

该阶段执行某些系统操作(如 TCP 错误)的回调，例如，TCP 套接字在尝试连接时收到 ECONNREFUSED，则某些 *nix 系统希望等报错错误，这将排队等在在挂起的回调阶段执行

### poll

轮询阶段有两个主要的功能:
 * 计算应该阻止和轮询 I/O 的时间
 * 处理轮询队列中的事件

当事件循环进入轮询阶段并且没有定时器计划时，下面两种情况将会发生一种
 * 如果轮询队列不为空，则事件循环将遍历其同步执行它们的回调队列，直到队列已用尽或者达到系统相关的硬限制
 * 如果轮询队列为空，下面两种情况会发生一种
    * 如果 setImmediate() 已调度脚本，则事件循环将结束轮询阶段并执行检查阶段以执行这些调度脚本
    * 如果 setImmediate() 未调度脚本，则事件循环将等待回调被添加到队列中，然后立即执行它们

一旦轮询队列为空，事件循环将检查已达到事件阀值的计时器，如果一个多多个计时器准备就绪，事件循环将回绕到计时器阶段以执行那些计时器的回调

### check

检查阶段允许人员在轮询阶段完成后立即执行回调，如果轮询阶段变为空闲并且脚本已使用 setImmediate() 排队，则事件循环可以继续执行到检查阶段而不是等待

setImmediate() 是一个特殊的计时器，它在事件循环的一个单独阶段运行，它使用libuv API 来调度在轮询阶段完成后执行的回调

通常，在执行代码时，事件循环最终回到达轮询阶段，它将等待传入连接、请求等，但是，如果已使用 setImmediate() 调度回调并且轮询阶段变为空闲，则将结束并继续检查阶段，而不是等待轮询事件

### close callbacks

如果套接字或句柄突然关闭(例如 socket.destory())，则在此阶段将发出 close 事件，否则它将通过 process.nextTick() 发出

## setImmediate() VS setTimeout()

setImmediate() 与 setTimeout() 类似，根据调用方式，它们有不同的行为

 * setImmediate() 被用于执行一个脚本当轮训阶段完成时
 * setTimeout() 在经过最小阀值后执行一个脚本

执行定时器的顺序将根据调用它们的上下文而有所不同，如果主从模块中调用两者，则时间将收到进程性能的限制(可能收到计算机上运行的其他应用程序的影响)

如果我们运行不在 I/O 周期内的以下脚本，则执行两个定时器的顺序时不确定的，因为它受到进程性能的约束
```js
// timeout_vs_immediate.js
setTimeout(() => {
  console.log('timeout');
}, 0);

setImmediate(() => {
  console.log('immediate');
});
```

```sh
$ node timeout_vs_immediate.js
timeout
immediate

$ node timeout_vs_immediate.js
immediate
timeout
```
然而，如果移动它们到同一个 I/O 周期内，immediate将总会被执行
```js
// timeout_vs_immediate.js
const fs = require('fs');

fs.readFile(__filename, () => {
  setTimeout(() => {
    console.log('timeout');
  }, 0);
  setImmediate(() => {
    console.log('immediate');
  });
});
```
```sh
$ node timeout_vs_immediate.js
immediate
timeout

$ node timeout_vs_immediate.js
immediate
timeout
```
setImmediate() 对比 setTimeout() 的优势在于 setImmediate() 将始终在任何定时器之间执行(如果在 I/O周期内调度)，与存在多少定时器无关

## process.nextTick()

### 理解 process.nextTick()

您可能已经注意到process.nextTick（）没有显示在图中，即使它是异步API的一部分。这是因为process.nextTick（）在技术上不是事件循环的一部分。相反，nextTickQueue将在当前操作完成后处理，而不管事件循环的当前阶段如何


回看一下我们的图表，无论何时在给定阶段调用process.nextTick（），传递给process.nextTick（）的所有回调都将在事件循环继续之前得到解决。这可能会产生一些不好的情况，因为它允许您通过进行递归的process.nextTick（）调用来“饿死”您的I / O，这会阻止事件循环到达轮询阶段。

### Why would that be allowed?


为什么这样的东西会被包含在Node.js中？其中一部分是一种设计理念，其中API应该始终是异步的，即使它不是必须的。以此代码段为例：
```js
function apiCall(arg, callback) {
  if (typeof arg !== 'string')
    return process.nextTick(callback,
                            new TypeError('argument should be string'));
}
```

片段进行参数检查，如果不正确，它会将错误传递给回调。新的API允许将参数传递给process.nextTick()，允许它将回调后传递的任何参数作为参数传播到回调，不必嵌套函数。


我们做的是将错误传回给用户，但只有在我们允许其余的用户代码执行之后。通过使用process.nextTick（），我们保证apiCall（）始终在用户代码的其余部分之后和允许事件循环继续之前运行其回调。为了实现这一点，允许JS调用堆栈展开然后立即执行提供的回调，这允许一个人对process.nextTick（）进行递归调用而不会达到RangeError：超出v8的最大调用堆栈大小。

这种理念可能会导致一些潜在的问题。以此片段为例：
```js
let bar;

// this has an asynchronous signature, but calls callback synchronously
function someAsyncApiCall(callback) { callback(); }

// the callback is called before `someAsyncApiCall` completes.
someAsyncApiCall(() => {
  // since someAsyncApiCall has completed, bar hasn't been assigned any value
  console.log('bar', bar); // undefined
});

bar = 1;
```
用户将someAsyncApiCall（）定义为具有异步签名，但它实际上是同步操作的。调用它时，在事件循环的同一阶段调用提供给someAsyncApiCall（）的回调，因为someAsyncApiCall（）实际上不会异步执行任何操作。因此，回调尝试引用bar，即使它在范围内可能没有该变量，因为该脚本无法运行完成。


通过将回调放在process.nextTick（）中，脚本仍然能够运行完成，允许在调用回调之前初始化所有变量，函数等。它还具有不允许事件循环继续的优点。在允许事件循环继续之前，向用户警告错误可能是有用的。以下是使用process.nextTick（）的前一个示例：

```js
let bar;

function someAsyncApiCall(callback) {
  process.nextTick(callback);
}

someAsyncApiCall(() => {
  console.log('bar', bar); // 1
});

bar = 1;
```
下面是一个真实的例子
```js
const server = net.createServer(() => {}).listen(8080);

server.on('listening', () => {});
```

仅传递端口时，端口立即绑定。因此，可以立即调用'listen'回调。问题是那时候不会设置.on（'listen'）回调。


为了解决这个问题，'listen'事件在nextTick（）中排队，以允许脚本运行完成。这允许用户设置他们想要的任何事件处理程序。

### process.nextTick() vs setImmediate()

我们有两个类似的呼叫，但它们的名称令人困惑

 * process.nextTick() :  fires immediately on the same phase
 * setImmediate() : fires on the following iteration or 'tick' of the event loop

实质上，应该交换名称。 process.nextTick（）比setImmediate（）更快地触发，但这是过去的工件，不太可能改变。进行此切换会破坏npm上的大部分包。每天都会添加更多新模块，这意味着我们每天都在等待，更多的潜在破损发生。虽然它们令人困惑，但名称本身不会改变。

*我们建议开发人员在所有情况下都使用setImmediate（），因为它更容易推理（并且它导致代码与更广泛的环境兼容，如浏览器JS。）*

### Why use process.nextTick()?

有两面两个主要原因

 * 允许用户处理错误，清除任何不需要的资源，或者在事件循环继续之前再次尝试请求.
 * 有时需要允许回调在调用堆栈展开之后但在事件循环继续之前运行.

下面是一个匹配用户期望的例子
```js
const server = net.createServer();
server.on('connection', (conn) => { });

server.listen(8080);
server.on('listening', () => { });
```
假设listen（）在事件循环开始时运行，但是监听回调放在setImmediate（）中。除非传递主机名，否则将立即绑定到端口。要使事件循环继续，它必须达到轮询阶段，这意味着可能已经接收到连接的非零概率允许在侦听事件之前触发连接事件。


另一个例子是运行一个函数构造函数，比如继承自EventEmitter，它想在构造函数中调用一个事件：
```js
const EventEmitter = require('events');
const util = require('util');

function MyEmitter() {
  EventEmitter.call(this);
  this.emit('event');
}
util.inherits(MyEmitter, EventEmitter);

const myEmitter = new MyEmitter();
myEmitter.on('event', () => {
  console.log('an event occurred!');
});
```

您无法立即从构造函数中发出事件，因为脚本将不会处理到用户为该事件分配回调的位置。因此，在构造函数本身中，您可以使用process.nextTick（）来设置回调以在构造函数完成后发出事件，从而提供预期的结果：
```js
const EventEmitter = require('events');
const util = require('util');

function MyEmitter() {
  EventEmitter.call(this);

  // use nextTick to emit the event once a handler is assigned
  process.nextTick(() => {
    this.emit('event');
  });
}
util.inherits(MyEmitter, EventEmitter);

const myEmitter = new MyEmitter();
myEmitter.on('event', () => {
  console.log('an event occurred!');
});
```