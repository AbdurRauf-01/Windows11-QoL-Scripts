@echo off
:: Self-elevate
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Startup Status Check
cls
echo =======================================
echo        System Security Status Check
echo =======================================
echo Checking Defender settings...
echo.

:: Queries PowerShell for the true/false status and sets a batch variable
for /f "delims=" %%i in ('powershell -Command "(Get-MpComputerStatus).IsTamperProtected"') do set "TamperStatus=%%i"

if /i "%TamperStatus%"=="True" (
    echo [STATUS] Tamper Protection: ENABLED (System Settings Locked)
) else (
    echo [STATUS] Tamper Protection: ⚠️ DISABLED (System Settings Vulnerable)
)
echo =======================================
echo.
echo Press any key to enter the Policy Manager...
pause >nul

:menu
cls
echo =======================================
echo          Execution Policy Manager
echo =======================================
echo  1. Check Tamper Protection Status
echo  2. View Current Execution Policies
echo  3. Set to Restricted (Strict / Default)
echo  4. Set to Unrestricted (⚠️ DANGEROUS)
echo  5. Set to RemoteSigned (Recommended)
echo  0. Exit
echo =======================================

:: Updated choice options ordered: 1, 2, 3, 4, 5, 0
choice /c 123450 /n /m "Select option: "

if errorlevel 6 exit
if errorlevel 5 goto remotesigned
if errorlevel 4 goto unrestricted
if errorlevel 3 goto restricted
if errorlevel 2 goto get
if errorlevel 1 goto checktamper
goto menu

:checktamper
cls
echo Checking Tamper Protection Status...
echo ---------------------------------------
for /f "delims=" %%i in ('powershell -Command "(Get-MpComputerStatus).IsTamperProtected"') do set "TamperStatus=%%i"

if /i "%TamperStatus%"=="True" (
    echo Tamper Protection is currently: ENABLED
    echo (Defender settings cannot be altered by scripts or malware.)
) else (
    echo ⚠️ Tamper Protection is currently: DISABLED
    echo (System configurations are unprotected from script modifications.)
)
echo ---------------------------------------
echo.
pause
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