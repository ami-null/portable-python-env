@echo off
setlocal

:: Configuration - Paths relative to this script
set "ROOT_DIR=%~dp0python_and_vscode"
set "PYTHON_DIR=%ROOT_DIR%\python"
set "UV_DIR=%ROOT_DIR%\uv"
set "VSCODE_BIN_DIR=%ROOT_DIR%\vscode\bin"

:: 1. Validation
if not exist "%PYTHON_DIR%\python.exe" (
    echo ERROR: Portable Python not found. Please run setup_all.bat first.
    pause
    exit /b 1
)

echo Initializing Portable Environment...

:: 2. Temporary Environment Modification (Current Session Only)
:: Prepend our portable folders to PATH so 'python' and 'uv' resolve to our local versions
set "PATH=%PYTHON_DIR%;%PYTHON_DIR%\Scripts;%UV_DIR%;%VSCODE_BIN_DIR%;%PATH%"

:: Set PYTHONHOME to ensure the interpreter uses its own internal Libs
set "PYTHONHOME=%PYTHON_DIR%"

:: 3. Launch VS Code
echo Launching VS Code...
echo [Environment: Python %PYTHON_DIR%]

:: Start VS Code in the current directory (.) 
:: Using 'start' lets the batch window close while VS Code stays open
start "" "code.cmd" .

echo.
echo Launching complete. You can close this window.
timeout /t 3 >nul
exit /b 0