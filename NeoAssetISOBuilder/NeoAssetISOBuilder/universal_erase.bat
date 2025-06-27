@echo off
setlocal EnableDelayedExpansion

rem Directory for log files
set LOG_DIR=X:\Logs
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
set LOG_TXT=%LOG_DIR%\erase_report.txt
set LOG_HTML=%LOG_DIR%\erase_report.html

echo NeoAsset Universal Erase Report > "%LOG_TXT%"
echo ^<html^><body^><pre^>NeoAsset Universal Erase Report^<br/^> > "%LOG_HTML%"

for /f "skip=1 tokens=1,*" %%A in ('wmic diskdrive get Index^,Model 2^>NUL ^| findstr /R "^[0-9]"') do (
    set IDX=%%A
    set MODEL=%%B
    call :ERASE !IDX! "!MODEL!"
)

echo ^</pre^></body^></html^> >> "%LOG_HTML%"
endlocal
exit /b

:ERASE
set IDX=%~1
set MODEL=%~2
set ACTION=Skipped
set EXE=

rem Determine vendor-specific erase utility
echo %MODEL% | findstr /I "Samsung" >nul && set EXE=SamsungSecureErase_x64.exe
echo %MODEL% | findstr /I "Hynix"   >nul && set EXE=SKHynix_secure_erase_winpe40_x64.exe
echo %MODEL% | findstr /I "LiteOn"  >nul && set EXE=LiteON_erase_x64.exe

if defined EXE (
    "X:\Program Files\NeoAsset\IHV\%EXE%" /s %IDX%
    if not errorlevel 1 (
        set ACTION=Success
    ) else (
        set ACTION=Error
    )
) else (
    set ACTION=Skipped
)

echo Drive %IDX% - %MODEL% : %ACTION%>> "%LOG_TXT%"
echo Drive %IDX% - %MODEL% : %ACTION%^<br/^> >> "%LOG_HTML%"
exit /b
