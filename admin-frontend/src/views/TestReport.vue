<template>
  <div class="test-report-container">
    <el-card shadow="never">
      <div style="margin-bottom: 20px;">
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增检测报告</el-button>
      </div>
      <el-table :data="tableData" v-loading="loading" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="additiveName" label="添加剂名称" min-width="150"></el-table-column>
        <el-table-column prop="reportNo" label="报告编号" width="150"></el-table-column>
        <el-table-column prop="testDate" label="检测日期" width="120"></el-table-column>
        <el-table-column prop="testResult" label="检测结果" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.testResult === '合格' ? 'success' : 'danger'" size="small">
              {{ scope.row.testResult }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="testOrganization" label="检测机构" width="150"></el-table-column>
        <el-table-column label="操作" width="150" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看</el-button>
            <el-button type="text" size="small" @click="handleDelete(scope.row)" style="color: #F56C6C;">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { getTestReportList, deleteTestReport } from '@/api/testReport'

export default {
  name: 'TestReport',
  data() {
    return {
      loading: false,
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
        const res = await getTestReportList()
        if (res.code === 200) {
          this.tableData = res.data || []
        }
      } catch (error) {
        console.error('加载数据失败:', error)
      } finally {
        this.loading = false
      }
    },
    handleAdd() {
      this.$message.info('新增检测报告功能开发中...')
    },
    handleView(row) {
      this.$message.info('查看详情功能开发中...')
    },
    handleDelete(row) {
      this.$confirm('确定要删除该检测报告吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await deleteTestReport(row.reportId)
          if (res.code === 200) {
            this.$message.success('删除成功')
            this.loadData()
          }
        } catch (error) {
          console.error('删除失败:', error)
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.test-report-container {
  padding: 20px;
}
</style>

