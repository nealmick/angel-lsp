@echo off
echo [angel-lsp] Building Standalone AngelScript LSP Executables for All Platforms...
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is required to build the executables
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

REM Navigate to server directory
cd server

REM Install dependencies if needed
if not exist "node_modules" (
    echo Installing build dependencies...
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install dependencies
        pause
        exit /b 1
    )
    echo.
)

REM Create dist directory
if not exist "dist" mkdir dist

REM Build executables for all platforms
echo Building standalone executables for Windows, Linux, and macOS...
call npm run build-exe-all
if %errorlevel% neq 0 (
    echo [ERROR] Failed to build executables
    pause
    exit /b 1
)

echo.
echo ✅ SUCCESS! Standalone executables created in server\dist\:
echo.
dir dist
echo.
echo 📋 SUMMARY:
echo    - Windows: angelscript-language-server-win.exe
echo    - Linux:   angelscript-language-server-linux
echo    - macOS:   angelscript-language-server-macos
echo    - File size: ~43MB each
echo    - Dependencies: NONE (completely standalone)
echo    - Can run on any machine without Node.js
echo.
pause