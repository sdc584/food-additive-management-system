<template>
  <div class="login-container">
    <div class="login-left">
      <div class="left-content">
        <div class="logo-section">
          <custom-logo class="logo" />
          <h1 class="system-title">食品添加剂管理系统</h1>
          <p class="system-subtitle">Food Additive Management System</p>
        </div>
        <div class="feature-list">
          <div class="feature-item">
            <i class="el-icon-check"></i>
            <span>智能库存管理</span>
          </div>
          <div class="feature-item">
            <i class="el-icon-check"></i>
            <span>实时预警监控</span>
          </div>
          <div class="feature-item">
            <i class="el-icon-check"></i>
            <span>数据可视化分析</span>
          </div>
          <div class="feature-item">
            <i class="el-icon-check"></i>
            <span>全流程追溯</span>
          </div>
        </div>
      </div>
    </div>
    <div class="login-right">
      <div class="login-form-wrapper">
        <div class="form-header">
          <h2>管理员登录</h2>
          <p>欢迎回来，请登录您的账号</p>
        </div>
        <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form">
          <el-form-item prop="username">
            <el-input ref="username" v-model="loginForm.username" placeholder="请输入用户名" name="username" type="text" tabindex="1" autocomplete="on" prefix-icon="el-icon-user" size="large" />
          </el-form-item>
          <el-tooltip v-model="capsTooltip" content="大写锁定已打开" placement="right" manual>
            <el-form-item prop="password">
              <el-input :key="passwordType" ref="password" v-model="loginForm.password" :type="passwordType" placeholder="请输入密码" name="password" tabindex="2" autocomplete="on" prefix-icon="el-icon-lock" size="large" @keyup.native="checkCapslock" @blur="capsTooltip = false" @keyup.enter.native="handleLogin">
                <i slot="suffix" :class="passwordType === 'password' ? 'el-icon-view' : 'el-icon-minus'" class="password-icon" @click="showPwd"></i>
              </el-input>
            </el-form-item>
          </el-tooltip>
          <el-form-item>
            <div class="remember-forgot">
              <el-checkbox v-model="rememberMe">记住密码</el-checkbox>
              <a href="javascript:;" class="forgot-password">忘记密码?</a>
            </div>
          </el-form-item>
          <el-form-item>
            <el-button :loading="loading" type="primary" size="large" style="width:100%" @click.native.prevent="handleLogin">{{ loading ? '登录中...' : '登录' }}</el-button>
          </el-form-item>
          <div class="tips">
            <el-alert title="默认账号: admin / 123456" type="info" :closable="false" show-icon></el-alert>
          </div>
        </el-form>
      </div>
    </div>
  </div>
</template>
<script>
import CustomLogo from '@/components/Logo.vue'
import { login } from '@/api/auth'

export default {
  name: 'Login',
  components: {
    CustomLogo
  },
  data() {
    return {
      loginForm: { username: 'admin', password: '123456' },
      loginRules: {
        username: [{ required: true, trigger: 'blur', message: '请输入用户名' }],
        password: [{ required: true, trigger: 'blur', message: '请输入密码' }]
      },
      passwordType: 'password',
      capsTooltip: false,
      loading: false,
      rememberMe: false
    }
  },
  mounted() {
    if (this.loginForm.username === '') {
      this.$refs.username.focus()
    } else if (this.loginForm.password === '') {
      this.$refs.password.focus()
    }
  },
  methods: {
    checkCapslock(e) {
      const { key } = e
      this.capsTooltip = key && key.length === 1 && (key >= 'A' && key <= 'Z')
    },
    showPwd() {
      if (this.passwordType === 'password') {
        this.passwordType = ''
      } else {
        this.passwordType = 'password'
      }
      this.$nextTick(() => {
        this.$refs.password.focus()
      })
    },
    async handleLogin() {
      this.$refs.loginForm.validate(async valid => {
        if (valid) {
          this.loading = true
          try {
            // 调用真实的登录API
            const res = await login({
              username: this.loginForm.username,
              password: this.loginForm.password
            })

            if (res.code === 200 && res.data) {
              // 从后端响应中获取token和用户信息
              const { token, userId, username, realName, role } = res.data
              const userInfo = {
                id: userId,
                username: username,
                realName: realName,
                role: role
              }

              // 保存到Vuex store
              this.$store.dispatch('login', { token, userInfo })

              this.$message.success('登录成功')
              this.$router.push('/dashboard')
            } else {
              this.$message.error(res.message || '登录失败')
            }
          } catch (error) {
            console.error('登录失败:', error)
            this.$message.error(error.message || '登录失败，请检查用户名和密码')
          } finally {
            this.loading = false
          }
        } else {
          return false
        }
      })
    }
  }
}
</script>
<style lang="scss" scoped>
.login-container {
  display: flex;
  min-height: 100vh;
  width: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
.login-left {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 60px;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  .left-content {
    max-width: 500px;
  }
  .logo-section {
    text-align: center;
    margin-bottom: 60px;
    .logo {
      width: 80px;
      height: 80px;
      border-radius: 16px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
      margin-bottom: 24px;
    }
    .system-title {
      font-size: 36px;
      font-weight: 700;
      color: #fff;
      margin: 0 0 12px 0;
      text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    .system-subtitle {
      font-size: 16px;
      color: rgba(255, 255, 255, 0.9);
      margin: 0;
      letter-spacing: 1px;
    }
  }
  .feature-list {
    .feature-item {
      display: flex;
      align-items: center;
      padding: 16px 0;
      color: #fff;
      font-size: 16px;
      i {
        font-size: 20px;
        margin-right: 12px;
        color: #4ade80;
      }
    }
  }
}
.login-right {
  width: 500px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
  padding: 60px;
  .login-form-wrapper {
    width: 100%;
    max-width: 400px;
  }
  .form-header {
    margin-bottom: 40px;
    h2 {
      font-size: 28px;
      font-weight: 600;
      color: #1f2937;
      margin: 0 0 8px 0;
    }
    p {
      font-size: 14px;
      color: #6b7280;
      margin: 0;
    }
  }
  .login-form {
    .el-form-item {
      margin-bottom: 24px;
    }
    .password-icon {
      cursor: pointer;
      color: #9ca3af;
      transition: color 0.3s;
      &:hover {
        color: #667eea;
      }
    }
    .remember-forgot {
      display: flex;
      justify-content: space-between;
      align-items: center;
      .forgot-password {
        color: #667eea;
        text-decoration: none;
        font-size: 14px;
        transition: color 0.3s;
        &:hover {
          color: #764ba2;
        }
      }
    }
    .tips {
      margin-top: 20px;
    }
  }
}
@media (max-width: 1024px) {
  .login-left {
    display: none;
  }
  .login-right {
    width: 100%;
  }
}
</style>
