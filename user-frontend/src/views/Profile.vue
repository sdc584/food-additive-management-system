<template>
  <div class="profile-container">
    <el-row :gutter="20">
      <!-- 左侧个人信息卡片 -->
      <el-col :span="8">
        <el-card shadow="never" class="profile-card">
          <div class="profile-header">
            <el-avatar :size="100" :src="userInfo.avatar" icon="el-icon-user-solid"></el-avatar>
            <h3>{{ userInfo.realName || userInfo.username }}</h3>
            <p class="role-tag">
              <el-tag :type="userInfo.role === 'admin' ? 'danger' : 'primary'" size="small">
                {{ userInfo.role === 'admin' ? '管理员' : '普通用户' }}
              </el-tag>
            </p>
          </div>
          <el-divider></el-divider>
          <div class="profile-info">
            <div class="info-item">
              <i class="el-icon-user"></i>
              <span class="label">用户名：</span>
              <span class="value">{{ userInfo.username }}</span>
            </div>
            <div class="info-item">
              <i class="el-icon-phone"></i>
              <span class="label">联系电话：</span>
              <span class="value">{{ userInfo.phone || '未设置' }}</span>
            </div>
            <div class="info-item">
              <i class="el-icon-message"></i>
              <span class="label">邮箱：</span>
              <span class="value">{{ userInfo.email || '未设置' }}</span>
            </div>
            <div class="info-item">
              <i class="el-icon-office-building"></i>
              <span class="label">部门：</span>
              <span class="value">{{ userInfo.department || '未设置' }}</span>
            </div>
            <div class="info-item">
              <i class="el-icon-time"></i>
              <span class="label">注册时间：</span>
              <span class="value">{{ userInfo.createTime }}</span>
            </div>
          </div>
        </el-card>
      </el-col>

      <!-- 右侧编辑区域 -->
      <el-col :span="16">
        <!-- 编辑个人信息 -->
        <el-card shadow="never" class="edit-card">
          <div slot="header">
            <span style="font-size: 16px; font-weight: bold;">编辑个人信息</span>
          </div>
          <el-form ref="profileForm" :model="formData" :rules="formRules" label-width="100px">
            <el-form-item label="真实姓名" prop="realName">
              <el-input v-model="formData.realName" placeholder="请输入真实姓名"></el-input>
            </el-form-item>
            <el-form-item label="联系电话" prop="phone">
              <el-input v-model="formData.phone" placeholder="请输入联系电话"></el-input>
            </el-form-item>
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="formData.email" placeholder="请输入邮箱"></el-input>
            </el-form-item>
            <el-form-item label="部门" prop="department">
              <el-input v-model="formData.department" placeholder="请输入部门"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleUpdateProfile" :loading="submitting">保存修改</el-button>
              <el-button @click="handleResetForm">重置</el-button>
            </el-form-item>
          </el-form>
        </el-card>

        <!-- 修改密码 -->
        <el-card shadow="never" class="edit-card" style="margin-top: 20px;">
          <div slot="header">
            <span style="font-size: 16px; font-weight: bold;">修改密码</span>
          </div>
          <el-form ref="passwordForm" :model="passwordData" :rules="passwordRules" label-width="100px">
            <el-form-item label="原密码" prop="oldPassword">
              <el-input v-model="passwordData.oldPassword" type="password" placeholder="请输入原密码" show-password></el-input>
            </el-form-item>
            <el-form-item label="新密码" prop="newPassword">
              <el-input v-model="passwordData.newPassword" type="password" placeholder="请输入新密码" show-password></el-input>
            </el-form-item>
            <el-form-item label="确认密码" prop="confirmPassword">
              <el-input v-model="passwordData.confirmPassword" type="password" placeholder="请再次输入新密码" show-password></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleChangePassword" :loading="passwordSubmitting">修改密码</el-button>
              <el-button @click="handleResetPassword">重置</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { getUserProfile, updateUserProfile, changePassword } from '@/api/profile'

export default {
  name: 'Profile',
  data() {
    const validateConfirmPassword = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请再次输入密码'))
      } else if (value !== this.passwordData.newPassword) {
        callback(new Error('两次输入密码不一致!'))
      } else {
        callback()
      }
    }

    return {
      submitting: false,
      passwordSubmitting: false,
      userInfo: {},
      formData: {
        realName: '',
        phone: '',
        email: '',
        department: ''
      },
      passwordData: {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      },
      formRules: {
        realName: [
          { required: true, message: '请输入真实姓名', trigger: 'blur' }
        ],
        phone: [
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
        ],
        email: [
          { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
        ]
      },
      passwordRules: {
        oldPassword: [
          { required: true, message: '请输入原密码', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, validator: validateConfirmPassword, trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.loadUserProfile()
  },
  methods: {
    async loadUserProfile() {
      try {
        const res = await getUserProfile()
        if (res.code === 200) {
          this.userInfo = res.data
          this.formData = {
            realName: res.data.realName || '',
            phone: res.data.phone || '',
            email: res.data.email || '',
            department: res.data.department || ''
          }
        }
      } catch (error) {
        this.$message.error('加载用户信息失败')
      }
    },
    handleUpdateProfile() {
      this.$refs.profileForm.validate(async (valid) => {
        if (!valid) return false

        this.submitting = true
        try {
          const res = await updateUserProfile(this.formData)
          if (res.code === 200) {
            this.$message.success('保存成功')
            this.loadUserProfile()
            // 更新Vuex中的用户信息
            this.$store.commit('setUserInfo', { ...this.userInfo, ...this.formData })
          }
        } catch (error) {
          this.$message.error('保存失败')
        } finally {
          this.submitting = false
        }
      })
    },
    handleResetForm() {
      this.formData = {
        realName: this.userInfo.realName || '',
        phone: this.userInfo.phone || '',
        email: this.userInfo.email || '',
        department: this.userInfo.department || ''
      }
      this.$refs.profileForm.clearValidate()
    },
    handleChangePassword() {
      this.$refs.passwordForm.validate(async (valid) => {
        if (!valid) return false

        this.passwordSubmitting = true
        try {
          const res = await changePassword({
            oldPassword: this.passwordData.oldPassword,
            newPassword: this.passwordData.newPassword
          })
          if (res.code === 200) {
            this.$message.success('密码修改成功，请重新登录')
            // 清除token，跳转到登录页
            setTimeout(() => {
              localStorage.removeItem('token')
              this.$router.push('/login')
            }, 1500)
          }
        } catch (error) {
          this.$message.error(error.message || '密码修改失败')
        } finally {
          this.passwordSubmitting = false
        }
      })
    },
    handleResetPassword() {
      this.passwordData = {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      }
      this.$refs.passwordForm.clearValidate()
    }
  }
}
</script>

<style lang="scss" scoped>
.profile-container {
  padding: 20px;

  .profile-card {
    .profile-header {
      text-align: center;
      padding: 20px 0;

      h3 {
        margin: 15px 0 10px;
        font-size: 20px;
        color: #303133;
      }

      .role-tag {
        margin: 0;
      }
    }

    .profile-info {
      .info-item {
        padding: 12px 0;
        display: flex;
        align-items: center;
        border-bottom: 1px solid #f0f0f0;

        &:last-child {
          border-bottom: none;
        }

        i {
          font-size: 18px;
          color: #409EFF;
          margin-right: 10px;
        }

        .label {
          color: #909399;
          min-width: 80px;
        }

        .value {
          color: #303133;
          flex: 1;
        }
      }
    }
  }

  .edit-card {
    .el-form {
      max-width: 500px;
    }
  }
}
</style>

