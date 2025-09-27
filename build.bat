@echo off
echo [angel-lsp] Building AngelScript Language Server...

REM Build the server
cd server
call npm install
if %errorlevel% neq 0 (
    echo [angel-lsp] ERROR: Failed to install dependencies
    exit /b 1
)

call npm run bundle
if %errorlevel% neq 0 (
    echo [angel-lsp] ERROR: Failed to build server
    exit /b 1
)

cd ..
echo [angel-lsp] Build completed! Server ready at: server\angelscript-lsp.bat