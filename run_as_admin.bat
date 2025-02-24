@echo off
:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Running the script as Administrator...
    powershell -command "Start-Process cmd -ArgumentList '/c install_dotnet.bat' -Verb RunAs"
    echo Powershell Setting : Start-Process cmd -ArgumentList '/c install_dotnet.bat' -Verb RunAs Admin
    exit /b
)

echo Call the main installation script ...
call install_dotnet.bat
echo install_dotnet.bat successful.