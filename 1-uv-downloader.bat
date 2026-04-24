@echo off
setlocal enabledelayedexpansion

:: Configuration
set "ROOT_DIR=%~dp0dependencies"
set "UV_DIR=%ROOT_DIR%\uv"
set "TEMP_ZIP=%TEMP%\uv_download.zip"
set "HELPER_SCRIPTS_DIR=%ROOT_DIR%\helper_scripts\"

echo Setting up uv...

:: Check if directory exists
if exist "%UV_DIR%" (
    set /p "choice=The 'uv' folder already exists. Overwrite and download the latest uv version? (Y/N): "
    if /i "!choice!" neq "Y" (
        echo Skipping uv download.
        exit /b 0
    )
    rd /s /q "%UV_DIR%"
)

:: Ensure root and uv directory exists
if not exist "%UV_DIR%" mkdir "%UV_DIR%"

echo Fetching latest release info from GitHub...

set "GH_USER=astral-sh"
set "GH_REPO=uv"

echo Resolving latest release... >&2

for /f "delims=" %%U in ('call "%HELPER_SCRIPTS_DIR%get-gh-release.bat" %GH_USER% %GH_REPO% windows x86_64 zip msvc -sha256') do (
    set "DOWNLOAD_URL=%%U"
)
if "!DOWNLOAD_URL!"=="" (
    echo ERROR: Could not resolve direct download URL. >&2
    exit /b 1
)
echo Downloading: !DOWNLOAD_URL! >&2

curl -fSL --progress-bar -o %ROOT_DIR%\uv.zip "!DOWNLOAD_URL!"
if %ERRORLEVEL% neq 0 (
    echo ERROR: curl failed ^(exit code %ERRORLEVEL%^) while downloading: >&2
    echo        %DOWNLOAD_URL% >&2
    exit /b 1
)
echo Download complete. >&2


for /f "delims=" %%F in ('tar -tf %ROOT_DIR%\uv.zip ^| findstr /r "uv\.exe$"') do (
    REM echo Found: %%F
    
    :: 2. Extract that specific path and redirect the stream to your target file
    tar -xOf %ROOT_DIR%\uv.zip "%%F" > "%UV_DIR%\uv.exe"
    
    :: 3. Exit after the first match is found
    goto :done
)
:done
echo Extraction complete.
:: Deleting uv.zip
del /q %ROOT_DIR%\uv.zip


if %ERRORLEVEL% equ 0 (
    echo uv successfully set up in %UV_DIR%
    "%UV_DIR%\uv.exe" --version
) else (
    echo Failed to set up uv.
    exit /b 1
)

if "%~1" neq "/nopause" pause