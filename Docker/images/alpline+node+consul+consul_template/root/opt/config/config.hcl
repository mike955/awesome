template {
  source = "/opt/ancc/webnode/global.js.ctmpl"       // 模版文件地址
  destination = "/opt/ancc/webnode/global.js"        // 模版文件输出地址
  command = "pm2 reload all"                          // 文件生成后执行命令
}