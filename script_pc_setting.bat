@echo off
REM Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    call :echoWithTimestamp "Please run this script as Administrator."

REM Set UAC to low
echo [%date% %time%"] "Setting User Account Control to low..."
reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f

REM  Function to echo messages with timestamp
setlocal enabledelayedexpansion
REM :echoWithTimestamp
set "timestamp=%date% %time%"
set "message=%~1"
REM echo [%timestamp%] %message%
REM goto :eof

REM 1. Change Computer Name
echo [%date% %time%"] "rename ComputerName=GemsAnalyzer"
wmic computersystem where name="%computername%" call rename name="GemsAnalyzer"

REM 2.Set Static IP AND Network Seeting
echo [%date% %time%"] "Set Static IP AND Network Seting name='Ethernet' static 172.17.4.100 255.255.255.0"
netsh interface ipv4 set address name="Ethernet" static 172.17.4.100 255.255.255.0 172.17.4.1

REM Set DNS
echo [%date% %time%"] "set dns name='Ethernet' static 8.8.8.8 primary
netsh interface ipv4 set dns name="Ethernet" static 8.8.8.8 primary
echo [%date% %time%"] "set dns name='Ethernet' add dns name="Ethernet" 8.8.4.4 index=2
netsh interface ipv4 add dns name="Ethernet" 8.8.4.4 index=2

REM Join Workgroup
echo [%date% %time%"] Join Domain caption='%computername%' call joindomainorworkgroup name='WORKGROUP'
REM wmic computersystem where caption='%computername%' call joindomainorworkgroup name="WORKGROUP"

REM Join Domain (uncomment the line below and replace with actual domain and credentials)
REM netdom join %computername% /domain:YourDomain /userD:YourUsername /passwordD:YourPassword

REM 3.-4.Set Time Zone
echo [%date% %time%"] Set Time Zone to Thailand (Bangkok)
tzutil /s "SE Asia Standard Time"

REM Set Date and Time Format
echo [%date% %time%"] Set ShortDate yyyy-MM-dd
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sShortDate /t REG_SZ /d "yyyy-MM-dd" /f
echo [%date% %time%"] Set LongTime HH:mm:ss
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sLongTime /t REG_SZ /d "HH:mm:ss" /f
echo [%date% %time%"] Set TimeFormat HH:mm:ss
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sTimeFormat /t REG_SZ /d "HH:mm:ss" /f


REM 5.Set never sleep
echo [%date% %time%"] Set never sleep standby-timeout-ac 0, monitor-timeout-ac 0, disk-timeout-ac 0
powercfg -change -standby-timeout-ac 0
powercfg -change -monitor-timeout-ac 0
powercfg -change -disk-timeout-ac 0

REM  Stopping Windows Update Service
echo [%date% %time%"] Stopping Windows Update Service...
net stop wuauserv

REM  Disabling Windows Update Service
echo [%date% %time%"] Disabling Windows Update Service...
sc config wuauserv start= disabled

echo [%timestamp%] Windows Update Service has been disabled."

REM 6.Install Component
echo [%date% %time%"] Dotnet framwork Install
REM Extract Source Application and Dotnet SDK to C:\temp\App_dotnet\ 
SourceApp.exe
set "SOURCE_PATH=C:\temp\App_dotnet\"
%SOURCE_PATH%\Dotnet\dotnet-sdk-4.8.1-win-x64.exe /q /norestart
%SOURCE_PATH%\Dotnet\dotnet-sdk-5.0.408-win-x64.exe /q /norestart
%SOURCE_PATH%\Dotnet\dotnet-sdk-6.0.428-win-x64.exe /q /norestart
%SOURCE_PATH%\Dotnet\dotnet-sdk-7.0.410-win-x64.exe /q /norestart
%SOURCE_PATH%\Dotnet\dotnet-sdk-8.0.405-win-x64.exe /q /norestart
%SOURCE_PATH%\Dotnet\dotnet-sdk-9.0.101-win-x64.exe /q /norestart
%SOURCE_PATH%\Analyzer\Analyzer.exe

REM 7.Set Desktop Shortcut and Startup
echo [%date% %time%"] Set Desktop Shortcut and Startup
REM  Replace with the path to your `.bat` script or any executable
set "TARGET_PATH=D:\Gems\Analyzer\LabInfoManagement.Analyzer_Interface.App.exe"

REM  Friendly name for the shortcut
set "SHORTCUT_NAME=Analyzer"

REM  Path to the Startup folder
set "STARTUP_PATH=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

REM  Create the shortcut in the Desktop folder
powershell -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\Desktop\Analyzer.lnk');$s.TargetPath='%TARGET_PATH%';$s.Save()"

REM  Create the shortcut in the Startup folder
powershell -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Analyzer.lnk');$s.TargetPath='%TARGET_PATH%';$s.Save()"

REM call :echoWithTimestamp "Disabling Windows Update Service..."
sc config wuauserv start= disabled

REM Set UAC to Default
echo [%date% %time%"] "Setting User Account Control to Default..."
reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f

echo [%date% %time%"] Finish install.

REM Reboot System
echo [%date% %time%"] Wait to restart now...
pause
shutdown -r -t 5
exit /b
)
