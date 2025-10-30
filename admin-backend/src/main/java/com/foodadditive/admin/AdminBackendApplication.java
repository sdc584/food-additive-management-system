package com.foodadditive.admin;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 管理端后端启动类
 * 
 * @author 系统
 * @since 2025-01-01
 */
@SpringBootApplication
@MapperScan("com.foodadditive.admin.mapper")
public class AdminBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(AdminBackendApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("管理端后端启动成功！");
        System.out.println("访问地址: http://localhost:8082/api/admin");
        System.out.println("Druid监控: http://localhost:8082/api/admin/druid");
        System.out.println("========================================\n");
    }
}

