function foo(){
    console.log('foo_export')
}
function bar() {
    console.log('bar_export')
}

// module.exports = {
//     foo: foo
// }

module.exports = bar
exports = foo
// exports = module.exports = {
//     foo: foo,
//     bar: bar
// }