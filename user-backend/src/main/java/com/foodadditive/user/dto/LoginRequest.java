package com.foodadditive.user.dto;

import lombok.Data;

/**
 * 登录请求DTO
 * 
 * @author 系统
 * @since 2025-01-01
 */
@Data
public class LoginRequest {
    
    /**
     * 用户名
     */
    private String username;
    
    /**
     * 密码
     */
    private String password;
}

