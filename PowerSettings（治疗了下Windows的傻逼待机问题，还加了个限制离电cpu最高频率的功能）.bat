@echo off
NET SESSION >nul 2>&1
if %errorLevel% == 0 (
goto :admin
) else (
echo 此脚本需要管理员权限才能运行。
echo 请右键点击此脚本，选择"以管理员身份运行"。
echo 按任意键退出...
pause >nul
exit
)

:admin
echo 正在以管理员身份运行脚本。

:start
echo 此脚本将修改电源设置。是否继续？
choice /c YN /m "请选择 Y (是) 或 N (否)"
if errorlevel 2 goto end

echo.
echo 修改注册表以显示高级电源设置...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9" /v "Attributes" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364" /v "Attributes" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "Attributes" /t REG_DWORD /d 2 /f > nul

echo 已经显示高级电源设置。

echo.
echo 设置待机状态下的网络连接性为禁用（交流和直流电源）...
powercfg /setacvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 > nul
powercfg /setdcvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 > nul

echo.
set /p hibernateTime=请输入使用电池时的休眠时间（分钟），或直接按回车使用默认值（240分钟）：
if "%hibernateTime%"=="" set hibernateTime=240

set /a hibernateSeconds=%hibernateTime% * 60
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE %hibernateSeconds% > nul

echo.
:input_freq
set /p maxFreq=请输入处理器最大频率（MHz），或直接按回车使用默认值（2100MHz）。最小值为1000MHz：
if "%maxFreq%"=="" set maxFreq=2100
if %maxFreq% LSS 1000 (
    echo 输入的频率太低。最小值为1000MHz。请重新输入。
    goto input_freq
)
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCFREQMAX %maxFreq% > nul

echo.
echo 设置使用电池时的关闭显示器和使计算机进入睡眠状态时间为5分钟...
powercfg /setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 300 > nul
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 300 > nul

echo 设置接通电源时的关闭显示器时间为10分钟，进入睡眠状态时间为1小时...
powercfg /setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 600 > nul
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 3600 > nul

echo 设置休眠显示在电源菜单中...
powercfg /HIBERNATE ON > nul

powercfg /availablesleepstates

echo.
echo 应用更改...
powercfg /setactive SCHEME_CURRENT > nul

echo.
echo 设置已完成：
echo - 已显示高级电源设置
echo - 已设置待机状态下的网络连接性为禁用
echo - 已设置使用电池时的休眠时间为 %hibernateTime% 分钟（%hibernateSeconds% 秒）
echo - 已设置处理器最大频率为 %maxFreq% MHz
echo - 已设置使用电池时的关闭显示器和使计算机进入睡眠状态时间为5分钟
echo - 已设置接通电源时的关闭显示器时间为10分钟，进入睡眠状态时间为1小时
echo - 已设置休眠显示在电源菜单中

:end
echo.
pause
