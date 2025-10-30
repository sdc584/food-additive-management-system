<template>
  <div class="operation-log-container">
    <!-- 搜索卡片 -->
    <el-card class="search-card" shadow="never">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="操作人">
          <el-input v-model="searchForm.operator" placeholder="请输入操作人" clearable></el-input>
        </el-form-item>
        <el-form-item label="操作类型">
          <el-select v-model="searchForm.operationType" placeholder="请选择操作类型" clearable>
            <el-option label="新增" value="INSERT"></el-option>
            <el-option label="更新" value="UPDATE"></el-option>
            <el-option label="删除" value="DELETE"></el-option>
            <el-option label="查询" value="SELECT"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="模块名称">
          <el-select v-model="searchForm.moduleName" placeholder="请选择模块" clearable>
            <el-option label="添加剂管理" value="additive"></el-option>
            <el-option label="库存管理" value="inventory"></el-option>
            <el-option label="供应商管理" value="supplier"></el-option>
            <el-option label="采购管理" value="purchase"></el-option>
            <el-option label="使用记录" value="usage"></el-option>
            <el-option label="检测报告" value="test"></el-option>
            <el-option label="用户管理" value="user"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="操作时间">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
          <el-button icon="el-icon-refresh" @click="handleReset">重置</el-button>
          <el-button type="success" icon="el-icon-download" @click="handleExport">导出</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 表格卡片 -->
    <el-card class="table-card" shadow="never">
      <el-table :data="tableData" v-loading="loading" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="operationType" label="操作类型" width="100" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.operationType === 'INSERT'" type="success" size="small">新增</el-tag>
            <el-tag v-else-if="scope.row.operationType === 'UPDATE'" type="warning" size="small">更新</el-tag>
            <el-tag v-else-if="scope.row.operationType === 'DELETE'" type="danger" size="small">删除</el-tag>
            <el-tag v-else type="info" size="small">查询</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="moduleName" label="模块名称" width="120"></el-table-column>
        <el-table-column prop="operationContent" label="操作内容" min-width="200" show-overflow-tooltip></el-table-column>
        <el-table-column prop="operator" label="操作人" width="100"></el-table-column>
        <el-table-column prop="operationTime" label="操作时间" width="180"></el-table-column>
        <el-table-column prop="ipAddress" label="IP地址" width="130"></el-table-column>
        <el-table-column label="操作" width="100" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">详情</el-button>
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

    <!-- 详情对话框 -->
    <el-dialog title="操作日志详情" :visible.sync="detailVisible" width="600px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="操作类型">
          <el-tag v-if="detailData.operationType === 'INSERT'" type="success" size="small">新增</el-tag>
          <el-tag v-else-if="detailData.operationType === 'UPDATE'" type="warning" size="small">更新</el-tag>
          <el-tag v-else-if="detailData.operationType === 'DELETE'" type="danger" size="small">删除</el-tag>
          <el-tag v-else type="info" size="small">查询</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="模块名称">{{ detailData.moduleName }}</el-descriptions-item>
        <el-descriptions-item label="操作人">{{ detailData.operator }}</el-descriptions-item>
        <el-descriptions-item label="操作时间">{{ detailData.operationTime }}</el-descriptions-item>
        <el-descriptions-item label="IP地址">{{ detailData.ipAddress }}</el-descriptions-item>
        <el-descriptions-item label="浏览器">{{ detailData.browser || '未知' }}</el-descriptions-item>
        <el-descriptions-item label="操作内容" :span="2">{{ detailData.operationContent }}</el-descriptions-item>
        <el-descriptions-item label="请求参数" :span="2">
          <pre style="max-height: 200px; overflow-y: auto;">{{ detailData.requestParams || '无' }}</pre>
        </el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getOperationLogList, getOperationLogById, exportOperationLog } from '@/api/operationLog'

export default {
  name: 'OperationLog',
  data() {
    return {
      loading: false,
      searchForm: {
        operator: '',
        operationType: '',
        moduleName: '',
        dateRange: null
      },
      tableData: [],
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0
      },
      detailVisible: false,
      detailData: {}
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    async loadData() {
      this.loading = true
      try {
        const params = {
          ...this.searchForm,
          page: this.pagination.currentPage,
          size: this.pagination.pageSize
        }
        // 处理日期范围
        if (this.searchForm.dateRange && this.searchForm.dateRange.length === 2) {
          params.startDate = this.searchForm.dateRange[0]
          params.endDate = this.searchForm.dateRange[1]
        }
        delete params.dateRange

        const res = await getOperationLogList(params)
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
        operator: '',
        operationType: '',
        moduleName: '',
        dateRange: null
      }
      this.pagination.currentPage = 1
      this.loadData()
    },
    async handleView(row) {
      try {
        const res = await getOperationLogById(row.logId)
        if (res.code === 200) {
          this.detailData = res.data
          this.detailVisible = true
        }
      } catch (error) {
        this.$message.error('加载详情失败')
      }
    },
    async handleExport() {
      try {
        const params = { ...this.searchForm }
        // 处理日期范围
        if (this.searchForm.dateRange && this.searchForm.dateRange.length === 2) {
          params.startDate = this.searchForm.dateRange[0]
          params.endDate = this.searchForm.dateRange[1]
        }
        delete params.dateRange

        this.$message.info('正在导出，请稍候...')
        const res = await exportOperationLog(params)

        // 创建下载链接
        const blob = new Blob([res], { type: 'application/vnd.ms-excel' })
        const url = window.URL.createObjectURL(blob)
        const link = document.createElement('a')
        link.href = url
        link.download = `操作日志_${new Date().getTime()}.xlsx`
        link.click()
        window.URL.revokeObjectURL(url)

        this.$message.success('导出成功')
      } catch (error) {
        this.$message.error('导出失败')
      }
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
.operation-log-container {
  padding: 20px;

  .search-card {
    margin-bottom: 20px;
  }

  .search-form {
    .el-form-item {
      margin-bottom: 0;
    }
  }

  pre {
    background-color: #f5f7fa;
    padding: 10px;
    border-radius: 4px;
    font-size: 12px;
    line-height: 1.5;
  }
}
</style>

