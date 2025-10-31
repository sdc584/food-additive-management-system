@echo off
cd /d "%~dp0"
git add admin-frontend/src/views/TestReport.vue admin-frontend/src/views/UsageRecord.vue admin-frontend/src/views/Login.vue admin-backend/src/main/java/com/foodadditive/admin/controller/TestReportController.java
git commit -m "修复检测报告和使用记录的新增功能

- 移除检测报告中不存在的testPerson字段
- 添加检测报告Controller的@OperationLog注解
- 修复登录时userInfo保存，同时包含userId和id字段
- 使用记录提交时添加详细日志输出
- 添加userId为空时的错误提示"
git push origin main
pause

