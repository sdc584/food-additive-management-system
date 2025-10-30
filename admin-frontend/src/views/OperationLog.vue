<template>
  <div class="operation-log-container">
    <el-card shadow="never">
      <el-form :inline="true" :model="searchForm" style="margin-bottom: 20px;">
        <el-form-item label="操作人">
          <el-input v-model="searchForm.operator" placeholder="请输入操作人" clearable></el-input>
        </el-form-item>
        <el-form-item label="操作类型">
          <el-select v-model="searchForm.operationType" placeholder="请选择操作类型" clearable>
            <el-option label="新增" value="INSERT"></el-option>
            <el-option label="更新" value="UPDATE"></el-option>
            <el-option label="删除" value="DELETE"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
          <el-button icon="el-icon-refresh" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
      <el-table :data="tableData" v-loading="loading" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="operationType" label="操作类型" width="100" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.operationType === 'INSERT'" type="success" size="small">新增</el-tag>
            <el-tag v-else-if="scope.row.operationType === 'UPDATE'" type="warning" size="small">更新</el-tag>
            <el-tag v-else type="danger" size="small">删除</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="moduleName" label="模块名称" width="120"></el-table-column>
        <el-table-column prop="operationContent" label="操作内容" min-width="200"></el-table-column>
        <el-table-column prop="operator" label="操作人" width="100"></el-table-column>
        <el-table-column prop="operationTime" label="操作时间" width="180"></el-table-column>
        <el-table-column prop="ipAddress" label="IP地址" width="130"></el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { getOperationLogList } from '@/api/operationLog'

export default {
  name: 'OperationLog',
  data() {
    return {
      loading: false,
      searchForm: {
        operator: '',
        operationType: ''
      },
      tableData: []
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    async loadData() {
      this.loading = true
      try {
        const res = await getOperationLogList(this.searchForm)
        if (res.code === 200) {
          this.tableData = res.data || []
        }
      } catch (error) {
        console.error('加载数据失败:', error)
      } finally {
        this.loading = false
      }
    },
    handleSearch() {
      this.loadData()
    },
    handleReset() {
      this.searchForm = { operator: '', operationType: '' }
      this.loadData()
    }
  }
}
</script>

<style lang="scss" scoped>
.operation-log-container {
  padding: 20px;
}
</style>

