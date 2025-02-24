@echo off
:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Running the script as Administrator...
    powershell -command "Start-Process cmd -ArgumentList '/c install_dotnet.bat' -Verb RunAs"
    echo Powershell Setting : Start-Process cmd -ArgumentList '/c install_dotnet.bat' -Verb RunAs Admin
:: Array of .NET Framework versions and their download URLs
set "dotnet_versions=4.5:https://dotnet.microsoft.com/en-us/download/dotnet-framework/net45;4.6:https://dotnet.microsoft.com/en-us/download/dotnet-framework/net46;4.7:https://dotnet.microsoft.com/en-us/download/dotnet-framework/net47;4.8:https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48;5.0:https://dotnet.microsoft.com/en-us/download/dotnet/5.0;6.0:https://dotnet.microsoft.com/en-us/download/dotnet/6.0;7.0:https://dotnet.microsoft.com/en-us/download/dotnet/7.0;8.0:https://dotnet.microsoft.com/en-us/download/dotnet/8.0"

for %%v in (%dotnet_versions%) do (
    for /f "tokens=1,2 delims=:" %%a in ("%%v") do (
        :: Downloading .NET Framework installer
        echo Downloading .NET Framework %%a...
        powershell.exe -command "Start-BitsTransfer -Source %%b -Destination C:\Temp\dotnetfx_%%a.exe"

        :: Silently installing .NET Framework
        echo Installing .NET Framework %%a...
        C:\Temp\dotnetfx_%%a.exe /q /norestart
    )
)

echo All specified .NET Framework versions have been installed.
pause
    exit /b
)

