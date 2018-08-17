## mocha+chai

### 安装
```sh
#!bin/bash

mkdir test
cd test

npm init -y
npm install mocha -g
npm install chai --save-dev

```
### hook

```js
describe('hooks', function() {

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
});
```