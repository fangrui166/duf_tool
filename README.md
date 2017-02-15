dfuse-tool
==========

This is a set of python scripts to create dfu files and upload them to stm32 boards

使用方法：
1.	将附件解压到任意目录
2.	修改link_hmd.cmd中“set projectPath=..\Link\link_hmd\SYS\EWARM”，此路径填写你代码的实际路径
3.	使设备进入DFU mode
4.	双击start.bat后输入 link_hmd.cmd sys debug 即开始编译和下载
第一个参数可以是 bl0、bl1、sys
第二个参数可以是 debug、release
