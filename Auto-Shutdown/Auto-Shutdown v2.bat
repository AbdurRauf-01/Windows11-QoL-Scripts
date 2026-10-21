@echo off
:menu
cls
echo =======================================
echo            Auto Shutdown Manager
echo =======================================
echo  1. Shutdown in 10 minutes (Forced)
echo  2. Shutdown in 30 minutes (Forced)
echo  3. Shutdown in 60 minutes (Forced)
echo  4. Shutdown in 90 minutes (Forced)
echo  5. Shutdown in 120 minutes (Forced)
echo  X. Cancel scheduled shutdown
echo  0. Exit
echo =======================================

:: The choice options are now 1, 2, 3, 4, 5, X, 0
choice /c 12345X0 /n /m "Select option: "

:: Errorlevel corresponds to the position in the /c list (1=1, 2=2, 3=3, 4=4, 5=5, 6=X, 7=0)
if errorlevel 7 exit
if errorlevel 6 goto cancel
if errorlevel 5 goto t120
if errorlevel 4 goto t90
if errorlevel 3 goto t60
if errorlevel 2 goto t30
if errorlevel 1 goto t10
goto menu

:t10
shutdown /a >nul 2>&1
shutdown /s /f /t 600
echo.
echo Shutdown scheduled in 10 minutes. Apps will be forced to close.
pause
goto menu

:t30
shutdown /a >nul 2>&1
shutdown /s /f /t 1800
echo.
echo Shutdown scheduled in 30 minutes. Apps will be forced to close.
pause
goto menu

:t60
shutdown /a >nul 2>&1
shutdown /s /f /t 3600
echo.
echo Shutdown scheduled in 60 minutes. Apps will be forced to close.
pause
goto menu

:t90
shutdown /a >nul 2>&1
shutdown /s /f /t 5400
echo.
echo Shutdown scheduled in 90 minutes. Apps will be forced to close.
pause
goto menu

:t120
shutdown /a >nul 2>&1
shutdown /s /f /t 7200
echo.
echo Shutdown scheduled in 120 minutes. Apps will be forced to close.
pause
goto menu

:cancel
shutdown /a >nul 2>&1
echo.
echo All scheduled shutdowns have been cancelled.
pause
goto menu
