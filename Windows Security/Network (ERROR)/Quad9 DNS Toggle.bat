@echo off
:: DNS Toggle Script - Quad9 / Automatic (DHCP)
:: Adapter: Ethernet 2
:: Run as Administrator

:MENU
cls
echo ================================
echo   DNS Toggle - Ethernet 2
echo ================================
echo.
echo  [1] Set Quad9 DNS (Static + DoH)
echo  [2] Set Automatic DNS (DHCP)
echo  [3] Show Current DNS
echo  [0] Exit
echo.
set /p choice=Choose an option: 

if "%choice%"=="1" goto SET_STATIC
if "%choice%"=="2" goto SET_AUTO
if "%choice%"=="3" goto SHOW_DNS
if "%choice%"=="0" exit
goto MENU

:: ─────────────────────────────────
:SET_STATIC
echo.
echo Applying Quad9 static DNS...

:: Set DNS servers
netsh interface ipv4 set dns name="Ethernet 2" static 9.9.9.9 primary
netsh interface ipv4 add dns name="Ethernet 2" 149.112.112.112 index=2

:: Register DoH templates
netsh dns add encryption server=9.9.9.9        dohtemplate=https://dns11.quad9.net/dns-query autoupgrade=yes udpfallback=no
netsh dns add encryption server=149.112.112.112 dohtemplate=https://dns11.quad9.net/dns-query autoupgrade=yes udpfallback=no

:: Get interface index for "Ethernet 2"
for /f "tokens=1" %%i in ('netsh interface ipv4 show interfaces ^| findstr /i "Ethernet 2"') do set IF_IDX=%%i

:: Enable DoH via registry
:: DohFlags: 1 = on (allow plaintext fallback), 2 = required (no fallback)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\9.9.9.9"        /v DohFlags /t REG_QWORD /d 2 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\149.112.112.112" /v DohFlags /t REG_QWORD /d 2 /f >nul

:: Restart DNS Client to apply changes
net stop dnscache /y >nul 2>&1
net start dnscache >nul 2>&1

echo.
echo Done!
echo   Primary  : 9.9.9.9
echo   Alternate: 149.112.112.112
echo   DoH      : Required (enforced, no plaintext fallback)
echo.
pause
goto MENU

:: ─────────────────────────────────
:SET_AUTO
echo.
echo Reverting to automatic DNS (DHCP)...

:: Get interface index
for /f "tokens=1" %%i in ('netsh interface ipv4 show interfaces ^| findstr /i "Ethernet 2"') do set IF_IDX=%%i

:: Remove DoH registry entries
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings" /f >nul 2>&1

:: Remove DoH templates
netsh dns delete encryption server=9.9.9.9        >nul 2>&1
netsh dns delete encryption server=149.112.112.112 >nul 2>&1

:: Revert DNS to DHCP
netsh interface ipv4 set dns name="Ethernet 2" dhcp

:: Restart DNS Client
net stop dnscache /y >nul 2>&1
net start dnscache >nul 2>&1

echo.
echo Done! DNS is now obtained automatically, DoH removed.
echo.
pause
goto MENU

:: ─────────────────────────────────
:SHOW_DNS
echo.
echo --- IPv4 DNS Servers ---
netsh interface ipv4 show dns name="Ethernet 2"
echo.
echo --- DoH Encryption Settings ---
netsh dns show encryption
echo.
pause
goto MENU
