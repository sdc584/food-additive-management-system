<template>
  <div class="usage-record-container">
    <el-card shadow="never">
      <div style="margin-bottom: 20px;">
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增使用记录</el-button>
      </div>
      <el-table :data="tableData" v-loading="loading" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="additiveName" label="添加剂名称" min-width="150"></el-table-column>
        <el-table-column prop="usageQuantity" label="使用数量" width="100" align="right"></el-table-column>
        <el-table-column prop="productName" label="产品名称" width="150"></el-table-column>
        <el-table-column prop="batchNo" label="批次号" width="120"></el-table-column>
        <el-table-column prop="usageDate" label="使用日期" width="120"></el-table-column>
        <el-table-column prop="operator" label="操作人" width="100"></el-table-column>
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
import { getUsageRecordList, deleteUsageRecord } from '@/api/usageRecord'

export default {
  name: 'UsageRecord',
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
        const res = await getUsageRecordList()
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
      this.$message.info('新增使用记录功能开发中...')
    },
    handleView(row) {
      this.$message.info('查看详情功能开发中...')
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
          console.error('删除失败:', error)
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.usage-record-container {
  padding: 20px;
}
</style>

