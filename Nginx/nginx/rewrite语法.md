# rewrite
rewrite regex replacement [flag]

## flag
* last: 停止处理后续rewrite指令集，然后对当前重写的新URI在rewrite指令集上重新查找
* break: 中止 rewrite，不再继续匹配
* redirect: 返回临时重定向的 http 状态 302
* permanent: 返回永久重定向的 http 状态 301

## 语法

| 正则    | 含义                           |
| ------- | ------------------------------ |
| .       | 匹配除换行符意外的所有任意字符 |
| ?       | 重复 0 次或 1 次               |
| +       | 重复 1 次或多次                |
| *       | 重复 0 次或大于 1 次           |
| \d      | 匹配数字                       |
| ^       | 匹配字符串开始位置             |
| $       | 匹配字符串                     |
| { n }   | 重复 n 次                      |
| { n, }  | 重复 n 次或更多次              |
| [ c ]   | 匹配单个字符 c                 |
| [ a-z ] | 匹配 a-z 小写字母中任意一个    |

小括号()之间匹配的内容，可以在后面通过$1来引用，$2表示的是前面第二个()里的内容

## 实例
rewrite ^/images/(.*)_(\d+)x(\d+)\.(png|jpg|gif)$ /resizer/$1.$4?width=$2&height=$3? last;

对形如/images/bla_500x400.jpg的文件请求，重写到/resizer/bla.jpg?width=500&height=400地址，并会继续尝试匹配location

