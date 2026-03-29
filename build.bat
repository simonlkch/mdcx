@echo off
setlocal

REM Build helper for Windows.
REM Usage:
REM   build.bat              -> run official build, fallback to manual pyinstaller on failure
REM   build.bat --no-fallback -> run official build only

cd /d "%~dp0"

if not exist "venv\Scripts\python.exe" (
    echo [ERROR] Missing venv Python: venv\Scripts\python.exe
    echo Create or restore the virtual environment first.
    exit /b 1
)

call "venv\Scripts\activate.bat"
if errorlevel 1 (
    echo [ERROR] Failed to activate virtual environment.
    exit /b 1
)

chcp 65001 >nul
set "PYTHONIOENCODING=utf-8"

echo [1/3] Installing build dependencies...
python -m pip install -U pyinstaller rich
if errorlevel 1 (
    echo [ERROR] Dependency installation failed.
    exit /b 1
)

echo [2/3] Running official build script...
python scripts\build.py --no-color
if not errorlevel 1 goto success

echo [WARN] Official build script failed.
if /I "%~1"=="--no-fallback" goto fail

echo [3/3] Running fallback pyinstaller build...
pyi-makespec --name MDCx --noupx --onefile -w main.py -p .\mdcx --add-data resources:resources --add-data libs:. --icon resources/Img/MDCx.icns --hidden-import _cffi_backend --collect-all curl_cffi --collect-all patchright
if errorlevel 1 goto fail

pyinstaller MDCx.spec -y --workpath build_new --distpath dist
if errorlevel 1 goto fail

:success
echo [OK] Build completed.
echo Output: dist\MDCx.exe
exit /b 0

:fail
echo [ERROR] Build failed.
exit /b 1
