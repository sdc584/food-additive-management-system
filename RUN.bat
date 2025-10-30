@echo off
start "User-Backend-8081" cmd /k "cd user-backend && mvn spring-boot:run"
timeout /t 2 /nobreak >nul
start "Admin-Backend-8082" cmd /k "cd admin-backend && mvn spring-boot:run"
timeout /t 2 /nobreak >nul
start "User-Frontend-8080" cmd /k "cd user-frontend && npm run serve"
timeout /t 2 /nobreak >nul
start "Admin-Frontend-8083" cmd /k "cd admin-frontend && npm run serve"
echo.
echo All services starting...
echo.
echo User Frontend:  http://localhost:8080
echo Admin Frontend: http://localhost:8083
echo.
echo Account: admin / 123456
echo.
timeout /t 60 /nobreak
start http://localhost:8080

