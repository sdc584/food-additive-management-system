<template>
  <div class="warning-view-container">
    <el-card shadow="never">
      <div slot="header">
        <span style="font-size: 18px; font-weight: bold;">预警信息</span>
      </div>

      <!-- 统计卡片 -->
      <el-row :gutter="20" class="stats-row">
        <el-col :xs="24" :sm="8" :md="8">
          <div class="stat-card stat-card-danger">
            <div class="stat-icon">
              <i class="el-icon-warning"></i>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.highLevel }}</div>
              <div class="stat-label">高级预警</div>
            </div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="8" :md="8">
          <div class="stat-card stat-card-warning">
            <div class="stat-icon">
              <i class="el-icon-warning-outline"></i>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.mediumLevel }}</div>
              <div class="stat-label">中级预警</div>
            </div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="8" :md="8">
          <div class="stat-card stat-card-info">
            <div class="stat-icon">
              <i class="el-icon-info"></i>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.lowLevel }}</div>
              <div class="stat-label">低级预警</div>
            </div>
          </div>
        </el-col>
      </el-row>
      
      <!-- 搜索表单 -->
      <el-form :inline="true" :model="searchForm" class="search-form" style="margin-top: 20px;">
        <el-form-item label="添加剂名称">
          <el-input v-model="searchForm.additiveName" placeholder="请输入添加剂名称" clearable></el-input>
        </el-form-item>
        <el-form-item label="预警类型">
          <el-select v-model="searchForm.warningType" placeholder="请选择预警类型" clearable>
            <el-option label="库存预警" value="库存预警"></el-option>
            <el-option label="过期预警" value="过期预警"></el-option>
            <el-option label="质量预警" value="质量预警"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="预警级别">
          <el-select v-model="searchForm.warningLevel" placeholder="请选择预警级别" clearable>
            <el-option label="高" value="高"></el-option>
            <el-option label="中" value="中"></el-option>
            <el-option label="低" value="低"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="处理状态">
          <el-select v-model="searchForm.status" placeholder="请选择处理状态" clearable>
            <el-option label="未处理" :value="0"></el-option>
            <el-option label="处理中" :value="1"></el-option>
            <el-option label="已处理" :value="2"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
          <el-button icon="el-icon-refresh" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>

      <!-- 数据表格 -->
      <el-table :data="tableData" v-loading="loading" stripe border style="margin-top: 20px;">
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="additiveName" label="添加剂名称" min-width="150"></el-table-column>
        <el-table-column prop="warningType" label="预警类型" width="100" align="center"></el-table-column>
        <el-table-column prop="warningLevel" label="预警级别" width="100" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.warningLevel === '高'" type="danger" size="small">高</el-tag>
            <el-tag v-else-if="scope.row.warningLevel === '中'" type="warning" size="small">中</el-tag>
            <el-tag v-else type="info" size="small">低</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="warningContent" label="预警内容" min-width="200" show-overflow-tooltip></el-table-column>
        <el-table-column prop="warningTime" label="预警时间" width="150"></el-table-column>
        <el-table-column prop="status" label="处理状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.status === 0" type="danger" size="small">未处理</el-tag>
            <el-tag v-else-if="scope.row.status === 1" type="warning" size="small">处理中</el-tag>
            <el-tag v-else type="success" size="small">已处理</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
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
    <el-dialog title="预警详情" :visible.sync="detailVisible" width="700px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="添加剂名称">{{ detailData.additiveName }}</el-descriptions-item>
        <el-descriptions-item label="添加剂编码">{{ detailData.additiveCode }}</el-descriptions-item>
        <el-descriptions-item label="预警类型">{{ detailData.warningType }}</el-descriptions-item>
        <el-descriptions-item label="预警级别">
          <el-tag v-if="detailData.warningLevel === '高'" type="danger" size="small">高</el-tag>
          <el-tag v-else-if="detailData.warningLevel === '中'" type="warning" size="small">中</el-tag>
          <el-tag v-else type="info" size="small">低</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="预警内容" :span="2">{{ detailData.warningContent }}</el-descriptions-item>
        <el-descriptions-item label="预警时间">{{ detailData.warningTime }}</el-descriptions-item>
        <el-descriptions-item label="处理状态">
          <el-tag v-if="detailData.status === 0" type="danger" size="small">未处理</el-tag>
          <el-tag v-else-if="detailData.status === 1" type="warning" size="small">处理中</el-tag>
          <el-tag v-else type="success" size="small">已处理</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="处理人" v-if="detailData.handler">{{ detailData.handler }}</el-descriptions-item>
        <el-descriptions-item label="处理时间" v-if="detailData.handleTime">{{ detailData.handleTime }}</el-descriptions-item>
        <el-descriptions-item label="处理结果" :span="2" v-if="detailData.handleResult">{{ detailData.handleResult }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
      </el-descriptions>

      <div slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'WarningView',
  data() {
    return {
      loading: false,
      stats: {
        highLevel: 0,
        mediumLevel: 0,
        lowLevel: 0
      },
      searchForm: {
        additiveName: '',
        warningType: null,
        warningLevel: null,
        status: null
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
    this.loadStats()
    this.loadData()
  },
  methods: {
    async loadStats() {
      try {
        // TODO: 调用API加载统计数据
        // const response = await this.$http.get('/api/user/warnings/stats')
        // this.stats = response.data
        this.stats = {
          highLevel: 0,
          mediumLevel: 0,
          lowLevel: 0
        }
      } catch (error) {
        console.error('加载统计数据失败', error)
      }
    },
    async loadData() {
      this.loading = true
      try {
        // TODO: 调用API加载数据
        // const response = await this.$http.get('/api/user/warnings', {
        //   params: {
        //     ...this.searchForm,
        //     page: this.pagination.currentPage,
        //     size: this.pagination.pageSize
        //   }
        // })
        // this.tableData = response.data.records
        // this.pagination.total = response.data.total
        
        // 模拟数据
        setTimeout(() => {
          this.tableData = []
          this.pagination.total = 0
          this.loading = false
        }, 500)
      } catch (error) {
        this.$message.error('加载数据失败')
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
        warningType: null,
        warningLevel: null,
        status: null
      }
      this.pagination.currentPage = 1
      this.loadData()
    },
    handleView(row) {
      this.detailData = { ...row }
      this.detailVisible = true
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
.warning-view-container {
  padding: 20px;

  .stats-row {
    margin-bottom: 20px;

    .stat-card {
      display: flex;
      align-items: center;
      padding: 20px;
      border-radius: 8px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      margin-bottom: 10px;

      &.stat-card-danger {
        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      }

      &.stat-card-warning {
        background: linear-gradient(135deg, #fad0c4 0%, #ffd1ff 100%);
        color: #333;
      }

      &.stat-card-info {
        background: linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%);
        color: #333;
      }

      .stat-icon {
        font-size: 48px;
        margin-right: 20px;
        opacity: 0.8;
      }

      .stat-info {
        flex: 1;

        .stat-value {
          font-size: 32px;
          font-weight: bold;
          margin-bottom: 5px;
        }

        .stat-label {
          font-size: 14px;
          opacity: 0.9;
        }
      }
    }
  }

  .search-form {
    .el-form-item {
      margin-bottom: 0;
    }
  }

  .dialog-footer {
    text-align: right;
  }
}
</style>

