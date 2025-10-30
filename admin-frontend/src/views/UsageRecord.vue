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
        <el-table-column prop="additiveName" label="添加剂名称" min-width="150"></el-table-column>
        <el-table-column prop="usageQuantity" label="使用数量" width="100" align="right">
          <template slot-scope="scope">
            {{ scope.row.usageQuantity }} {{ scope.row.unit }}
          </template>
        </el-table-column>
        <el-table-column prop="productName" label="产品名称" width="150"></el-table-column>
        <el-table-column prop="batchNo" label="批次号" width="120"></el-table-column>
        <el-table-column prop="usageDate" label="使用日期" width="120"></el-table-column>
        <el-table-column prop="operator" label="操作人" width="100"></el-table-column>
        <el-table-column prop="auditStatus" label="审核状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.auditStatus === 'approved' ? 'success' : scope.row.auditStatus === 'rejected' ? 'danger' : 'warning'"
              size="small">
              {{ scope.row.auditStatus === 'approved' ? '已通过' : scope.row.auditStatus === 'rejected' ? '已拒绝' : '待审核' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="220" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看</el-button>
            <el-button
              v-if="scope.row.auditStatus === 'pending'"
              type="text"
              size="small"
              @click="handleAudit(scope.row, 'approved')"
              style="color: #67C23A;">
              通过
            </el-button>
            <el-button
              v-if="scope.row.auditStatus === 'pending'"
              type="text"
              size="small"
              @click="handleAudit(scope.row, 'rejected')"
              style="color: #F56C6C;">
              拒绝
            </el-button>
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
        <el-descriptions-item label="添加剂名称">{{ detailData.additiveName }}</el-descriptions-item>
        <el-descriptions-item label="使用数量">{{ detailData.usageQuantity }} {{ detailData.unit }}</el-descriptions-item>
        <el-descriptions-item label="产品名称">{{ detailData.productName }}</el-descriptions-item>
        <el-descriptions-item label="批次号">{{ detailData.batchNo }}</el-descriptions-item>
        <el-descriptions-item label="使用日期">{{ detailData.usageDate }}</el-descriptions-item>
        <el-descriptions-item label="操作人">{{ detailData.operator }}</el-descriptions-item>
        <el-descriptions-item label="使用目的" :span="2">{{ detailData.purpose }}</el-descriptions-item>
        <el-descriptions-item label="审核状态">
          <el-tag
            :type="detailData.auditStatus === 'approved' ? 'success' : detailData.auditStatus === 'rejected' ? 'danger' : 'warning'"
            size="small">
            {{ detailData.auditStatus === 'approved' ? '已通过' : detailData.auditStatus === 'rejected' ? '已拒绝' : '待审核' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="审核人">{{ detailData.auditor || '未审核' }}</el-descriptions-item>
        <el-descriptions-item label="审核意见" :span="2">{{ detailData.auditRemark || '无' }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间" :span="2">{{ detailData.createTime }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关闭</el-button>
      </div>
    </el-dialog>

    <!-- 审核对话框 -->
    <el-dialog title="审核使用记录" :visible.sync="auditVisible" width="500px">
      <el-form ref="auditForm" :model="auditForm" label-width="100px">
        <el-form-item label="审核结果">
          <el-tag :type="auditForm.auditStatus === 'approved' ? 'success' : 'danger'" size="medium">
            {{ auditForm.auditStatus === 'approved' ? '通过' : '拒绝' }}
          </el-tag>
        </el-form-item>
        <el-form-item label="审核意见">
          <el-input
            v-model="auditForm.auditRemark"
            type="textarea"
            :rows="4"
            placeholder="请输入审核意见">
          </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="auditVisible = false">取消</el-button>
        <el-button type="primary" @click="handleAuditSubmit" :loading="submitting">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getUsageRecordList, getUsageRecordById, deleteUsageRecord, auditUsageRecord } from '@/api/usageRecord'

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
      auditVisible: false,
      detailData: {},
      auditForm: {
        recordId: null,
        auditStatus: '',
        auditRemark: ''
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
      this.$message.info('新增使用记录功能开发中...')
    },
    async handleView(row) {
      try {
        const res = await getUsageRecordById(row.recordId)
        if (res.code === 200) {
          this.detailData = res.data
          this.detailVisible = true
        }
      } catch (error) {
        this.$message.error('加载详情失败')
      }
    },
    handleAudit(row, status) {
      this.auditForm = {
        recordId: row.recordId,
        auditStatus: status,
        auditRemark: ''
      }
      this.auditVisible = true
    },
    async handleAuditSubmit() {
      this.submitting = true
      try {
        const res = await auditUsageRecord(this.auditForm)
        if (res.code === 200) {
          this.$message.success('审核成功')
          this.auditVisible = false
          this.loadData()
        }
      } catch (error) {
        this.$message.error('审核失败')
      } finally {
        this.submitting = false
      }
    },
    handleDelete(row) {
      this.$confirm('确定要删除该使用记录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await deleteUsageRecord(row.recordId)
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

