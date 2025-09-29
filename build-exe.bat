@echo off
echo [angel-lsp] Building Standalone AngelScript LSP Executable...
echo.

REM Check if Node.js is installed (required for building only)
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is required to build the executable
    echo Please install Node.js from https://nodejs.org/
    echo.
    echo Note: The final executable will NOT require Node.js to run
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

REM Build the standalone executable
echo Building standalone executable...
call npm run build-exe
if %errorlevel% neq 0 (
    echo [ERROR] Failed to build executable
    pause
    exit /b 1
)

echo.
echo ✅ SUCCESS! Standalone executable created: server\angelscript-lsp.exe
echo.
echo 📋 SUMMARY:
echo    - File size: ~43MB
echo    - Dependencies: NONE (completely standalone)
echo    - Can run on any Windows machine without Node.js
echo    - Use with: angelscript-lsp.exe --stdio
echo.
echo 🚀 To test: echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"capabilities":{}}}' ^| angelscript-lsp.exe --stdio
echo.
pause