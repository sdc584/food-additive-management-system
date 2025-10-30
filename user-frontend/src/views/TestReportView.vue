<template>
  <div class="test-report-view-container">
    <el-card shadow="never">
      <div slot="header">
        <span style="font-size: 18px; font-weight: bold;">检测报告查询</span>
      </div>
      
      <!-- 搜索表单 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="添加剂名称">
          <el-input v-model="searchForm.additiveName" placeholder="请输入添加剂名称" clearable></el-input>
        </el-form-item>
        <el-form-item label="检测日期">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="检测结果">
          <el-select v-model="searchForm.testResult" placeholder="请选择检测结果" clearable>
            <el-option label="合格" value="合格"></el-option>
            <el-option label="不合格" value="不合格"></el-option>
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
        <el-table-column prop="reportNumber" label="报告编号" width="150"></el-table-column>
        <el-table-column prop="additiveName" label="添加剂名称" min-width="150"></el-table-column>
        <el-table-column prop="testDate" label="检测日期" width="110"></el-table-column>
        <el-table-column prop="testOrganization" label="检测机构" min-width="150"></el-table-column>
        <el-table-column prop="testResult" label="检测结果" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.testResult === '合格' ? 'success' : 'danger'" size="small">
              {{ scope.row.testResult }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="tester" label="检测人" width="100"></el-table-column>
        <el-table-column label="操作" width="150" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="small" icon="el-icon-view" @click="handleView(scope.row)">查看详情</el-button>
            <el-button type="text" size="small" icon="el-icon-download" @click="handleDownload(scope.row)">下载</el-button>
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
    <el-dialog title="检测报告详情" :visible.sync="detailVisible" width="800px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="报告编号" :span="2">{{ detailData.reportNumber }}</el-descriptions-item>
        <el-descriptions-item label="添加剂名称">{{ detailData.additiveName }}</el-descriptions-item>
        <el-descriptions-item label="添加剂编码">{{ detailData.additiveCode }}</el-descriptions-item>
        <el-descriptions-item label="检测日期">{{ detailData.testDate }}</el-descriptions-item>
        <el-descriptions-item label="检测机构">{{ detailData.testOrganization }}</el-descriptions-item>
        <el-descriptions-item label="检测人">{{ detailData.tester }}</el-descriptions-item>
        <el-descriptions-item label="检测结果">
          <el-tag :type="detailData.testResult === '合格' ? 'success' : 'danger'" size="small">
            {{ detailData.testResult }}
          </el-tag>
        </el-descriptions-item>
      </el-descriptions>

      <el-divider content-position="left">检测项目</el-divider>
      <el-table :data="detailData.testItems || []" border size="small">
        <el-table-column prop="itemName" label="检测项目" min-width="120"></el-table-column>
        <el-table-column prop="standard" label="标准值" width="120"></el-table-column>
        <el-table-column prop="actualValue" label="实测值" width="120"></el-table-column>
        <el-table-column prop="result" label="结果" width="80" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.result === '合格' ? 'success' : 'danger'" size="mini">
              {{ scope.row.result }}
            </el-tag>
          </template>
        </el-table-column>
      </el-table>

      <el-divider content-position="left">其他信息</el-divider>
      <el-descriptions :column="1" border>
        <el-descriptions-item label="检测方法">{{ detailData.testMethod || '无' }}</el-descriptions-item>
        <el-descriptions-item label="检测设备">{{ detailData.testEquipment || '无' }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ detailData.remark || '无' }}</el-descriptions-item>
      </el-descriptions>

      <div slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button type="primary" icon="el-icon-download" @click="handleDownload(detailData)">下载报告</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'TestReportView',
  data() {
    return {
      loading: false,
      searchForm: {
        additiveName: '',
        dateRange: null,
        testResult: null
      },
      tableData: [],
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0
      },
      detailVisible: false,
      detailData: {
        testItems: []
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
        // TODO: 调用API加载数据
        // const params = {
        //   ...this.searchForm,
        //   page: this.pagination.currentPage,
        //   size: this.pagination.pageSize
        // }
        // if (this.searchForm.dateRange && this.searchForm.dateRange.length === 2) {
        //   params.startDate = this.searchForm.dateRange[0]
        //   params.endDate = this.searchForm.dateRange[1]
        // }
        // const response = await this.$http.get('/api/user/testReports', { params })
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
        dateRange: null,
        testResult: null
      }
      this.pagination.currentPage = 1
      this.loadData()
    },
    async handleView(row) {
      try {
        // TODO: 调用API获取详细信息
        // const response = await this.$http.get(`/api/user/testReports/${row.reportId}`)
        // this.detailData = response.data
        
        // 模拟数据
        this.detailData = {
          ...row,
          testItems: [
            { itemName: '纯度', standard: '≥99%', actualValue: '99.5%', result: '合格' },
            { itemName: '重金属', standard: '≤10ppm', actualValue: '5ppm', result: '合格' },
            { itemName: 'pH值', standard: '6.0-8.0', actualValue: '7.2', result: '合格' }
          ],
          testMethod: '国标GB/T 1234-2020',
          testEquipment: '高效液相色谱仪'
        }
        this.detailVisible = true
      } catch (error) {
        this.$message.error('获取详情失败')
      }
    },
    handleDownload(row) {
      this.$message.info('下载功能开发中，报告编号：' + row.reportNumber)
      // TODO: 实现下载功能
      // window.open(`/api/user/testReports/${row.reportId}/download`)
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
.test-report-view-container {
  padding: 20px;

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

