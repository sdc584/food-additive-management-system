<template>
  <div class="warning-manage-container">
    <el-card shadow="never">
      <el-table :data="tableData" v-loading="loading" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="warningType" label="预警类型" width="120">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.warningType === 'STOCK'" type="warning" size="small">库存预警</el-tag>
            <el-tag v-else-if="scope.row.warningType === 'EXPIRY'" type="danger" size="small">过期预警</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="additiveName" label="添加剂名称" min-width="150"></el-table-column>
        <el-table-column prop="warningLevel" label="预警级别" width="100" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.warningLevel === 'HIGH'" type="danger" size="small">高</el-tag>
            <el-tag v-else-if="scope.row.warningLevel === 'MEDIUM'" type="warning" size="small">中</el-tag>
            <el-tag v-else type="info" size="small">低</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="warningContent" label="预警内容" min-width="200"></el-table-column>
        <el-table-column prop="warningDate" label="预警日期" width="120"></el-table-column>
        <el-table-column prop="status" label="状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.status === 'PENDING'" type="warning" size="small">未处理</el-tag>
            <el-tag v-else-if="scope.row.status === 'PROCESSING'" type="primary" size="small">处理中</el-tag>
            <el-tag v-else-if="scope.row.status === 'RESOLVED'" type="success" size="small">已解决</el-tag>
            <el-tag v-else type="info" size="small">已关闭</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" align="center">
          <template slot-scope="scope">
            <el-button v-if="scope.row.status === 'PENDING'" type="text" size="small" @click="handleProcess(scope.row)">处理</el-button>
            <el-button v-else type="text" size="small" @click="handleCancel(scope.row)" style="color: #909399;">取消处理</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 处理预警对话框 -->
    <el-dialog title="处理预警" :visible.sync="processDialogVisible" width="500px">
      <el-form :model="processForm" :rules="processRules" ref="processForm" label-width="120px">
        <el-form-item label="预警内容">
          <div style="color: #606266;">{{ currentWarning.warningContent }}</div>
        </el-form-item>
        <el-form-item label="添加剂名称">
          <div style="color: #606266;">{{ currentWarning.additiveName }}</div>
        </el-form-item>
        <el-form-item label="添加库存数量" prop="addQuantity">
          <el-input-number
            v-model="processForm.addQuantity"
            :min="0"
            :precision="2"
            :step="1"
            placeholder="请输入要添加的库存数量"
            style="width: 100%;">
          </el-input-number>
          <div style="color: #909399; font-size: 12px; margin-top: 5px;">
            输入0表示只标记为已处理，不增加库存；输入大于0的数量将增加该添加剂的库存
          </div>
        </el-form-item>
        <el-form-item label="处理备注" prop="handleRemark">
          <el-input
            v-model="processForm.handleRemark"
            type="textarea"
            :rows="3"
            placeholder="请输入处理备注（选填）">
          </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="processDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitProcess" :loading="submitting">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getWarningList, updateWarning } from '@/api/warning'

export default {
  name: 'WarningManage',
  data() {
    return {
      loading: false,
      submitting: false,
      tableData: [],
      processDialogVisible: false,
      currentWarning: {},
      processForm: {
        addQuantity: null,
        handleRemark: ''
      },
      processRules: {
        addQuantity: [
          { required: true, message: '请输入添加库存数量', trigger: 'blur' },
          { type: 'number', min: 0, message: '数量不能小于0', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    async loadData() {
      this.loading = true
      try {
        const res = await getWarningList()
        if (res.code === 200) {
          this.tableData = res.data || []
        }
      } catch (error) {
        console.error('加载数据失败:', error)
      } finally {
        this.loading = false
      }
    },
    handleProcess(row) {
      // 打开处理对话框
      this.currentWarning = { ...row }
      this.processForm = {
        addQuantity: null,
        handleRemark: ''
      }
      this.processDialogVisible = true

      // 重置表单验证
      this.$nextTick(() => {
        if (this.$refs.processForm) {
          this.$refs.processForm.clearValidate()
        }
      })
    },
    async submitProcess() {
      // 验证表单
      this.$refs.processForm.validate(async (valid) => {
        if (!valid) {
          return false
        }

        this.submitting = true
        try {
          const res = await updateWarning({
            warningId: this.currentWarning.warningId,
            inventoryId: this.currentWarning.inventoryId,
            addQuantity: this.processForm.addQuantity,
            handleRemark: this.processForm.handleRemark,
            status: 'RESOLVED',
            handleTime: new Date().toISOString().slice(0, 19).replace('T', ' ')
          })

          if (res.code === 200) {
            this.$message.success('处理成功，已增加库存数量')
            this.processDialogVisible = false
            this.loadData()
          } else {
            this.$message.error(res.message || '处理失败')
          }
        } catch (error) {
          console.error('处理失败:', error)
          this.$message.error('处理失败')
        } finally {
          this.submitting = false
        }
      })
    },
    handleCancel(row) {
      this.$confirm('取消处理将减去之前添加的库存数量，确定要取消吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await updateWarning({
            warningId: row.warningId,
            inventoryId: row.inventoryId,
            status: 'PENDING',
            handleTime: null
          })
          if (res.code === 200) {
            this.$message.success('取消成功，已减去之前添加的库存数量')
            this.loadData()
          } else {
            this.$message.error(res.message || '取消失败')
          }
        } catch (error) {
          console.error('取消失败:', error)
          this.$message.error('取消失败')
        }
      }).catch(() => {
        // 用户点击了取消按钮，不做任何操作
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.warning-manage-container {
  padding: 20px;
}
</style>

