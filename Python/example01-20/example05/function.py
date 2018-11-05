"""
知识点:

Python的内置函数
	- 数学相关: abs / divmod / pow / round / min / max / sum
	- 序列相关: len / range / next / filter / map / sorted / slice / reversed
	- 类型转换: chr / ord / str / bool / int / float / complex / bin / oct / hex
	- 数据结构: dict / list / set / tuple
	- 其他函数: all / any / id / input / open / print / type

Python常用模块
	- 运行时服务相关模块: copy / pickle / sys / ...
	- 数学相关模块: decimal / math / random / ...
	- 字符串处理模块: codecs / re / ...
	- 文件处理相关模块: shutil / gzip / ...
	- 操作系统服务相关模块: datetime / os / time / logging / io / ...
	- 进程和线程相关模块: multiprocessing / threading / queue
	- 网络应用相关模块: ftplib / http / smtplib / urllib / ...
	- Web编程相关模块: cgi / webbrowser
	- 数据处理和编码模块: base64 / csv / html.parser / json / xml / ...
"""

def p(arg):
    print(arg)

def foo():
    a = 5   # 局部作用域，局部变量

a = 10  # 全局变量