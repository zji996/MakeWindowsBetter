@echo off
setlocal enabledelayedexpansion

:: 定义要安装的软件列表
set "software_list=7zip.7zip Microsoft.VisualStudioCode Discord.discord Valve.Steam VideoLAN.VLC"

:: 将软件列表转换为数组
set "counter=0"
for %%a in (%software_list%) do (
    set "software[!counter!]=%%a"
    set /a "counter+=1"
)

:: 显示软件列表并询问用户是否要排除某些软件
echo 以下是将要安装的软件列表：
for /L %%i in (0,1,%counter%) do (
    if defined software[%%i] (
        echo %%i. !software[%%i]!
    )
)

set "exclude_list="
set /p "exclude=请输入不需要安装的软件编号（用空格分隔多个编号），直接回车则安装所有软件: "

:: 如果用户输入了排除列表，则处理它
if not "%exclude%"=="" (
    for %%i in (%exclude%) do (
        set "software[%%i]="
    )
)

:: 安装软件
for /L %%i in (0,1,%counter%) do (
    if defined software[%%i] (
        echo.
        echo 正在安装 !software[%%i]! ...
        winget install !software[%%i]!
    )
)

echo.
echo 安装完成。
pause
