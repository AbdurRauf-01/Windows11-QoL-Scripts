@echo off
:: Self-elevate for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:status_check
cls
echo =======================================
echo         Current Security Status
echo =======================================
powershell -Command "$t = (Get-MpComputerStatus).IsTamperProtected; $p = Get-MpPreference; $np = if ($p.EnableNetworkProtection -eq 1) { 'True' } else { 'False' }; $cfa = if ($p.EnableControlledFolderAccess -eq 1) { 'True' } else { 'False' }; $asrBlock = @($p.AttackSurfaceReductionRules_Actions -eq 1).Count; $asrWarn = @($p.AttackSurfaceReductionRules_Actions -eq 6).Count; $asrAudit = @($p.AttackSurfaceReductionRules_Actions -eq 2).Count; $asrDisabled = @($p.AttackSurfaceReductionRules_Actions -eq 0).Count; Write-Host '--- Core Protections ---'; Write-Host 'Tamper Protection          :' $t; Write-Host 'Network Protection         :' $np; Write-Host 'Controlled Folder Access   :' $cfa; Write-Host ''; Write-Host '--- Attack Surface Reduction (ASR) ---'; Write-Host 'Active (Block)             :' $asrBlock; Write-Host 'Warning Mode               :' $asrWarn; Write-Host 'Audit Mode                 :' $asrAudit; Write-Host 'Disabled                   :' $asrDisabled;"
echo =======================================
echo.
pause

:main_menu
cls
echo ===============================================================================
echo                 Defender ASR Rules Manager (Individual Toggle)
echo ===============================================================================
echo  1. Block abuse of exploited vulnerable signed drivers
echo     GUID: 56A863A9-875E-4185-98A7-B882C64B5CE5
echo.
echo  2. Block Adobe Reader from creating child processes
echo     GUID: 7674BA52-37EB-4A4F-A9A1-F0F9A1619A2C
echo.
echo  3. Block all Office applications from creating child processes
echo     GUID: D4F940AB-401B-4EFC-AADC-AD5F3C50688A
echo.
echo  4. Block executable content from email client and webmail
echo     GUID: BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550
echo.
echo  5. Block executable files from running unless they meet prevalence/age/trust
echo     GUID: 01443614-CD74-433A-B99E-2ECDC07BFC25
echo.
echo  6. Block execution of potentially obfuscated scripts
echo     GUID: 5BEB7EFE-FD9A-4556-801D-275E5FFC04CC
echo.
echo  7. Block JavaScript or VBScript from launching downloaded executable content
echo     GUID: D3E037E1-3EB8-44C8-A917-57927947596D
echo.
echo  8. Block Office applications from creating executable content
echo     GUID: 3B576869-A4EC-4529-8536-B80A7769E899
echo.
echo  9. Block Office applications from injecting code into other processes
echo     GUID: 75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84
echo.
echo 10. Block Office communication application from creating child processes
echo     GUID: 26190899-1602-49E8-8B27-EB1D0A1CE869
echo.
echo 11. Block persistence through WMI event subscription
echo     GUID: E6DB77E5-3DF2-4CF1-B95A-636979351E5B
echo.
echo 12. Block credential stealing from the Windows LSASS
echo     GUID: 9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2
echo.
echo 13. Block process creations originating from PSExec and WMI commands
echo     GUID: D1E49AAC-8F56-4280-B9BA-993A6D77406C
echo.
echo 14. Block untrusted and unsigned processes that run from USB
echo     GUID: B2B3F03D-6A65-4F7B-A9C7-1C7EF74A9BA4
echo.
echo 15. Block web shell creation for Servers
echo     GUID: A8F5898E-1DC8-49A9-9878-85004B8A61E6
echo.
echo 16. Block Win32 API calls from Office macros
echo     GUID: 92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B
echo.
echo 17. Use advanced protection against ransomware
echo     GUID: C1DB55AB-C21A-4637-BB3F-A12568109D35
echo.
echo 18. Block use of copied or impersonated system tools
echo     GUID: C0033C00-D16D-4114-A5A0-DC9B3A7D2CEB
echo.
echo 19. Block rebooting machine in Safe Mode
echo     GUID: 33DDEDF1-C6E0-47CB-833E-DE6133960387
echo.
echo -------------------------------------------------------------------------------
echo  0. Exit
echo  S. Run Status Check Again
echo ===============================================================================

set /p "opt=Select an option (0-19, or S): "

if /i "%opt%"=="S" goto status_check
if "%opt%"=="0" exit
if "%opt%"=="1" call :ConfigureRule "56A863A9-875E-4185-98A7-B882C64B5CE5" "Block abuse of exploited vulnerable signed drivers"
if "%opt%"=="2" call :ConfigureRule "7674BA52-37EB-4A4F-A9A1-F0F9A1619A2C" "Block Adobe Reader from creating child processes"
if "%opt%"=="3" call :ConfigureRule "D4F940AB-401B-4EFC-AADC-AD5F3C50688A" "Block all Office applications from creating child processes"
if "%opt%"=="4" call :ConfigureRule "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550" "Block executable content from email client and webmail"
if "%opt%"=="5" call :ConfigureRule "01443614-CD74-433A-B99E-2ECDC07BFC25" "Block executable files from running unless they meet prevalence criteria"
if "%opt%"=="6" call :ConfigureRule "5BEB7EFE-FD9A-4556-801D-275E5FFC04CC" "Block execution of potentially obfuscated scripts"
if "%opt%"=="7" call :ConfigureRule "D3E037E1-3EB8-44C8-A917-57927947596D" "Block JavaScript or VBScript from launching downloaded executable content"
if "%opt%"=="8" call :ConfigureRule "3B576869-A4EC-4529-8536-B80A7769E899" "Block Office applications from creating executable content"
if "%opt%"=="9" call :ConfigureRule "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84" "Block Office applications from injecting code into other processes"
if "%opt%"=="10" call :ConfigureRule "26190899-1602-49E8-8B27-EB1D0A1CE869" "Block Office communication application from creating child processes"
if "%opt%"=="11" call :ConfigureRule "E6DB77E5-3DF2-4CF1-B95A-636979351E5B" "Block persistence through WMI event subscription"
if "%opt%"=="12" call :ConfigureRule "9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2" "Block credential stealing from the Windows LSASS"
if "%opt%"=="13" call :ConfigureRule "D1E49AAC-8F56-4280-B9BA-993A6D77406C" "Block process creations originating from PSExec and WMI commands"
if "%opt%"=="14" call :ConfigureRule "B2B3F03D-6A65-4F7B-A9C7-1C7EF74A9BA4" "Block untrusted and unsigned processes that run from USB"
if "%opt%"=="15" call :ConfigureRule "A8F5898E-1DC8-49A9-9878-85004B8A61E6" "Block web shell creation for Servers"
if "%opt%"=="16" call :ConfigureRule "92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B" "Block Win32 API calls from Office macros"
if "%opt%"=="17" call :ConfigureRule "C1DB55AB-C21A-4637-BB3F-A12568109D35" "Use advanced protection against ransomware"
if "%opt%"=="18" call :ConfigureRule "C0033C00-D16D-4114-A5A0-DC9B3A7D2CEB" "Block use of copied or impersonated system tools"
if "%opt%"=="19" call :ConfigureRule "33DDEDF1-C6E0-47CB-833E-DE6133960387" "Block rebooting machine in Safe Mode"
goto main_menu

:ConfigureRule
cls
echo ==========================================================
echo Rule: %~2
echo GUID: %~1
echo ==========================================================
echo  0. Disable
echo  1. Enable (Block)
echo  2. Warn
echo  3. Audit
echo  4. Not Configured (Delete Preference)
echo ----------------------------------------------------------
echo  B. Back to Main Menu
echo ==========================================================
choice /c 01234B /n /m "Select state for this rule (0-4, or B to go back): "

if errorlevel 6 goto :eof
if errorlevel 5 set action=NotConfigured
if errorlevel 4 set action=2
if errorlevel 3 set action=6
if errorlevel 2 set action=1
if errorlevel 1 set action=0

if "%action%"=="NotConfigured" (
    echo.
    echo Removing preference (Setting to Not Configured)...
    powershell -Command "Remove-MpPreference -AttackSurfaceReductionRules_Ids '%~1'"
) else (
    echo.
    echo Applying setting...
    powershell -Command "Add-MpPreference -AttackSurfaceReductionRules_Ids '%~1' -AttackSurfaceReductionRules_Actions %action%"
)

echo Done!
timeout /t 2 >nul
goto :eof