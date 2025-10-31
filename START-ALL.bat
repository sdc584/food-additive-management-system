@echo off
echo.
echo ========================================
echo Compiling backend projects...
echo ========================================
echo.

cd user-backend
echo [1/2] Compiling user-backend...
call mvn clean compile
if %errorlevel% neq 0 (
    echo ERROR: user-backend compilation failed!
    pause
    exit /b 1
)
cd ..

cd admin-backend
echo [2/2] Compiling admin-backend...
call mvn clean compile
if %errorlevel% neq 0 (
    echo ERROR: admin-backend compilation failed!
    pause
    exit /b 1
)
cd ..

echo.
echo ========================================
echo Starting all services...
echo ========================================
echo.

start "User-Backend-8081" cmd /k "cd user-backend && mvn spring-boot:run"
timeout /t 3 /nobreak >nul

start "Admin-Backend-8082" cmd /k "cd admin-backend && mvn spring-boot:run"
timeout /t 3 /nobreak >nul

start "User-Frontend-8080" cmd /k "cd user-frontend && npm run serve"
timeout /t 3 /nobreak >nul

start "Admin-Frontend-8083" cmd /k "cd admin-frontend && npm run serve"

echo.
echo ========================================
echo All services are starting...
echo ========================================
echo.
echo User Frontend:  http://localhost:8080
echo Admin Frontend: http://localhost:8083
echo.
echo User Backend:   http://localhost:8081
echo Admin Backend:  http://localhost:8082
echo.
echo Account: admin / 123456
echo.
echo Please wait 30-60 seconds for all services to start...
echo.
pause

