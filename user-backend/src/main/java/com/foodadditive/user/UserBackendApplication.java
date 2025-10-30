package com.foodadditive.user;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 用户端后端启动类
 * 
 * @author 系统
 * @since 2025-01-01
 */
@SpringBootApplication
@MapperScan("com.foodadditive.user.mapper")
public class UserBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(UserBackendApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("用户端后端启动成功！");
        System.out.println("访问地址: http://localhost:8081/api/user");
        System.out.println("Druid监控: http://localhost:8081/api/user/druid");
        System.out.println("========================================\n");
    }
}

