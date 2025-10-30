package com.foodadditive.generator;

import com.baomidou.mybatisplus.generator.FastAutoGenerator;
import com.baomidou.mybatisplus.generator.config.OutputFile;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

import java.util.Collections;

/**
 * MyBatis Plus 代码生成器
 * 
 * 使用说明:
 * 1. 将此文件复制到 user-backend 或 admin-backend 项目中
 * 2. 修改数据库连接信息
 * 3. 修改包名 (USER_PACKAGE 或 ADMIN_PACKAGE)
 * 4. 运行main方法
 * 5. 代码将自动生成到指定目录
 * 
 * @author 系统
 * @since 2025-01-01
 */
public class CodeGenerator {

    // ==================== 配置区域 ====================
    
    // 数据库配置
    private static final String DB_URL = "jdbc:mysql://localhost:3306/food_additive_system?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "root";
    
    // 用户端包名
    private static final String USER_PACKAGE = "com.foodadditive.user";
    
    // 管理端包名
    private static final String ADMIN_PACKAGE = "com.foodadditive.admin";
    
    // 作者名
    private static final String AUTHOR = "系统";
    
    // 项目路径 (修改为你的实际路径)
    private static final String USER_PROJECT_PATH = "E:/桌面/食品/food-additive-system/user-backend";
    private static final String ADMIN_PROJECT_PATH = "E:/桌面/食品/food-additive-system/admin-backend";
    
    // 需要生成的表名
    private static final String[] TABLES = {
        "sys_user",
        "additive_category",
        "food_additive",
        "supplier",
        "purchase_record",
        "inventory",
        "usage_record",
        "test_report",
        "warning",
        "operation_log"
    };
    
    // ==================== 主方法 ====================
    
    public static void main(String[] args) {
        System.out.println("========================================");
        System.out.println("请选择要生成的项目:");
        System.out.println("1. 用户端后端 (user-backend)");
        System.out.println("2. 管理端后端 (admin-backend)");
        System.out.println("========================================");
        
        // 这里可以通过Scanner读取用户输入，简化起见直接指定
        int choice = 1; // 1=用户端, 2=管理端
        
        if (choice == 1) {
            generateCode(USER_PROJECT_PATH, USER_PACKAGE, "用户端");
        } else {
            generateCode(ADMIN_PROJECT_PATH, ADMIN_PACKAGE, "管理端");
        }
    }
    
    /**
     * 生成代码
     * 
     * @param projectPath 项目路径
     * @param packageName 包名
     * @param projectName 项目名称
     */
    private static void generateCode(String projectPath, String packageName, String projectName) {
        System.out.println("\n开始生成 " + projectName + " 代码...\n");
        
        FastAutoGenerator.create(DB_URL, DB_USERNAME, DB_PASSWORD)
            // 全局配置
            .globalConfig(builder -> {
                builder.author(AUTHOR)                    // 设置作者
                    .enableSwagger()                      // 开启 swagger 模式
                    .fileOverride()                       // 覆盖已生成文件
                    .outputDir(projectPath + "/src/main/java"); // 指定输出目录
            })
            // 包配置
            .packageConfig(builder -> {
                builder.parent(packageName)               // 设置父包名
                    .entity("entity")                     // 设置实体类包名
                    .mapper("mapper")                     // 设置 Mapper 接口包名
                    .service("service")                   // 设置 Service 接口包名
                    .serviceImpl("service.impl")          // 设置 Service 实现类包名
                    .controller("controller")             // 设置 Controller 包名
                    .pathInfo(Collections.singletonMap(
                        OutputFile.xml, 
                        projectPath + "/src/main/resources/mapper"
                    )); // 设置 Mapper XML 文件路径
            })
            // 策略配置
            .strategyConfig(builder -> {
                builder.addInclude(TABLES)                // 设置需要生成的表名
                    .addTablePrefix("t_", "c_")           // 设置过滤表前缀
                    
                    // Entity 策略配置
                    .entityBuilder()
                    .enableLombok()                       // 启用 Lombok
                    .enableTableFieldAnnotation()         // 启用字段注解
                    .logicDeleteColumnName("deleted")     // 逻辑删除字段名
                    .logicDeletePropertyName("deleted")   // 逻辑删除属性名
                    
                    // Controller 策略配置
                    .controllerBuilder()
                    .enableRestStyle()                    // 启用 REST 风格
                    
                    // Service 策略配置
                    .serviceBuilder()
                    .formatServiceFileName("%sService")   // Service 接口名格式
                    .formatServiceImplFileName("%sServiceImpl"); // Service 实现类名格式
            })
            // 使用 Freemarker 引擎模板
            .templateEngine(new FreemarkerTemplateEngine())
            .execute();
        
        System.out.println("\n========================================");
        System.out.println(projectName + " 代码生成完成！");
        System.out.println("生成路径: " + projectPath);
        System.out.println("========================================\n");
    }
}

