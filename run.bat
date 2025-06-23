@echo off
setlocal


python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found. Downloading installer...

    set "PYTHON_URL=https://www.python.org/ftp/python/3.11.4/python-3.11.4-amd64.exe"
    set "PYTHON_INSTALLER=%TEMP%\python-installer.exe"

    REM Download installer using PowerShell
    powershell -Command "Invoke-WebRequest -Uri %PYTHON_URL% -OutFile '%PYTHON_INSTALLER%'"

    if not exist "%PYTHON_INSTALLER%" (
        echo Failed to download Python installer.
        pause
        exit /b 1
    )

    echo Installing Python silently...
    "%PYTHON_INSTALLER%" /quiet InstallAllUsers=1 PrependPath=1 Include_pip=1

    del "%PYTHON_INSTALLER%"

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
