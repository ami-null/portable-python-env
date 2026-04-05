@echo off
setlocal enabledelayedexpansion

:: Configuration
set "ROOT_DIR=%~dp0python_and_vscode"
set "VSCODE_DIR=%ROOT_DIR%\vscode"
set "TEMP_ZIP=%TEMP%\vscode_download.zip"

echo [4/6] Setting up VS Code (Portable Mode)...

:: Check if directory exists
if exist "%VSCODE_DIR%" (
    set /p "choice=VS Code folder already exists. Overwrite? (Y/N): "
    if /i "!choice!" neq "Y" (
        echo Skipping VS Code download.
        exit /b 0
    )
    rd /s /q "%VSCODE_DIR%"
)

echo Downloading latest VS Code (Windows x64 Zip)...

:: PowerShell to download the stable Zip version
powershell -ExecutionPolicy Bypass -Command ^
    "$url = 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive';" ^
    "Invoke-WebRequest -Uri $url -OutFile '%TEMP_ZIP%';" ^
    "Write-Host 'Extracting...';" ^
    "Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath '%VSCODE_DIR%' -Force;" ^
    "if (Test-Path '%TEMP_ZIP%') { Remove-Item -Path '%TEMP_ZIP%' -Force };"

:: Enable Portable Mode
if not exist "%VSCODE_DIR%\data" mkdir "%VSCODE_DIR%\data"

echo VS Code extracted. Installing Python Extension Pack...

:: Use the local 'code' binary to install extensions
:: Note: This uses the CLI inside the bin folder
set "CODE_BIN=%VSCODE_DIR%\bin\code.cmd"

call "%CODE_BIN%" --install-extension ms-python.python --force
call "%CODE_BIN%" --install-extension ms-python.vscode-pylance --force
call "%CODE_BIN%" --install-extension ms-toolsai.jupyter --force

if %ERRORLEVEL% equ 0 (
    echo.
    echo VS Code is ready in Portable Mode.
    echo Extensions installed: Python, Pylance.
) else (
    echo.
    echo Failed to install extensions.
    exit /b 1
)

if "%~1" neq "/nopause" pause