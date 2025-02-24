# BATScript
Windows BAT Script for Setting.
*** RUN AS ADMINISTRATOR PERMISSION ***
###
@echo off
:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Running the script as Administrator...
REM 1. Change Computer Name
wmic computersystem where name="%computername%" call rename name="GemsLabs"


REM 2.Set Static IP AND Network Seeting
netsh interface ipv4 set address name="Ethernet" static 192.168.1.100 255.255.255.0 192.168.1.1

REM Set DNS
netsh interface ipv4 set dns name="Ethernet" static 8.8.8.8 primary
netsh interface ipv4 add dns name="Ethernet" 8.8.4.4 index=2

REM Join Workgroup
wmic computersystem where caption='%computername%' call joindomainorworkgroup name="WORKGROUP"

REM Join Domain (uncomment the line below and replace with actual domain and credentials)
REM netdom join %computername% /domain:YourDomain /userD:YourUsername /passwordD:YourPassword

REM 3.-4.Set Time Zone

REM Set Time Zone to Thailand (Bangkok)
tzutil /s "SE Asia Standard Time"

REM Set Date and Time Format
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sShortDate /t REG_SZ /d "yyyy-MM-dd" /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sLongTime /t REG_SZ /d "HH:mm:ss" /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sTimeFormat /t REG_SZ /d "HH:mm:ss" /f


REM 5.Set never sleep
powercfg -change -standby-timeout-ac 0
powercfg -change -monitor-timeout-ac 0
powercfg -change -disk-timeout-ac 0

REM 6.Reboot System
shutdown -r -t 10
exit /b
)
###
