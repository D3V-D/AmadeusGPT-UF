@echo off
setlocal EnableExtensions EnableDelayedExpansion
pushd "%~dp0"
title UF AmadeusGPT Launcher

echo             __
echo        -. (#)(#) .-
echo         '\.';;'./'
echo      .-\.'  ;;  './-.
echo        ;    ;;    ;
echo        ;   .''.   ;
echo         '''    '''

echo =================================
echo  UF AmadeusGPT Laboratory Portal
echo =================================

:: ===================================================
:: 1. ENVIRONMENT CONFIGURATION
:: ===================================================

:: Use the virtual environment created by the setup script
if not exist ".venv" (
    echo [+] Environment not found. Initializing Python 3.11 environment...
    uv python install 3.11 >nul 2>&1
    uv venv --python 3.11
)

echo [+] Checking/Syncing scientific libraries...
:: This ensures libraries are present; 'uv' is fast enough to run this on every launch
uv pip install --python 3.11 ^
    amadeusgpt streamlit streamlit-drawable-canvas ^
    deeplabcut opencv-python-headless python-dotenv ^
    "streamlit<1.35.0" "setuptools<70.0.0"

:: Explicitly point to UF's NaviGator API and essential app flags [cite: 15, 16]
set "OPENAI_BASE_URL=https://api.ai.it.ufl.edu/v1"
set "OPENAI_API_KEY=placeholder-key-replace-me"
set "PYTHONPATH=%~dp0;%PYTHONPATH%"
set "streamlit_app=True"
set "STREAMLIT_CHECK_UPDATE_RUNS=false"

:: ===================================================
:: 2. AUTOMATIC BROWSER LAUNCH
:: ===================================================

echo [+] Initializing local server...
echo [NOTICE] This window will minimize once the portal is ready.

:: Minimize terminal and open localhost once the port is active [cite: 16]
start /b powershell -windowstyle minimized -command "$wait = 0; while($wait -lt 30) { try { $t = New-Object System.Net.Sockets.TcpClient('127.0.0.1', 8501); $t.Close(); start 'http://localhost:8501'; break } catch { Start-Sleep -s 1; $wait++ } }" 

:: ===================================================
:: 3. EXECUTION
:: ===================================================

echo [NOTICE] Keep this terminal open while using AmadeusGPT.

:: Run the app using the 'uv' context to ensure the correct environment [cite: 17]
uv run --no-project --python 3.11 streamlit run amadeusgpt\app.py ^
    --server.headless true ^
    --server.maxUploadSize 1000 ^
    --global.developmentMode false ^
    --client.showErrorDetails false ^
    --browser.gatherUsageStats false

if %errorlevel% neq 0 (
    echo.
    echo [!] Application closed with an error. Check logs above.
    pause
)
popd