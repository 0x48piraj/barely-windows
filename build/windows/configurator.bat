@echo off
REM --- Check for Windows Version (Windows 10 or Windows 11) and Architecture (32-bit or 64-bit)

REM Get Windows version and architecture
for /f "tokens=2 delims==" %%I in ('"wmic os get caption /value"') do set "OSVersion=%%I"
for /f "tokens=2 delims==" %%I in ('"wmic os get osarchitecture /value"') do set "OSArchitecture=%%I"

echo Detected Windows Version: %OSVersion%
echo Detected Architecture: %OSArchitecture%

REM --- Choose the correct configuration based on OS and architecture
if /I "%OSVersion%"=="Microsoft Windows 10" (
    echo Windows 10 detected
    if /I "%OSArchitecture%"=="64-bit" (
        echo 64-bit architecture detected. Running script for Windows 10 x64...
        powershell -ExecutionPolicy Bypass -File "%~dp0build_windows10_64.ps1"
    ) else (
        echo 32-bit architecture detected. Running script for Windows 10 x86...
        powershell -ExecutionPolicy Bypass -File "%~dp0build_windows10_32.ps1"
    )
) else if /I "%OSVersion%"=="Microsoft Windows 11" (
    echo Windows 11 detected
    if /I "%OSArchitecture%"=="64-bit" (
        echo 64-bit architecture detected. Running script for Windows 11 x64...
        powershell -ExecutionPolicy Bypass -File "%~dp0build_windows11_64.ps1"
    ) else (
        echo 32-bit architecture detected. Running script for Windows 11 x86...
        powershell -ExecutionPolicy Bypass -File "%~dp0build_windows11_32.ps1"
    )
) else (
    echo Unsupported OS detected. Exiting...
    exit /b
)

echo Script completed successfully!
pause
