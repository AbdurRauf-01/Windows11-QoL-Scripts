@echo off
:: Automatically elevate the script to Administrator
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Define your network adapter name here
set "ADAPTER=Ethernet 2"

:MENU
cls
echo ================================
echo   DNS Toggle - %ADAPTER%
echo ================================
echo.
echo  1. Quad9
echo  2. Control D (1Hosts - Lite)
echo  3. OpenDNS
echo  4. NextDNS
echo  5. Cloudflare
echo  6. Google
echo  7. Show Current DNS
echo  X. Automatic DNS (DHCP)
echo  0. Exit
echo ================================
choice /c 1234567X0 /n /m "Choose an option: "

if errorlevel 9 exit
if errorlevel 8 goto SET_AUTO
if errorlevel 7 goto SHOW_DNS
if errorlevel 6 goto SET_GOOGLE
if errorlevel 5 goto SET_CLOUDFLARE
if errorlevel 4 goto SET_NEXTDNS
if errorlevel 3 goto SET_OPENDNS
if errorlevel 2 goto SET_CONTROLD
if errorlevel 1 goto SET_QUAD9
goto MENU

:: ─────────────────────────────────
:SET_QUAD9
call :ApplyDNS 9.9.9.9 149.112.112.112 "https://dns11.quad9.net/dns-query" "Quad9"
goto MENU

:SET_CONTROLD
call :ApplyDNS 76.76.2.38 76.76.10.38 "https://freedns.controld.com/x-1hosts-lite" "Control D"
goto MENU

:SET_OPENDNS
call :ApplyDNS 208.67.222.222 208.67.220.220 "https://doh.opendns.com/dns-query" "OpenDNS"
goto MENU

:SET_NEXTDNS
call :ApplyDNS 45.90.28.0 45.90.30.0 "https://dns.nextdns.io/18ec77" "NextDNS"
goto MENU

:SET_CLOUDFLARE
call :ApplyDNS 1.1.1.1 1.0.0.1 "https://cloudflare-dns.com/dns-query" "Cloudflare"
goto MENU

:SET_GOOGLE
call :ApplyDNS 8.8.8.8 8.8.4.4 "https://dns.google/dns-query" "Google"
goto MENU

:: ─────────────────────────────────
:SET_AUTO
echo.
echo Reverting to automatic DNS (DHCP)...
netsh interface ipv4 set dns name="%ADAPTER%" dhcp

:: Wipe the DoH registry settings for this adapter
powershell -NoProfile -Command "$adapter = Get-NetAdapter -Name '%ADAPTER%'; $regPath = \"HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\$($adapter.InterfaceGuid)\DohInterfaceSettings\"; if (Test-Path $regPath) { Remove-Item -Path $regPath -Recurse -Force | Out-Null }"

ipconfig /flushdns >nul
echo.
echo Done! DNS is now obtained automatically, DoH removed.
pause
goto MENU

:: ─────────────────────────────────
:SHOW_DNS
cls
echo --- IPv4 DNS Servers on %ADAPTER% ---
netsh interface ipv4 show dns name="%ADAPTER%"
echo.
echo --- Registered DoH Templates ---
powershell -NoProfile -Command "Get-DnsClientDohServerAddress | Format-Table -AutoSize"
echo.
pause
goto MENU

:: ─────────────────────────────────
:: MASTER FUNCTION: Applies IP, Template, and Registry Flags
:: ─────────────────────────────────
:ApplyDNS
:: %1 = Primary IP, %2 = Secondary IP, %3 = DoH Template, %4 = Name
echo.
echo Applying %~4...
netsh interface ipv4 set dns name="%ADAPTER%" static %1 primary validate=no >nul
netsh interface ipv4 add dns name="%ADAPTER%" %2 index=2 validate=no >nul

:: Register the DoH Templates silently
powershell -NoProfile -Command "Add-DnsClientDohServerAddress -ServerAddress '%1' -DohTemplate '%~3' -AllowFallbackToUdp $False -AutoUpgrade $True -ErrorAction SilentlyContinue; Add-DnsClientDohServerAddress -ServerAddress '%2' -DohTemplate '%~3' -AllowFallbackToUdp $False -AutoUpgrade $True -ErrorAction SilentlyContinue"

:: Target the adapter's GUID and force "Encrypted Only" (DohFlags = 2) via Registry
powershell -NoProfile -Command "$adapter = Get-NetAdapter -Name '%ADAPTER%'; $regPath = \"HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\$($adapter.InterfaceGuid)\DohInterfaceSettings\Doh\"; if (!(Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }; New-ItemProperty -Path \"$regPath\%1\" -Name 'DohFlags' -Value 2 -PropertyType QWORD -Force | Out-Null; New-ItemProperty -Path \"$regPath\%2\" -Name 'DohFlags' -Value 2 -PropertyType QWORD -Force | Out-Null"

ipconfig /flushdns >nul
echo.
echo Done! %~4 applied with DoH enforced.
pause
goto :EOF