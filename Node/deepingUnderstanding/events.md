
# Node核心模块之Events
```Node.js V6.9.4```
Node.js核心API的大部分是围绕一个异步事件驱动架构构建的，因此Events模块是很多模块的基础，很多模块都是基于Events模块建立的，

例如：net.Server对象每当对等体连接到它时发出一个事件; fs.ReadStream在打开文件时发出事件; 每当数据可用于读取时，流发出事件。

所有发出事件的对象都是EventEmitter类的实例。这些对象公开了一个EventEmitter.on()函数，它允许一个或多个函数附加到对象发出的命名空间。

我们可以为一个事件对象注册多个事件，可以为一个事件注册多个监听器

1.Events模块基本用法
```

const EventEmitter = require('events');

class MyEmitter extends EventEmitter {}

const myEmitter = new MyEmitter();

myEmitter.on('event', () => {		//注册一个名为'event'的事件
  console.log('an event occurred!');
});

//触发名为'event'的事件
myEmitter.emit('event');  // => 'an event occurred!'	

```

2.同步与异步
EventEmitter按照事件的注册顺序同步的调用监听器，如果想切换到异步模式，使用setImmediate()或process.nextTick()

```
const myEmitter = new MyEmitter();

myEmitter.on('event', (a, b) => {

  setImmediate(() => {
    console.log('this happens asynchronously'); 	// 该事件会异步触发
  });
});

myEmitter.emit('event', 'a', 'b');

```

3.Error events
当事件队列中发生错误或者没有为错误事件注册监听器，则应用会抛出一个'error'事件，并且程序会退出
```
const myEmitter = new MyEmitter();
myEmitter.emit('error', new Error('whoops!'));  // 抛出错误并且程序退出
```

避免抛出错误时，进程崩溃，可以为进程注册一个uncaughtException事件，用来处理错误，避免程序崩溃
```
const myEmitter = new MyEmitter();

process.on('uncaughtException', (err) => {
  console.log('whoops! there was an error');
});

//进程不会崩溃
myEmitter.emit('error', new Error('whoops!'));  // => 'whoops! there was an error'

```
最佳实践：应该始终为监听器注册一个'error'事件
```
const myEmitter = new MyEmitter();

myEmitter.on('error', (err) => {
  console.log('whoops! there was an error');
});

myEmitter.emit('error', new Error('whoops!'));   // => 'whoops! there was an error'

```

4.Event常用API介绍
const EventEmitter = require('events')
const myEE = new EventEmitter()

|<font face="微软雅黑" size=5>方法</font>|<font face="微软雅黑" size=5>作用</font>|
|----|------|
|<font face="微软雅黑" size=2 color=#4682B4>myEE.on('eventName', listener)</font>|<font face="微软雅黑" size=2>为当前实例对象的某个事件注册监听器</font>|
|<font face="微软雅黑" size=2 color=#4682B4>myEE.emit(eventName[, ...args])</font>|<font face="微软雅黑" size=2>顺序触发当前实例对象某个事件的所有监听器</font>|
|<font face="微软雅黑" size=2 color=#4682B4>myEE.once(eventName, listener)</font>|<font face="微软雅黑" size=2>设置当前实例对象的某个事件的监听器只触发一次</font>|
|<font face="微软雅黑" size=2 color=#4682B4>myEE.addListener(eventName, listener)</font>|<font face="微软雅黑" size=2>为当前实例对象的某个事件增加监听器</font>|
|<font face="微软雅黑" size=2 color=#4682B4>myEE.eventNames()</font>|<font face="微软雅黑" size=2>返回当前实例对象的所有的注册事件(按注册顺序)</font>|
|<font face="微软雅黑" size=2 color=#4682B4>myEE.getMaxListeners()</font>|<font face="微软雅黑" size=2>返回当前实例对象可以设置的最大监听器数量</font>|
|<font face="微软雅黑" size=2 color=#4682B4>myEE.listenerCount(eventName)</font>|<font face="微软雅黑" size=2>返回当前实例对象的某个事件的监听器数量</font>|
|<font face="微软雅黑" size=2 color=#4682B4>myEE.listeners(eventName)</font>|<font face="微软雅黑" size=2>以数组形式返回当前实例对象的某个事件的所有监听器</font>|
|<font face="微软雅黑" size=2 color=#4682B4>myEE.removeAllListeners([eventName])</font>|<font face="微软雅黑" size=2>删除当前对象的某个事件的所有监听器</font>|
|<font face="微软雅黑" size=2 color=#4682B4>myEE.removeListener(eventName, listener)</font>|<font face="微软雅黑" size=2>删除当前对象的某个事件的某个监听器</font>|
|<font face="微软雅黑" size=2 color=#4682B4>myEE.setMaxListeners(n)</font>|<font face="微软雅黑" size=2 >设置监听器的最大数量</font>|
