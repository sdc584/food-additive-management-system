@echo off
title Stop All Services
color 0C

echo.
echo ========================================
echo   Stopping All Services
echo ========================================
echo.

set /a count=0

for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8081" ^| findstr "LISTENING"') do (
    echo Stopping User Backend (port 8081, PID %%a)
    taskkill /F /PID %%a >nul 2>&1
    set /a count+=1
)

for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8082" ^| findstr "LISTENING"') do (
    echo Stopping Admin Backend (port 8082, PID %%a)
    taskkill /F /PID %%a >nul 2>&1
    set /a count+=1
)

for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8080" ^| findstr "LISTENING"') do (
    echo Stopping User Frontend (port 8080, PID %%a)
    taskkill /F /PID %%a >nul 2>&1
    set /a count+=1
)

for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":8083" ^| findstr "LISTENING"') do (
    echo Stopping Admin Frontend (port 8083, PID %%a)
    taskkill /F /PID %%a >nul 2>&1
    set /a count+=1
)

echo.
if %count% gtr 0 (
    echo Stopped %count% service(s)
) else (
    echo No running services found
)

echo.
echo ========================================
echo.
pause

