@echo off
setlocal enabledelayedexpansion

:: ����Ҫ��װ������б�
set "software_list=7zip.7zip Microsoft.VisualStudioCode Discord.discord Valve.Steam VideoLAN.VLC"

:: ������б�ת��Ϊ����
set "counter=0"
for %%a in (%software_list%) do (
    set "software[!counter!]=%%a"
    set /a "counter+=1"
)

:: ��ʾ����б�ѯ���û��Ƿ�Ҫ�ų�ĳЩ���
echo �����ǽ�Ҫ��װ������б�
for /L %%i in (0,1,%counter%) do (
    if defined software[%%i] (
        echo %%i. !software[%%i]!
    )
)

set "exclude_list="
set /p "exclude=�����벻��Ҫ��װ�������ţ��ÿո�ָ������ţ���ֱ�ӻس���װ�������: "

:: ����û��������ų��б�������
if not "%exclude%"=="" (
    for %%i in (%exclude%) do (
        set "software[%%i]="
    )
)

:: ��װ���
for /L %%i in (0,1,%counter%) do (
    if defined software[%%i] (
        echo.
        echo ���ڰ�װ !software[%%i]! ...
        winget install !software[%%i]!
    )
)

echo.
echo ��װ��ɡ�
pause
