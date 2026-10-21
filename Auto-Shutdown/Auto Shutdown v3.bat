@echo off
:menu
cls
echo =======================================
echo            Auto Shutdown Manager
echo =======================================
echo  1. Shutdown in 10 minutes
echo  2. Shutdown in 30 minutes (0.5 Hours)
echo  3. Shutdown in 60 minutes (1 Hour)
echo  4. Shutdown in 90 minutes (1.5 Hours)
echo  5. Shutdown in 120 minutes (2 Hours)
echo  6. Shutdown in 150 minutes (2.5 Hours)
echo  7. Shutdown in 180 minutes (3 Hours)
echo  8. Shutdown in 210 minutes (3.5 Hours)
echo  9. Shutdown in 240 minutes (4 Hours)
echo  X. Cancel scheduled shutdown
echo  0. Exit
echo =======================================

:: The choice options are now 1, 2, 3, 4, 5, 6, 7, 8, 9, X, 0
choice /c 123456789X0 /n /m "Select option: "

:: Errorlevel corresponds to the position in the /c list (descending order)
if errorlevel 11 exit
if errorlevel 10 goto cancel
if errorlevel 9 goto t240
if errorlevel 8 goto t210
if errorlevel 7 goto t180
if errorlevel 6 goto t150
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
echo Shutdown scheduled in 30 minutes (0.5 Hours). Apps will be forced to close.
pause
goto menu

:t60
shutdown /a >nul 2>&1
shutdown /s /f /t 3600
echo.
echo Shutdown scheduled in 60 minutes (1 Hour). Apps will be forced to close.
pause
goto menu

:t90
shutdown /a >nul 2>&1
shutdown /s /f /t 5400
echo.
echo Shutdown scheduled in 90 minutes (1.5 Hours). Apps will be forced to close.
pause
goto menu

:t120
shutdown /a >nul 2>&1
shutdown /s /f /t 7200
echo.
echo Shutdown scheduled in 120 minutes (2 Hours). Apps will be forced to close.
pause
goto menu

:t150
shutdown /a >nul 2>&1
shutdown /s /f /t 9000
echo.
echo Shutdown scheduled in 150 minutes (2.5 Hours). Apps will be forced to close.
pause
goto menu

:t180
shutdown /a >nul 2>&1
shutdown /s /f /t 10800
echo.
echo Shutdown scheduled in 180 minutes (3 Hours). Apps will be forced to close.
pause
goto menu

:t210
shutdown /a >nul 2>&1
shutdown /s /f /t 12600
echo.
echo Shutdown scheduled in 210 minutes (3.5 Hours). Apps will be forced to close.
pause
goto menu

:t240
shutdown /a >nul 2>&1
shutdown /s /f /t 14400
echo.
echo Shutdown scheduled in 240 minutes (4 Hours). Apps will be forced to close.
pause
goto menu

:cancel
shutdown /a >nul 2>&1
echo.
echo All scheduled shutdowns have been cancelled.
pause
goto menu