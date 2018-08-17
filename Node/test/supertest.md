## supertest

### 安装依赖
```sh
#!bin/bash

mkdir test
cd test

npm init -y
npm install mocha -g
npm install chai --save-dev
npm install supertest --save-dev
```

### 编写脚本

```js
// test_supertest.js
const request = require('supertest')
const { assert, expect, should } = requires('chai')
const url = "http://www.baidu.com"

describe('test', () => {
     before(() => {
        // runs before all tests in this block
    });

    after(() => {
        // runs after all tests in this block
    });

    beforeEach(() => {
        // runs before each test in this block
    });

    afterEach(() => {
        // runs after each test in this block
    });

    // test cases
    it('respond with baidu.com', async () => {
        let res = await supestest(url)
                        .get('/)
        ....
    });

    // 可以嵌套
    describe('Array', function() {
        describe.only('#indexOf()', function() {
            // ...
        });
    });
```

### 执行测试

```sh
mocha test_supertest.js
```