<template>
  <div class="usage-register-container">
    <el-card shadow="never">
      <div slot="header">
        <span style="font-size: 18px; font-weight: bold;">使用登记</span>
      </div>

      <!-- 使用登记表单 -->
      <el-form
        ref="usageForm"
        :model="formData"
        :rules="formRules"
        label-width="120px"
        style="max-width: 800px;">
        <el-form-item label="添加剂" prop="additiveId">
          <el-select
            v-model="formData.additiveId"
            placeholder="请选择添加剂"
            filterable
            style="width: 100%"
            @change="handleAdditiveChange">
            <el-option
              v-for="item in additiveList"
              :key="item.additiveId"
              :label="item.additiveName"
              :value="item.additiveId">
              <span style="float: left">{{ item.additiveName }}</span>
              <span style="float: right; color: #8492a6; font-size: 13px">{{ item.additiveCode }}</span>
            </el-option>
          </el-select>
        </el-form-item>

        <el-form-item label="当前库存">
          <el-input v-model="currentStock" disabled>
            <template slot="append">{{ stockUnit }}</template>
          </el-input>
        </el-form-item>

        <el-form-item label="使用数量" prop="usageQuantity">
          <el-input-number
            v-model="formData.usageQuantity"
            :min="0.01"
            :max="parseFloat(currentStock) || 9999"
            :precision="2"
            :step="0.1"
            style="width: 100%">
          </el-input-number>
          <span style="margin-left: 10px; color: #909399;">{{ stockUnit }}</span>
        </el-form-item>

        <el-form-item label="使用日期" prop="usageDate">
          <el-date-picker
            v-model="formData.usageDate"
            type="date"
            placeholder="选择使用日期"
            value-format="yyyy-MM-dd"
            style="width: 100%">
          </el-date-picker>
        </el-form-item>

        <el-form-item label="使用目的" prop="purpose">
          <el-input
            v-model="formData.purpose"
            type="textarea"
            :rows="3"
            placeholder="请输入使用目的，如：用于XX产品生产"
            maxlength="200"
            show-word-limit>
          </el-input>
        </el-form-item>

        <el-form-item label="生产批次号" prop="batchNumber">
          <el-input v-model="formData.batchNumber" placeholder="请输入生产批次号"></el-input>
        </el-form-item>

        <el-form-item label="操作人员" prop="operator">
          <el-input v-model="formData.operator" placeholder="请输入操作人员姓名"></el-input>
        </el-form-item>

        <el-form-item label="备注">
          <el-input
            v-model="formData.remark"
            type="textarea"
            :rows="2"
            placeholder="请输入备注信息（可选）"
            maxlength="500"
            show-word-limit>
          </el-input>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="handleSubmit" :loading="submitting">提交登记</el-button>
          <el-button @click="handleReset">重置</el-button>
          <el-button @click="handleViewHistory">查看历史记录</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 历史记录对话框 -->
    <el-dialog title="我的使用记录" :visible.sync="historyVisible" width="90%" top="5vh">
      <el-table :data="historyData" v-loading="historyLoading" stripe border max-height="500">
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="additiveName" label="添加剂名称" min-width="120"></el-table-column>
        <el-table-column prop="usageQuantity" label="使用数量" width="100" align="right"></el-table-column>
        <el-table-column prop="usageDate" label="使用日期" width="110"></el-table-column>
        <el-table-column prop="purpose" label="使用目的" min-width="150" show-overflow-tooltip></el-table-column>
        <el-table-column prop="batchNumber" label="批次号" width="120"></el-table-column>
        <el-table-column prop="operator" label="操作人" width="100"></el-table-column>
        <el-table-column prop="status" label="状态" width="80" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.status === 1" type="success" size="small">已审核</el-tag>
            <el-tag v-else-if="scope.row.status === 0" type="warning" size="small">待审核</el-tag>
            <el-tag v-else type="info" size="small">已取消</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="登记时间" width="150"></el-table-column>
      </el-table>

      <el-pagination
        @size-change="handleHistorySizeChange"
        @current-change="handleHistoryCurrentChange"
        :current-page="historyPagination.currentPage"
        :page-sizes="[10, 20, 50]"
        :page-size="historyPagination.pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="historyPagination.total"
        style="margin-top: 20px; text-align: right;">
      </el-pagination>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'UsageRegister',
  data() {
    return {
      submitting: false,
      formData: {
        additiveId: null,
        usageQuantity: null,
        usageDate: '',
        purpose: '',
        batchNumber: '',
        operator: '',
        remark: ''
      },
      formRules: {
        additiveId: [
          { required: true, message: '请选择添加剂', trigger: 'change' }
        ],
        usageQuantity: [
          { required: true, message: '请输入使用数量', trigger: 'blur' }
        ],
        usageDate: [
          { required: true, message: '请选择使用日期', trigger: 'change' }
        ],
        purpose: [
          { required: true, message: '请输入使用目的', trigger: 'blur' }
        ],
        batchNumber: [
          { required: true, message: '请输入生产批次号', trigger: 'blur' }
        ],
        operator: [
          { required: true, message: '请输入操作人员', trigger: 'blur' }
        ]
      },
      additiveList: [],
      currentStock: '0',
      stockUnit: 'kg',
      historyVisible: false,
      historyLoading: false,
      historyData: [],
      historyPagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0
      }
    }
  },
  created() {
    this.loadAdditiveList()
    this.initFormData()
  },
  methods: {
    async loadAdditiveList() {
      try {
        // TODO: 调用API加载添加剂列表
        // const response = await this.$http.get('/api/user/foodAdditives')
        // this.additiveList = response.data
        this.additiveList = []
      } catch (error) {
        this.$message.error('加载添加剂列表失败')
      }
    },
    initFormData() {
      const userInfo = this.$store.state.userInfo || {}
      this.formData.operator = userInfo.realName || userInfo.username || ''
      this.formData.usageDate = this.getCurrentDate()
    },
    getCurrentDate() {
      const date = new Date()
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      return `${year}-${month}-${day}`
    },
    async handleAdditiveChange(additiveId) {
      if (!additiveId) {
        this.currentStock = '0'
        return
      }
      try {
        // TODO: 调用API获取库存信息
        // const response = await this.$http.get(`/api/user/inventories/additive/${additiveId}`)
        // this.currentStock = response.data.currentStock
        // this.stockUnit = response.data.unit || 'kg'
        this.currentStock = '0'
      } catch (error) {
        this.$message.error('获取库存信息失败')
      }
    },
    handleSubmit() {
      this.$refs.usageForm.validate(async (valid) => {
        if (!valid) {
          return false
        }

        if (this.formData.usageQuantity > parseFloat(this.currentStock)) {
          this.$message.error('使用数量不能大于当前库存')
          return
        }

        this.submitting = true
        try {
          // TODO: 调用API提交使用记录
          // await this.$http.post('/api/user/usageRecords', this.formData)
          
          // 模拟提交
          setTimeout(() => {
            this.$message.success('使用记录登记成功')
            this.handleReset()
            this.submitting = false
          }, 1000)
        } catch (error) {
          this.$message.error('提交失败：' + (error.message || '未知错误'))
          this.submitting = false
        }
      })
    },
    handleReset() {
      this.$refs.usageForm.resetFields()
      this.initFormData()
      this.currentStock = '0'
    },
    async handleViewHistory() {
      this.historyVisible = true
      this.loadHistoryData()
    },
    async loadHistoryData() {
      this.historyLoading = true
      try {
        // TODO: 调用API加载历史记录
        // const response = await this.$http.get('/api/user/usageRecords/my', {
        //   params: {
        //     page: this.historyPagination.currentPage,
        //     size: this.historyPagination.pageSize
        //   }
        // })
        // this.historyData = response.data.records
        // this.historyPagination.total = response.data.total
        
        setTimeout(() => {
          this.historyData = []
          this.historyPagination.total = 0
          this.historyLoading = false
        }, 500)
      } catch (error) {
        this.$message.error('加载历史记录失败')
        this.historyLoading = false
      }
    },
    handleHistorySizeChange(val) {
      this.historyPagination.pageSize = val
      this.loadHistoryData()
    },
    handleHistoryCurrentChange(val) {
      this.historyPagination.currentPage = val
      this.loadHistoryData()
    }
  }
}
</script>

<style lang="scss" scoped>
.usage-register-container {
  padding: 20px;
}
</style>

