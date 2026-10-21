@echo off
:: Self-elevate
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:menu
cls
echo =======================================
echo          Execution Policy Manager
echo =======================================
echo  1. View Current Execution Policies
echo  2. Set to Restricted (Strict / Default)
echo  3. Set to Unrestricted (⚠️ DANGEROUS)
echo  4. Set to RemoteSigned (Recommended)
echo  0. Exit
echo =======================================

:: Safe choice menu (1, 2, 3, 4, 0)
choice /c 12340 /n /m "Select option: "

if errorlevel 5 exit
if errorlevel 4 goto remotesigned
if errorlevel 3 goto unrestricted
if errorlevel 2 goto restricted
if errorlevel 1 goto get
goto menu

:get
cls
echo Current PowerShell Execution Policies:
echo ---------------------------------------
powershell -Command "Get-ExecutionPolicy -List"
echo ---------------------------------------
echo.
pause
goto menu

:restricted
cls
echo Setting Execution Policy to Restricted...
powershell -Command "Set-ExecutionPolicy Restricted -Scope LocalMachine -Force"
echo Done.
timeout /t 2 >nul
goto menu

:unrestricted
cls
echo ⚠️ WARNING: Setting Execution Policy to Unrestricted...
powershell -Command "Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force"
echo Done.
timeout /t 2 >nul
goto menu

:remotesigned
cls
echo Setting Execution Policy to RemoteSigned...
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force"
echo Done.
timeout /t 2 >nul
goto menu