@echo off
setlocal enabledelayedexpansion

:: Configuration
set "ROOT_DIR=%~dp0python_and_vscode"
set "SCRIPTS_DIR=%~dp0"

echo ====================================================
echo   PORTABLE DATA SCIENCE ENVIRONMENT SETUP
echo ====================================================
echo.

:: Ensure the root directory exists
if not exist "%ROOT_DIR%" (
    echo Creating root directory: %ROOT_DIR%
    mkdir "%ROOT_DIR%"
)

:: 1. Run uv Downloader
echo.
echo [STEP 1/4] Downloading uv...
call "%SCRIPTS_DIR%1-uv-downloader.bat" /nopause
if %ERRORLEVEL% neq 0 goto :error

:: 2. Run Python Downloader
echo.
echo [STEP 2/4] Downloading Python...
call "%SCRIPTS_DIR%2-python-downloader.bat" /nopause
if %ERRORLEVEL% neq 0 goto :error

:: 3. Run Package Installer
echo.
echo [STEP 3/4] Installing Python Packages...
call "%SCRIPTS_DIR%3-python-pkgs-installer.bat" /nopause
if %ERRORLEVEL% neq 0 goto :error

:: 4. Run VS Code Setup
echo.
echo [STEP 4/4] Setting up VS Code...
call "%SCRIPTS_DIR%4-vscode-downloader.bat" /nopause
if %ERRORLEVEL% neq 0 goto :error

echo.
echo ====================================================
echo   SETUP COMPLETE!
echo   Your environment is ready in: %ROOT_DIR%
echo   Use 'open-vscode.bat' to start working.
echo ====================================================
pause
exit /b 0

:error
echo.
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo   An error occurred during the setup process.
echo   Please check the logs above.
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
pause
exit /b 1