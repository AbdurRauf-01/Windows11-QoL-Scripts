@echo off
:: Self-elevate
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:menu
cls
echo ================================
echo     ASR Rules Manager
echo ================================
echo  1. Enable ASR Rules
echo  2. Disable All ASR Rules
echo  0. Exit
echo ================================
set /p choice=Select option: 

if "%choice%"=="1" goto enable
if "%choice%"=="2" goto disable
if "%choice%"=="0" exit
goto menu

:enable
cls
echo Applying ASR rules...
powershell -Command ^
    "$EnabledRules = @('56A863A9-875E-4185-98A7-B882C64B5CE5','7674BA52-37EB-4A4F-A9A1-F0F9A1619A2C','D4F940AB-401B-4EFC-AADC-AD5F3C50688A','BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550','3B576869-A4EC-4529-8536-B80A7769E899','75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84','26190899-1602-49E8-8B27-EB1D0A1CE869','E6DB77E5-3DF2-4CF1-B95A-636979351E5B','92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B','C1DB55AB-C21A-4637-BB3F-A12568109D35','A8F5898E-1DC8-49A9-9878-85004B8A61E6'); ^
    $WarnRules = @('9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2','01443614-CD74-433A-B99E-2ECDC07BFC25','5BEB7EFE-FD9A-4556-801D-275E5FFC04CC','D3E037E1-3EB8-44C8-A917-57927947596D','D1E49AAC-8F56-4280-B9BA-993A6D77406C','B2B3F03D-6A65-4F7B-A9C7-1C7EF74A9BA4','C0033C00-D16D-4114-A5A0-DC9B3A7D2CEB'); ^
    foreach ($rule in $EnabledRules) { Add-MpPreference -AttackSurfaceReductionRules_Ids $rule -AttackSurfaceReductionRules_Actions Enabled; Write-Host 'Enabled:' $rule }; ^
    foreach ($rule in $WarnRules) { Add-MpPreference -AttackSurfaceReductionRules_Ids $rule -AttackSurfaceReductionRules_Actions Warn; Write-Host 'Warn:' $rule }; ^
    Add-MpPreference -AttackSurfaceReductionRules_Ids '33DDEDF1-C6E0-47CB-833E-DE6133960387' -AttackSurfaceReductionRules_Actions Disabled; Write-Host 'Disabled: 33DDEDF1'"
echo.
echo Done.
pause
goto menu

:disable
cls
echo Disabling all ASR rules...
powershell -Command ^
    "$AllRules = @('56A863A9-875E-4185-98A7-B882C64B5CE5','7674BA52-37EB-4A4F-A9A1-F0F9A1619A2C','D4F940AB-401B-4EFC-AADC-AD5F3C50688A','BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550','3B576869-A4EC-4529-8536-B80A7769E899','75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84','26190899-1602-49E8-8B27-EB1D0A1CE869','E6DB77E5-3DF2-4CF1-B95A-636979351E5B','92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B','C1DB55AB-C21A-4637-BB3F-A12568109D35','A8F5898E-1DC8-49A9-9878-85004B8A61E6','9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2','01443614-CD74-433A-B99E-2ECDC07BFC25','5BEB7EFE-FD9A-4556-801D-275E5FFC04CC','D3E037E1-3EB8-44C8-A917-57927947596D','D1E49AAC-8F56-4280-B9BA-993A6D77406C','B2B3F03D-6A65-4F7B-A9C7-1C7EF74A9BA4','C0033C00-D16D-4114-A5A0-DC9B3A7D2CEB','33DDEDF1-C6E0-47CB-833E-DE6133960387'); ^
    foreach ($rule in $AllRules) { Add-MpPreference -AttackSurfaceReductionRules_Ids $rule -AttackSurfaceReductionRules_Actions Disabled; Write-Host 'Disabled:' $rule }"
echo.
echo Done.
pause
goto menu