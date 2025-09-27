@echo off
setlocal enabledelayedexpansion

echo [angel-lsp] Setting up AngelScript Language Server...

REM Check if Node.js is installed
node --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [angel-lsp] ERROR: Node.js is not installed or not in PATH
    echo [angel-lsp] Please install Node.js from https://nodejs.org/
    exit /b 1
)

REM Check if npm is available
npm --version >nul 2>&1
if !errorlevel! neq 0 (
    echo [angel-lsp] ERROR: npm is not available
    exit /b 1
)

REM Install root dependencies if needed
if not exist "node_modules" (
    echo [angel-lsp] Installing root dependencies...
    call npm install
    if !errorlevel! neq 0 (
        echo [angel-lsp] ERROR: Failed to install root dependencies
        exit /b 1
    )
)

REM Build the server
echo [angel-lsp] Building server...
pushd server

if not exist "node_modules" (
    echo [angel-lsp] Installing server dependencies...
    call npm install
    if !errorlevel! neq 0 (
        echo [angel-lsp] ERROR: Failed to install server dependencies
        popd
        exit /b 1
    )
)

echo [angel-lsp] Compiling and bundling server...
call npm run bundle
if !errorlevel! neq 0 (
    echo [angel-lsp] ERROR: Failed to build server
    popd
    exit /b 1
)

popd

echo [angel-lsp] Build completed successfully!
echo [angel-lsp] You can now use the language server with ned.
echo [angel-lsp] Server executable: %~dp0server\angelscript-lsp.bat
pause