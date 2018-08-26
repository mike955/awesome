# HttpClient

 * Angular 中的 HttpClient 类给予 XMLHttpRequest 接口

---

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->
- [HttpClient](#httpclient)
    - [准备工作](#%E5%87%86%E5%A4%87%E5%B7%A5%E4%BD%9C)
    - [获取 JSON 数据](#%E8%8E%B7%E5%8F%96-json-%E6%95%B0%E6%8D%AE)
        - [为什么要写服务](#%E4%B8%BA%E4%BB%80%E4%B9%88%E8%A6%81%E5%86%99%E6%9C%8D%E5%8A%A1)
        - [带类型检查的响应](#%E5%B8%A6%E7%B1%BB%E5%9E%8B%E6%A3%80%E6%9F%A5%E7%9A%84%E5%93%8D%E5%BA%94)
        - [读取完整响应](#%E8%AF%BB%E5%8F%96%E5%AE%8C%E6%95%B4%E5%93%8D%E5%BA%94)
    - [错误处理](#%E9%94%99%E8%AF%AF%E5%A4%84%E7%90%86)
        - [获取错误详情](#%E8%8E%B7%E5%8F%96%E9%94%99%E8%AF%AF%E8%AF%A6%E6%83%85)
        - [retry()](#retry)
    - [可观察对象(Observable)与操作符(operator)](#%E5%8F%AF%E8%A7%82%E5%AF%9F%E5%AF%B9%E8%B1%A1observable%E4%B8%8E%E6%93%8D%E4%BD%9C%E7%AC%A6operator)
    - [请求非 JSON 格式数据](#%E8%AF%B7%E6%B1%82%E9%9D%9E-json-%E6%A0%BC%E5%BC%8F%E6%95%B0%E6%8D%AE)
    - [把数据发送给服务器](#%E6%8A%8A%E6%95%B0%E6%8D%AE%E5%8F%91%E9%80%81%E7%BB%99%E6%9C%8D%E5%8A%A1%E5%99%A8)
        - [添加请求头](#%E6%B7%BB%E5%8A%A0%E8%AF%B7%E6%B1%82%E5%A4%B4)
        - [发起一个 POST 请求](#%E5%8F%91%E8%B5%B7%E4%B8%80%E4%B8%AA-post-%E8%AF%B7%E6%B1%82)
        - [发起 DELETE 请求](#%E5%8F%91%E8%B5%B7-delete-%E8%AF%B7%E6%B1%82)
        - [发起 PUT 请求](#%E5%8F%91%E8%B5%B7-put-%E8%AF%B7%E6%B1%82)

## 准备工作

 * 导入 Angular 的 HttpClientModule，可以在根模块 AppModule 中导入
 * 根模块导入 HttpClientModule 后，可以把 HttpClient 注入到应用类中

根模块导入 HttpClientModule
```ts
// app.module.ts
import { NgModule }         from '@angular/core';
import { BrowserModule }    from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';

@NgModule({
  imports: [
    BrowserModule,
    // import HttpClientModule after BrowserModule.
    HttpClientModule,
  ],
  declarations: [
    AppComponent,
  ],
  bootstrap: [ AppComponent ]
})
export class AppModule {}
```

把 HttpClient 注入到应用类中
```ts
// config/config.service.ts
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable()
export class ConfigService {
  constructor(private http: HttpClient) { }
}
```
[Back To TOC](#httpclient)

## 获取 JSON 数据

```json
// assets/config.json
{
  "heroesUrl": "api/heroes",
  "textfile": "assets/textfile.txt"
}
```

```ts
// app/config/config.service.ts
configUrl = 'assets/config.json';

getConfig() {
  return this.http.get(this.configUrl); // 通过 HttpClient的 get() 方法取得这个文件
}
```

下面的服务返回配置数据的 Observable 对象，所以组件要订阅 (subscribe) 该方法的返回值，订阅时的回调函数会把这些数据字段复制到组件的 config 对象中，它会在组件的模板中绑定
```ts
// app/config/config.component.ts
showConfig() {
  this.configService.getConfig()
    .subscribe((data: Config) => this.config = {
        heroesUrl: data['heroesUrl'],
        textfile:  data['textfile']
    });
}
```
[Back To TOC](#httpclient)

### 为什么要写服务

 * 最佳实践：把数据展现逻辑从数据访问逻辑中拆分出去，包装进一个单独的服务，并且在组件中把数据访问逻辑委托给这个服务

[Back To TOC](#httpclient)

### 带类型检查的响应

订阅的回调需要用括号中的语句来提取数据的值
```ts
.subscribe((data: Config) => this.config = {
    heroesUrl: data['heroesUrl'],   // 不能写成 data.heroesUrl，因为 get() 方法会把 JSON 响应体解析成匿名的 OBject 类型
    textfile:  data['textfile']
});
```

定义响应体的类型

```ts
// app/config/config.service.ts
export interface Config {
  heroesUrl: string;
  textfile: string;
}

getConfig() {
  // now returns an Observable of Config
  return this.http.get<Config>(this.configUrl);
}
```

```ts
// app/config/config.component.ts
export interface Config {
  heroesUrl: string;
  textfile: string;
}

config: Config;

showConfig() {
  this.configService.getConfig()
    // clone the data object, using its known Config shape
    .subscribe((data: Config) => this.config = { ...data });
}
```
[Back To TOC](#httpclient)

### 读取完整响应

 * 通过 observe 选项来获取 HttpClient 完整响应体
 * 返回的 Observable 是一个 HttpResponse 类型

```ts
getConfigResponse(): Observable<HttpResponse<Config>> {
  return this.http.get<Config>(
    this.configUrl, { observe: 'response' });
}
```

```ts
showConfigResponse() {
  this.configService.getConfigResponse()
    // resp is of type `HttpResponse<Config>`
    .subscribe(resp => {
      // display its headers
      const keys = resp.headers.keys();
      this.headers = keys.map(key =>
        `${key}: ${resp.headers.get(key)}`);

      // access the body directly, which is typed as `Config`.
      this.config = { ... resp.body };
    });
}
```
[Back To TOC](#httpclient)

## 错误处理

 * 在 .subscribe() 中添加第二个回调函数获取错误处理

```ts
// 返回的错误类型为 HttpErrorResponse
showConfig() {
  this.configService.getConfig()
    .subscribe(
      (data: Config) => this.config = { ...data }, // success path
      error => this.error = error // error path
    );
}
```

### 获取错误详情

 * 添加错误处理函数处理错误

```ts
private handleError(error: HttpErrorResponse) {
  if (error.error instanceof ErrorEvent) {
    // A client-side or network error occurred. Handle it accordingly.
    console.error('An error occurred:', error.error.message);
  } else {
    // The backend returned an unsuccessful response code.
    // The response body may contain clues as to what went wrong,
    console.error(
      `Backend returned code ${error.status}, ` +
      `body was: ${error.error}`);
  }
  // return an observable with a user-facing error message
  return throwError(
    'Something bad happened; please try again later.');
};

getConfig() {
  return this.http.get<Config>(this.configUrl)
    .pipe(
      catchError(this.handleError)  // 获取 HttpClient 方法返回的 Observable,并通过管道传给错误处理器
    );
}
```

### retry()

 * 如果 HttpClient 方法调用错误进行重试

```ts
getConfig() {
  return this.http.get<Config>(this.configUrl)
    .pipe(
      retry(3), // retry a failed request up to 3 times
      catchError(this.handleError) // then handle the error
    );
}
```

## 可观察对象(Observable)与操作符(operator)

## 请求非 JSON 格式数据

```ts
getTextFile(filename: string) {
  // The Observable returned by get() is of type Observable<string>
  // because a text response was specified.
  // There's no need to pass a <string> type parameter to get().
  return this.http.get(filename, {responseType: 'text'})    // 请求 text 类型的数据
    .pipe(
      tap( // Log the result or error
        data => this.log(filename, data),
        error => this.logError(filename, error)
      )
    );
}
```

## 把数据发送给服务器

 * 调用可观察对象的 subscribe() 方法之前，httpClient 不会发起 HTTP 请求

### 添加请求头

```ts
// 添加请求头
import { HttpHeaders } from '@angular/common/http';

const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type':  'application/json',
    'Authorization': 'my-auth-token'
  })
};
```

### 发起一个 POST 请求

 * post 请求接受三个参数(url, 请求体数据, 请求头)

```ts
/** POST: add a new hero to the database */
addHero (hero: Hero): Observable<Hero> {
  return this.http.post<Hero>(this.heroesUrl, hero, httpOptions)
    .pipe(
      catchError(this.handleError('addHero', hero))
    );
}
```

### 发起 DELETE 请求

```ts
/** DELETE: delete the hero from the server */
deleteHero (id: number): Observable<{}> {
  const url = `${this.heroesUrl}/${id}`; // DELETE api/heroes/42
  return this.http.delete(url, httpOptions)
    .pipe(
      catchError(this.handleError('deleteHero'))
    );
}
```

### 发起 PUT 请求

```ts
/** PUT: update the hero on the server. Returns the updated hero upon success. */
updateHero (hero: Hero): Observable<Hero> {
  return this.http.put<Hero>(this.heroesUrl, hero, httpOptions)
    .pipe(
      catchError(this.handleError('updateHero', hero))
    );
}
```