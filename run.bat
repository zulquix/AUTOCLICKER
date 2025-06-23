@echo off
setlocal

REM Check if python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found. Downloading installer...

    REM Define Python installer URL (latest 3.11.x 64-bit web installer)
    set "PYTHON_URL=https://www.python.org/ftp/python/3.11.4/python-3.11.4-amd64.exe"
    set "PYTHON_INSTALLER=%TEMP%\python-installer.exe"

    REM Download installer using PowerShell
    powershell -Command "Invoke-WebRequest -Uri %PYTHON_URL% -OutFile '%PYTHON_INSTALLER%'"

    REM Check if downloaded
    if not exist "%PYTHON_INSTALLER%" (
        echo Failed to download Python installer.
        pause
        exit /b 1
    )

    echo Installing Python silently...
    "%PYTHON_INSTALLER%" /quiet InstallAllUsers=1 PrependPath=1 Include_pip=1

    REM Delete installer after install
    del "%PYTHON_INSTALLER%"

    REM Check install success
    python --version >nul 2>&1
    if %errorlevel% neq 0 (
        echo Python installation failed.
        pause
        exit /b 1
    )
) else (
    echo Python is already installed.
)

echo Upgrading pip...
python -m pip install --upgrade pip

echo Installing pynput...
python -m pip install pynput

echo Done.
pause
