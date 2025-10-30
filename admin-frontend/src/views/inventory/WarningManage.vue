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
            <el-tag :type="scope.row.status === 1 ? 'success' : 'warning'" size="small">
              {{ scope.row.status === 1 ? '已处理' : '未处理' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" align="center">
          <template slot-scope="scope">
            <el-button v-if="scope.row.status === 0" type="text" size="small" @click="handleProcess(scope.row)">处理</el-button>
            <span v-else style="color: #909399;">已处理</span>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { getWarningList, updateWarning } from '@/api/warning'

export default {
  name: 'WarningManage',
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
      this.$confirm('确定要标记为已处理吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await updateWarning({ ...row, status: 1 })
          if (res.code === 200) {
            this.$message.success('处理成功')
            this.loadData()
          }
        } catch (error) {
          console.error('处理失败:', error)
        }
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

