@echo off
:: DNS Toggle Script
:: Adapter: Ethernet 2
:: Run as Administrator

:MENU
cls
echo ================================
echo   DNS Toggle - Ethernet 2
echo ================================
echo.
echo  [0]  Automatic DNS (DHCP)
echo  [1]  Quad9
echo  [2]  Control D (1Hosts - Lite)
echo  [3]  OpenDNS
echo  [4]  NextDNS
echo  [5]  Cloudflare
echo  [6]  Google
echo  [7]  Show Current DNS
echo  [00] Exit
echo.
set /p choice=Choose an option: 

if "%choice%"=="0"  goto SET_AUTO
if "%choice%"=="1"  goto SET_QUAD9
if "%choice%"=="2"  goto SET_CONTROLD
if "%choice%"=="3"  goto SET_OPENDNS
if "%choice%"=="4"  goto SET_NEXTDNS
if "%choice%"=="5"  goto SET_CLOUDFLARE
if "%choice%"=="6"  goto SET_GOOGLE
if "%choice%"=="7"  goto SHOW_DNS
if "%choice%"=="00" exit
goto MENU

:: ─────────────────────────────────
:SET_QUAD9
echo.
echo Applying Quad9...
netsh interface ipv4 set dns name="Ethernet 2" static 9.9.9.9 primary
netsh interface ipv4 add dns name="Ethernet 2" 149.112.112.112 index=2
netsh dns add encryption server=9.9.9.9 dohtemplate=https://dns11.quad9.net/dns-query autoupgrade=yes udpfallback=no
netsh dns add encryption server=149.112.112.112 dohtemplate=https://dns11.quad9.net/dns-query autoupgrade=yes udpfallback=no
for /f "tokens=1" %%i in ('netsh interface ipv4 show interfaces ^| findstr /i "Ethernet 2"') do set IF_IDX=%%i
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\9.9.9.9" /v DohFlags /t REG_QWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\149.112.112.112" /v DohFlags /t REG_QWORD /d 2 /f
net stop dnscache /y >nul 2>&1
net start dnscache >nul 2>&1
echo.
echo Done! Quad9 applied with DoH enforced.
echo.
pause
goto MENU

:: ─────────────────────────────────
:SET_CONTROLD
echo.
echo Applying Control D (1Hosts - Lite)...
netsh interface ipv4 set dns name="Ethernet 2" static 76.76.2.38 primary
netsh interface ipv4 add dns name="Ethernet 2" 76.76.10.38 index=2
netsh dns add encryption server=76.76.2.38 dohtemplate=https://freedns.controld.com/x-1hosts-lite autoupgrade=yes udpfallback=no
netsh dns add encryption server=76.76.10.38 dohtemplate=https://freedns.controld.com/x-1hosts-lite autoupgrade=yes udpfallback=no
for /f "tokens=1" %%i in ('netsh interface ipv4 show interfaces ^| findstr /i "Ethernet 2"') do set IF_IDX=%%i
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\76.76.2.38" /v DohFlags /t REG_QWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\76.76.10.38" /v DohFlags /t REG_QWORD /d 2 /f
net stop dnscache /y >nul 2>&1
net start dnscache >nul 2>&1
echo.
echo Done! Control D applied with DoH enforced.
echo.
pause
goto MENU

:: ─────────────────────────────────
:SET_OPENDNS
echo.
echo Applying OpenDNS...
netsh interface ipv4 set dns name="Ethernet 2" static 208.67.222.222 primary
netsh interface ipv4 add dns name="Ethernet 2" 208.67.220.220 index=2
netsh dns add encryption server=208.67.222.222 dohtemplate=https://doh.opendns.com/dns-query autoupgrade=yes udpfallback=no
netsh dns add encryption server=208.67.220.220 dohtemplate=https://doh.opendns.com/dns-query autoupgrade=yes udpfallback=no
for /f "tokens=1" %%i in ('netsh interface ipv4 show interfaces ^| findstr /i "Ethernet 2"') do set IF_IDX=%%i
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\208.67.222.222" /v DohFlags /t REG_QWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\208.67.220.220" /v DohFlags /t REG_QWORD /d 2 /f
net stop dnscache /y >nul 2>&1
net start dnscache >nul 2>&1
echo.
echo Done! OpenDNS applied with DoH enforced.
echo.
pause
goto MENU

:: ─────────────────────────────────
:SET_NEXTDNS
echo.
echo Applying NextDNS...
netsh interface ipv4 set dns name="Ethernet 2" static 45.90.28.0 primary
netsh interface ipv4 add dns name="Ethernet 2" 45.90.30.0 index=2
netsh dns add encryption server=45.90.28.0 dohtemplate=https://dns.nextdns.io/18ec77 autoupgrade=yes udpfallback=no
netsh dns add encryption server=45.90.30.0 dohtemplate=https://dns.nextdns.io/18ec77 autoupgrade=yes udpfallback=no
for /f "tokens=1" %%i in ('netsh interface ipv4 show interfaces ^| findstr /i "Ethernet 2"') do set IF_IDX=%%i
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\45.90.28.0" /v DohFlags /t REG_QWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\45.90.30.0" /v DohFlags /t REG_QWORD /d 2 /f
net stop dnscache /y >nul 2>&1
net start dnscache >nul 2>&1
echo.
echo Done! NextDNS applied with DoH enforced.
echo.
pause
goto MENU

:: ─────────────────────────────────
:SET_CLOUDFLARE
echo.
echo Applying Cloudflare...
netsh interface ipv4 set dns name="Ethernet 2" static 1.1.1.1 primary
netsh interface ipv4 add dns name="Ethernet 2" 1.0.0.1 index=2
netsh dns add encryption server=1.1.1.1 dohtemplate=https://cloudflare-dns.com/dns-query autoupgrade=yes udpfallback=no
netsh dns add encryption server=1.0.0.1 dohtemplate=https://cloudflare-dns.com/dns-query autoupgrade=yes udpfallback=no
for /f "tokens=1" %%i in ('netsh interface ipv4 show interfaces ^| findstr /i "Ethernet 2"') do set IF_IDX=%%i
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\1.1.1.1" /v DohFlags /t REG_QWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\1.0.0.1" /v DohFlags /t REG_QWORD /d 2 /f
net stop dnscache /y >nul 2>&1
net start dnscache >nul 2>&1
echo.
echo Done! Cloudflare applied with DoH enforced.
echo.
pause
goto MENU

:: ─────────────────────────────────
:SET_GOOGLE
echo.
echo Applying Google...
netsh interface ipv4 set dns name="Ethernet 2" static 8.8.8.8 primary
netsh interface ipv4 add dns name="Ethernet 2" 8.8.4.4 index=2
netsh dns add encryption server=8.8.8.8 dohtemplate=https://dns.google/dns-query autoupgrade=yes udpfallback=no
netsh dns add encryption server=8.8.4.4 dohtemplate=https://dns.google/dns-query autoupgrade=yes udpfallback=no
for /f "tokens=1" %%i in ('netsh interface ipv4 show interfaces ^| findstr /i "Ethernet 2"') do set IF_IDX=%%i
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\8.8.8.8" /v DohFlags /t REG_QWORD /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings\dns\8.8.4.4" /v DohFlags /t REG_QWORD /d 2 /f
net stop dnscache /y >nul 2>&1
net start dnscache >nul 2>&1
echo.
echo Done! Google applied with DoH enforced.
echo.
pause
goto MENU

:: ─────────────────────────────────
:SET_AUTO
echo.
echo Reverting to automatic DNS (DHCP)...
for /f "tokens=1" %%i in ('netsh interface ipv4 show interfaces ^| findstr /i "Ethernet 2"') do set IF_IDX=%%i
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\%IF_IDX%\DohInterfaceSettings" /f >nul 2>&1
netsh dns delete encryption server=9.9.9.9          >nul 2>&1
netsh dns delete encryption server=149.112.112.112   >nul 2>&1
netsh dns delete encryption server=76.76.2.38        >nul 2>&1
netsh dns delete encryption server=76.76.10.38       >nul 2>&1
netsh dns delete encryption server=208.67.222.222    >nul 2>&1
netsh dns delete encryption server=208.67.220.220    >nul 2>&1
netsh dns delete encryption server=45.90.28.0        >nul 2>&1
netsh dns delete encryption server=45.90.30.0        >nul 2>&1
netsh dns delete encryption server=1.1.1.1           >nul 2>&1
netsh dns delete encryption server=1.0.0.1           >nul 2>&1
netsh dns delete encryption server=8.8.8.8           >nul 2>&1
netsh dns delete encryption server=8.8.4.4           >nul 2>&1
netsh interface ipv4 set dns name="Ethernet 2" dhcp
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
