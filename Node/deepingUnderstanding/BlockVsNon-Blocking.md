# 阻塞与非阻塞(翻译)
原文地址：[https://nodejs.org/en/docs/guides/blocking-vs-non-blocking/](https://nodejs.org/en/docs/guides/blocking-vs-non-blocking/)

## 阻塞与非阻塞概述
这篇文章主要介绍 Node.js 中的阻塞与非阻塞的区别，主要涉及事件循环与 libuv 库，假设读者对 JavaScript 语言和 Node.js 回调模式有一个基本的了解

### 阻塞
阻塞是指在 Node.js 进程中执行 JavaScript 代码时需要等待某些非 Javascript操作完成，发生这种情况是因为事件循环在阻塞操作发生时无法继续运行 JavaScript。

在 Node.js 中，由于 CPU 执行密集任务而不是等待一个非 JavaScript操作的行为不能称为阻塞，例如 I/O 操作，Node.js 标准库中使用 libuv 的同步方式是最常用的阻塞操作，原生模块也可能存在阻塞方法。

Node.js 标准库中的所有 I/O方法都提供非阻塞的异步版本，某些方法还具有相对应的阻塞方法，名称通常以 Sync 结尾。

### 代码比较
阻塞方法同步执行，非阻塞方法移步执行

使用文件模块的的阻塞方法读取文件

```js
const fs = require('fs');
const data = fs.readFileSync('/file.md'); // blocks here until file is read
```
下面是一个等价的异步形式
```js
const fs = require('fs');
fs.readFile('/file.md', (err, data) => {
  if (err) throw err;
});
```
上面的两个例子中，第一个实例看起来比第二个更加简单，但是缺点是第二行阻止执行其他任何 JavaScript 代码，直到文件读取结束；在第二个实例中，需要对抛出的错误进行处理，否则进程会崩溃，

对上面的实例进行一下扩展
```js
const fs = require('fs');
const data = fs.readFileSync('/file.md'); // blocks here until file is read
console.log(data);
// moreWork(); will run after console.log
```
下面对对应的异步实例
```js
const fs = require('fs');
fs.readFile('/file.md', (err, data) => {
  if (err) throw err;
  console.log(data);
});
// moreWork(); will run before console.log
```
上面第一个实例中， console.log 将会在 morework() 之前执行；在第二个实例中 fs.readFile 是一个非阻塞的，因此 JavaScript 代码可以继续执行，morework 将会在 console.log 之前先执行，因此异步可以提高吞吐量

### 并发与吞吐量
Node.js 中的 JavaScript 执行是单线程的，因此并发性指的是事件循环在完成其他工作后执行 JavaScript 毁掉函数的能力，任何被期望以并发方式运行的代码都必须允许事件循环继续执行，因为非 JavaScript操作 (如 I/O) 正在发生。
现在让我们考虑这样一种情形，每一个 web 服务器请求需要 50ms 完成，并且 50ms 中的 45ms 是可以异步完成的数据库 I/O，使用非阻塞操作可以释放每个请求的 45ms 来处理其他请求，仅通过选择使用非阻塞方法而不是阻塞方法，这会导致容量的显著差异。
事件循环不同于许多其他语言中的模型，其中可以创建其他线程来处理并发工作。

### 阻塞与非阻塞代码混用的危险
有一些情形在处理 I/O 时应该被避免，看下面的例子
```js
const fs = require('fs');
fs.readFile('/file.md', (err, data) => {
  if (err) throw err;
  console.log(data);
});
fs.unlinkSync('/file.md');
```
上面的例子中， fs.unlinkSync 可能会在 fs.reafFile 之前执行，那会导致文件读取失败，这种场景更好的方式是使用非阻塞的方式读取文件，同时确保代码执行正确，看下面代码：
```js
const fs = require('fs');
fs.readFile('/file.md', (readFileErr, data) => {
  if (readFileErr) throw readFileErr;
  console.log(data);
  fs.unlink('/file.md', (unlinkErr) => {
    if (unlinkErr) throw unlinkErr;
  });
});
```
上面的代码将 fs.unlink 方法放在 fs.readFile 的回调函数中执行，保证文件读取正确