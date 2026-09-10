@echo off
REM ============================================================
REM  Bonus Tracker App - Unified Dart Formatter (Windows)
REM ============================================================
REM  Run this script BEFORE pushing your code to avoid
REM  formatting conflicts between team members.
REM
REM  Usage:
REM    Double-click format.bat   OR   run in terminal: format.bat
REM ============================================================

REM ── Navigate to project root (where this script lives) ──────
cd /d "%~dp0"

echo.
echo ======================================================
echo    Bonus Tracker - Unified Code Formatter
echo ======================================================
echo.

REM ── Find dart (check PATH first, then common install locations) ──
where dart >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [INFO] 'dart' not in PATH, searching common locations...

    REM Check common Flutter install paths
    if exist "%USERPROFILE%\development\flutter\bin\dart.bat" (
        set "PATH=%USERPROFILE%\development\flutter\bin;%PATH%"
        echo [OK] Found dart at: %USERPROFILE%\development\flutter\bin
        goto :dart_found
    )
    if exist "%USERPROFILE%\flutter\bin\dart.bat" (
        set "PATH=%USERPROFILE%\flutter\bin;%PATH%"
        echo [OK] Found dart at: %USERPROFILE%\flutter\bin
        goto :dart_found
    )
    if exist "%USERPROFILE%\fvm\default\bin\dart.bat" (
        set "PATH=%USERPROFILE%\fvm\default\bin;%PATH%"
        echo [OK] Found dart at: %USERPROFILE%\fvm\default\bin
        goto :dart_found
    )
    if exist "C:\flutter\bin\dart.bat" (
        set "PATH=C:\flutter\bin;%PATH%"
        echo [OK] Found dart at: C:\flutter\bin
        goto :dart_found
    )
    if exist "C:\src\flutter\bin\dart.bat" (
        set "PATH=C:\src\flutter\bin;%PATH%"
        echo [OK] Found dart at: C:\src\flutter\bin
        goto :dart_found
    )

    echo [ERROR] 'dart' command not found!
    echo    Make sure Flutter/Dart is installed and in your PATH.
    echo.
    pause
    exit /b 1
)
:dart_found

echo Formatting all Dart files in lib/ and test/ ...
echo.

REM ── Run dart format ─────────────────────────────────────────
REM --page-width=80   : Standard Dart line length (consistent for everyone)

if exist "lib" (
    echo --- Formatting lib/ ---
    dart format --page-width=80 lib/
    echo.
)

if exist "test" (
    echo --- Formatting test/ ---
    dart format --page-width=80 test/
    echo.
)

echo ======================================================
echo    Formatting complete!
echo    Don't forget to review the changes before committing.
echo ======================================================
echo.

pause
