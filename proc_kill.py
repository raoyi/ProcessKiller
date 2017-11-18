#!/usr/bin/env python
#CPU占用率达到一定值后结束指定进程
#请在Python3.3环境执行，并安装psutil库
#以notepad.exe进程为例

import psutil
import os

#为CPU占用率引入变量，默认5%
kill_percent = 5

#无限循环
while True:
    if psutil.cpu_percent() > kill_percent:
        if os.system('tasklist | find "notepad.exe"') == 0:
            os.system('taskkill /f /im notepad.exe')
