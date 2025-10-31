<template>
  <div class="usage-record-container">
    <!-- 搜索卡片 -->
    <el-card class="search-card" shadow="never">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="添加剂名称">
          <el-input v-model="searchForm.additiveName" placeholder="请输入添加剂名称" clearable></el-input>
        </el-form-item>
        <el-form-item label="审核状态">
          <el-select v-model="searchForm.auditStatus" placeholder="请选择审核状态" clearable>
            <el-option label="待审核" value="pending"></el-option>
            <el-option label="已通过" value="approved"></el-option>
            <el-option label="已拒绝" value="rejected"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
          <el-button icon="el-icon-refresh" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 表格卡片 -->
    <el-card class="table-card" shadow="never">
      <div style="margin-bottom: 20px;">
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增使用记录</el-button>
      </div>
      <el-table :data="tableData" v-loading="loading" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="usageNo" label="使用单号" width="150"></el-table-column>
        <el-table-column prop="additiveName" label="添加剂名称" min-width="150"></el-table-column>
        <el-table-column prop="quantity" label="使用数量" width="100" align="right"></el-table-column>
        <el-table-column prop="productBatch" label="产品批次" width="120"></el-table-column>
        <el-table-column prop="usageDate" label="使用日期" width="120"></el-table-column>
        <el-table-column prop="department" label="部门" width="120"></el-table-column>
        <el-table-column label="操作" width="180" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看</el-button>
            <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="text" size="small" @click="handleDelete(scope.row)" style="color: #F56C6C;">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="pagination.currentPage"
        :page-sizes="[10, 20, 50, 100]"
        :page-size="pagination.pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="pagination.total"
        style="margin-top: 20px; text-align: right;">
      </el-pagination>
    </el-card>

    <!-- 查看详情对话框 -->
    <el-dialog title="使用记录详情" :visible.sync="detailVisible" width="600px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="使用单号" :span="2">{{ detailData.usageNo }}</el-descriptions-item>
        <el-descriptions-item label="添加剂名称">{{ detailData.additiveName }}</el-descriptions-item>
        <el-descriptions-item label="使用数量">{{ detailData.quantity }}</el-descriptions-item>
        <el-descriptions-item label="产品批次">{{ detailData.productBatch }}</el-descriptions-item>
        <el-descriptions-item label="使用日期">{{ detailData.usageDate }}</el-descriptions-item>
        <el-descriptions-item label="部门">{{ detailData.department }}</el-descriptions-item>
        <el-descriptions-item label="使用目的" :span="2">{{ detailData.usagePurpose || '无' }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间" :span="2">{{ detailData.createTime }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关闭</el-button>
      </div>
    </el-dialog>

    <!-- 新增/编辑对话框 -->
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="600px">
      <el-form ref="usageForm" :model="formData" :rules="formRules" label-width="100px">
        <el-form-item label="使用单号" prop="usageNo">
          <el-input v-model="formData.usageNo" placeholder="请输入使用单号"></el-input>
        </el-form-item>
        <el-form-item label="添加剂" prop="additiveId">
          <el-select v-model="formData.additiveId" placeholder="请选择添加剂" filterable style="width: 100%">
            <el-option
              v-for="item in additiveList"
              :key="item.additiveId"
              :label="item.additiveName"
              :value="item.additiveId">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="使用数量" prop="quantity">
          <el-input-number v-model="formData.quantity" :min="0" :precision="2" style="width: 100%"></el-input-number>
        </el-form-item>
        <el-form-item label="产品批次" prop="productBatch">
          <el-input v-model="formData.productBatch" placeholder="请输入产品批次"></el-input>
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
        <el-form-item label="部门" prop="department">
          <el-input v-model="formData.department" placeholder="请输入部门"></el-input>
        </el-form-item>
        <el-form-item label="使用目的">
          <el-input v-model="formData.usagePurpose" type="textarea" :rows="3" placeholder="请输入使用目的"></el-input>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="formData.remark" type="textarea" :rows="3" placeholder="请输入备注"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitting">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getUsageRecordList, getUsageRecordDetail, deleteUsageRecord, addUsageRecord, updateUsageRecord } from '@/api/usageRecord'
import { getFoodAdditiveList } from '@/api/foodAdditive'

export default {
  name: 'UsageRecord',
  data() {
    return {
      loading: false,
      submitting: false,
      searchForm: {
        additiveName: '',
        auditStatus: null
      },
      tableData: [],
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0
      },
      detailVisible: false,
      dialogVisible: false,
      dialogTitle: '',
      dialogType: '',
      detailData: {},
      formData: {
        usageId: null,
        usageNo: '',
        additiveId: null,
        quantity: 0,
        usageDate: '',
        usagePurpose: '',
        productBatch: '',
        userId: null,
        department: '',
        remark: ''
      },
      formRules: {
        usageNo: [{ required: true, message: '请输入使用单号', trigger: 'blur' }],
        additiveId: [{ required: true, message: '请选择添加剂', trigger: 'change' }],
        quantity: [{ required: true, message: '请输入使用数量', trigger: 'blur' }],
        productBatch: [{ required: true, message: '请输入产品批次', trigger: 'blur' }],
        usageDate: [{ required: true, message: '请选择使用日期', trigger: 'change' }],
        department: [{ required: true, message: '请输入部门', trigger: 'blur' }]
      },
      additiveList: []
    }
  },
  created() {
    this.loadData()
    this.loadAdditiveList()
  },
  methods: {
    async loadData() {
      this.loading = true
      try {
        const res = await getUsageRecordList({
          ...this.searchForm,
          page: this.pagination.currentPage,
          size: this.pagination.pageSize
        })
        if (res.code === 200) {
          this.tableData = res.data.records || []
          this.pagination.total = res.data.total || 0
        }
      } catch (error) {
        this.$message.error('加载数据失败')
      } finally {
        this.loading = false
      }
    },
    async loadAdditiveList() {
      try {
        const res = await getFoodAdditiveList()
        if (res.code === 200) {
          this.additiveList = res.data || []
        }
      } catch (error) {
        console.error('加载添加剂列表失败:', error)
      }
    },
    handleSearch() {
      this.pagination.currentPage = 1
      this.loadData()
    },
    handleReset() {
      this.searchForm = {
        additiveName: '',
        auditStatus: null
      }
      this.pagination.currentPage = 1
      this.loadData()
    },
    handleAdd() {
      this.dialogType = 'add'
      this.dialogTitle = '新增使用记录'
      this.formData = {
        usageId: null,
        usageNo: '',
        additiveId: null,
        quantity: 0,
        usageDate: '',
        usagePurpose: '',
        productBatch: '',
        userId: null,
        department: '',
        remark: ''
      }
      this.dialogVisible = true
    },
    handleEdit(row) {
      this.dialogType = 'edit'
      this.dialogTitle = '编辑使用记录'
      this.formData = { ...row }
      this.dialogVisible = true
    },
    async handleSubmit() {
      this.$refs.usageForm.validate(async (valid) => {
        if (!valid) {
          return false
        }

        this.submitting = true
        try {
          // 获取当前登录用户ID
          const userInfo = this.$store.state.userInfo
          console.log('当前用户信息:', userInfo)
          console.log('用户信息JSON:', JSON.stringify(userInfo))

          if (userInfo && userInfo.userId) {
            this.formData.userId = userInfo.userId
          } else {
            this.$message.error('无法获取当前用户信息，请重新登录')
            this.submitting = false
            return
          }

          console.log('提交的数据:', this.formData)
          console.log('提交数据JSON:', JSON.stringify(this.formData))

          let res
          if (this.dialogType === 'add') {
            res = await addUsageRecord(this.formData)
          } else {
            res = await updateUsageRecord(this.formData)
          }

          if (res.code === 200) {
            this.$message.success(this.dialogType === 'add' ? '新增成功' : '更新成功')
            this.dialogVisible = false
            this.loadData()
          }
        } catch (error) {
          console.error('提交失败:', error)
          console.error('错误详情:', error.response)

          // 显示详细错误信息
          let errorMsg = this.dialogType === 'add' ? '新增失败' : '更新失败'
          if (error.response && error.response.data) {
            if (error.response.data.message) {
              errorMsg += ': ' + error.response.data.message
            } else if (error.response.data.error) {
              errorMsg += ': ' + error.response.data.error
            }
          }

          this.$message.error(errorMsg)
        } finally {
          this.submitting = false
        }
      })
    },
    async handleView(row) {
      try {
        const res = await getUsageRecordDetail(row.usageId)
        if (res.code === 200) {
          this.detailData = res.data
          // 填充添加剂名称
          if (this.detailData.additiveId) {
            const additive = this.additiveList.find(a => a.additiveId === this.detailData.additiveId)
            if (additive) {
              this.detailData.additiveName = additive.additiveName
            }
          }
          this.detailVisible = true
        }
      } catch (error) {
        this.$message.error('加载详情失败')
      }
    },
    handleDelete(row) {
      this.$confirm('确定要删除该使用记录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await deleteUsageRecord(row.usageId)
          if (res.code === 200) {
            this.$message.success('删除成功')
            this.loadData()
          }
        } catch (error) {
          this.$message.error('删除失败')
        }
      })
    },
    handleSizeChange(val) {
      this.pagination.pageSize = val
      this.loadData()
    },
    handleCurrentChange(val) {
      this.pagination.currentPage = val
      this.loadData()
    }
  }
}
</script>

<style lang="scss" scoped>
.usage-record-container {
  padding: 20px;

  .search-card {
    margin-bottom: 20px;
  }

  .search-form {
    .el-form-item {
      margin-bottom: 0;
    }
  }
}
</style>

