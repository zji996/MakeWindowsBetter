@echo off
NET SESSION >nul 2>&1
if %errorLevel% == 0 (
goto :admin
) else (
echo �˽ű���Ҫ����ԱȨ�޲������С�
echo ���Ҽ�����˽ű���ѡ��"�Թ���Ա�������"��
echo ��������˳�...
pause >nul
exit
)

:admin
echo �����Թ���Ա������нű���

:start
echo �˽ű����޸ĵ�Դ���á��Ƿ������
choice /c YN /m "��ѡ�� Y (��) �� N (��)"
if errorlevel 2 goto end

echo.
echo �޸�ע�������ʾ�߼���Դ����...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9" /v "Attributes" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364" /v "Attributes" /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\75b0ae3f-bce0-45a7-8c89-c9611c25e100" /v "Attributes" /t REG_DWORD /d 2 /f > nul

echo �Ѿ���ʾ�߼���Դ���á�

echo.
echo ���ô���״̬�µ�����������Ϊ���ã�������ֱ����Դ��...
powercfg /setacvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 > nul
powercfg /setdcvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 > nul

echo.
set /p hibernateTime=������ʹ�õ��ʱ������ʱ�䣨���ӣ�����ֱ�Ӱ��س�ʹ��Ĭ��ֵ��240���ӣ���
if "%hibernateTime%"=="" set hibernateTime=240

set /a hibernateSeconds=%hibernateTime% * 60
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE %hibernateSeconds% > nul

echo.
:input_freq
set /p maxFreq=�����봦�������Ƶ�ʣ�MHz������ֱ�Ӱ��س�ʹ��Ĭ��ֵ��2100MHz������СֵΪ1000MHz��
if "%maxFreq%"=="" set maxFreq=2100
if %maxFreq% LSS 1000 (
    echo �����Ƶ��̫�͡���СֵΪ1000MHz�����������롣
    goto input_freq
)
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCFREQMAX %maxFreq% > nul

echo.
echo ����ʹ�õ��ʱ�Ĺر���ʾ����ʹ���������˯��״̬ʱ��Ϊ5����...
powercfg /setdcvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 300 > nul
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 300 > nul

echo ���ý�ͨ��Դʱ�Ĺر���ʾ��ʱ��Ϊ10���ӣ�����˯��״̬ʱ��Ϊ1Сʱ...
powercfg /setacvalueindex SCHEME_CURRENT SUB_VIDEO VIDEOIDLE 600 > nul
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 3600 > nul

echo ����������ʾ�ڵ�Դ�˵���...
powercfg /HIBERNATE ON > nul

powercfg /availablesleepstates

echo.
echo Ӧ�ø���...
powercfg /setactive SCHEME_CURRENT > nul

echo.
echo ��������ɣ�
echo - ����ʾ�߼���Դ����
echo - �����ô���״̬�µ�����������Ϊ����
echo - ������ʹ�õ��ʱ������ʱ��Ϊ %hibernateTime% ���ӣ�%hibernateSeconds% �룩
echo - �����ô��������Ƶ��Ϊ %maxFreq% MHz
echo - ������ʹ�õ��ʱ�Ĺر���ʾ����ʹ���������˯��״̬ʱ��Ϊ5����
echo - �����ý�ͨ��Դʱ�Ĺر���ʾ��ʱ��Ϊ10���ӣ�����˯��״̬ʱ��Ϊ1Сʱ
echo - ������������ʾ�ڵ�Դ�˵���

:end
echo.
pause
