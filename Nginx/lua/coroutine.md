# lua 协程

---
lua 协程(协同式多线程) 允许我们一次执行多个任务，这是通过将控制传递给每个协程等到协程处理结束后回到原来的进程来处理程序，依次来实现多任务处理。

lua 中的协程不是操作系统线程或进程，它是在 lua 中创建的 lua 代码块，并且像线程一样拥有自己的控制流，一次只能有一个协程在运行，它会一直运行直到它激活另一个协程，或者执行 yields 来返回到调用它的协程中去。协程时一个以方便和自然的方式来处理多个线程，但不是同时执行多个协程，因此不会从多个 cpu 获取性能优势，但是，由于协程切换比操作系统快的多，并且同城不需要复杂和昂贵的锁机制，因此使用协程通常比 OS 线程更高效更快。

调用协程时当前的进程会暂停，直到调用的协程停止执行或结束。

协程有自己独立的栈、局部变量和指令指针

## 基本语法
|方法|描述|
|--|--|
|coroutine.create(f)|创建一个协程，参数 f 是一个函数，返回一个类型为 thread 的对象|
|coroutine.resume(co [,val1,...])|启动协程并传递参数(如果有的话)，返回操作状态和可选的其它返回值|
|coroutine.yield()|暂停正在运行的协程，传递给此方法的参数会作为 resume 函数的附加返回值|
|coroutine.status(co)|返回协程的状态: running、normal、suspended、dead|
|coroutine.wrap(f)|创建一个协程，不会返回协程本身，而是返回一个函数|
|coroutine.running(...)|返回正在运行的协程的编号|

## 示例
```lua
co = coroutine.create(
  function(i)
    print(i)
    return i
  end
)
print('-----------------')
print(co)                             --> thread: 0x053826f8
print(coroutine.status(co))           --> suspended
coroutine.resume(co, 1)               --> 1
print(coroutine.status(co))           --> dead

co = coroutine.create(function ()
  for i=1,10 do
    print("co", i)
    coroutine.yield()
  end
end)

coroutine.resume(co)                  --> co  1
print(coroutine.status(co))           --> suspended
coroutine.resume(co)                  --> co  2
coroutine.resume(co)                  --> co  3
coroutine.resume(co)                  --> co  4
print(coroutine.status(co))           --> suspended  
print(coroutine.running(co))          --> thread: 0x0537a378      true
print('==================')
```