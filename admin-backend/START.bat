@echo off
title Admin-Backend-8082-NEW
color 0B
echo.
echo ========================================
echo Starting Admin Backend (NEW VERSION)
echo ========================================
echo.
echo Port: 8082
echo API: http://localhost:8082/api/admin
echo New Endpoint: /operationLogs/recent
echo.
echo Please wait for "Started Application"...
echo.

mvn spring-boot:run

