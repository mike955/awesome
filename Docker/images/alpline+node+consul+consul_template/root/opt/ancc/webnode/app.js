const Koa = require('koa');
const app = new Koa();
const global = require('./global.js')
// response
app.use(ctx => {
  ctx.body = 'Hello Koa';
});

app.listen(parseInt(global.port));