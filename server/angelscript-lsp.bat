@echo off
setlocal enabledelayedexpansion

REM Get the directory where this batch file is located
set "SERVER_DIR=%~dp0"

REM Check if the compiled server exists
if not exist "%SERVER_DIR%angelscript-language-server.js" (
    echo [angel-lsp] Compiled server not found. Attempting to build...
    goto :build_server
)

REM Check if it's older than the source files (basic check)
if exist "%SERVER_DIR%src\server.ts" (
    for %%F in ("%SERVER_DIR%angelscript-language-server.js") do set server_time=%%~tF
    for %%F in ("%SERVER_DIR%src\server.ts") do set source_time=%%~tF
    if "!source_time!" gtr "!server_time!" (
        echo [angel-lsp] Source files are newer than compiled server. Rebuilding...
        goto :build_server
    )
)

REM Server exists and is up to date, run it
goto :run_server

:build_server
echo [angel-lsp] Building AngelScript Language Server...

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

REM Change to server directory
pushd "%SERVER_DIR%"

REM Check if node_modules exists, if not install dependencies
if not exist "node_modules" (
    echo [angel-lsp] Installing dependencies...
    call npm install
    if !errorlevel! neq 0 (
        echo [angel-lsp] ERROR: Failed to install dependencies
        popd
        exit /b 1
    )
)

REM Build the server
echo [angel-lsp] Compiling TypeScript and bundling...
call npm run bundle
if !errorlevel! neq 0 (
    echo [angel-lsp] ERROR: Failed to build server
    popd
    exit /b 1
)

echo [angel-lsp] Build completed successfully
popd

:run_server
REM Run the language server
node "%SERVER_DIR%angelscript-language-server.js" --stdio