<template>
  <div class="inventory-query-container">
    <el-card shadow="never">
      <div slot="header">
        <span style="font-size: 18px; font-weight: bold;">库存查询</span>
      </div>
      
      <!-- 搜索表单 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="添加剂名称">
          <el-input v-model="searchForm.additiveName" placeholder="请输入添加剂名称" clearable></el-input>
        </el-form-item>
        <el-form-item label="仓库位置">
          <el-input v-model="searchForm.warehouseLocation" placeholder="请输入仓库位置" clearable></el-input>
        </el-form-item>
        <el-form-item label="库存状态">
          <el-select v-model="searchForm.stockStatus" placeholder="请选择库存状态" clearable>
            <el-option label="正常" value="normal"></el-option>
            <el-option label="库存不足" value="low"></el-option>
            <el-option label="库存充足" value="high"></el-option>
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
        <el-table-column prop="currentStock" label="当前库存" width="120" align="right">
          <template slot-scope="scope">
            <span :class="{'stock-warning': scope.row.currentStock < scope.row.minStock}">
              {{ scope.row.currentStock }} {{ scope.row.unit || 'kg' }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="minStock" label="最小库存" width="120" align="right">
          <template slot-scope="scope">
            {{ scope.row.minStock }} {{ scope.row.unit || 'kg' }}
          </template>
        </el-table-column>
        <el-table-column prop="maxStock" label="最大库存" width="120" align="right">
          <template slot-scope="scope">
            {{ scope.row.maxStock }} {{ scope.row.unit || 'kg' }}
          </template>
        </el-table-column>
        <el-table-column prop="warehouseLocation" label="仓库位置" width="150"></el-table-column>
        <el-table-column label="库存状态" width="120" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.currentStock < scope.row.minStock" type="danger" size="small">库存不足</el-tag>
            <el-tag v-else-if="scope.row.currentStock > scope.row.maxStock" type="warning" size="small">库存过多</el-tag>
            <el-tag v-else type="success" size="small">正常</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="lastPurchaseDate" label="最后采购日期" width="120"></el-table-column>
        <el-table-column prop="lastUsageDate" label="最后使用日期" width="120"></el-table-column>
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
    <el-dialog title="库存详情" :visible.sync="detailVisible" width="700px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="添加剂名称">{{ detailData.additiveName }}</el-descriptions-item>
        <el-descriptions-item label="添加剂编码">{{ detailData.additiveCode }}</el-descriptions-item>
        <el-descriptions-item label="当前库存">
          <span :class="{'stock-warning': detailData.currentStock < detailData.minStock}">
            {{ detailData.currentStock }} {{ detailData.unit || 'kg' }}
          </span>
        </el-descriptions-item>
        <el-descriptions-item label="最小库存">{{ detailData.minStock }} {{ detailData.unit || 'kg' }}</el-descriptions-item>
        <el-descriptions-item label="最大库存">{{ detailData.maxStock }} {{ detailData.unit || 'kg' }}</el-descriptions-item>
        <el-descriptions-item label="库存状态">
          <el-tag v-if="detailData.currentStock < detailData.minStock" type="danger" size="small">库存不足</el-tag>
          <el-tag v-else-if="detailData.currentStock > detailData.maxStock" type="warning" size="small">库存过多</el-tag>
          <el-tag v-else type="success" size="small">正常</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="仓库位置">{{ detailData.warehouseLocation }}</el-descriptions-item>
        <el-descriptions-item label="货架号">{{ detailData.shelfNumber || '未设置' }}</el-descriptions-item>
        <el-descriptions-item label="最后采购日期">{{ detailData.lastPurchaseDate || '无' }}</el-descriptions-item>
        <el-descriptions-item label="最后使用日期">{{ detailData.lastUsageDate || '无' }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'InventoryQuery',
  data() {
    return {
      loading: false,
      searchForm: {
        additiveName: '',
        warehouseLocation: '',
        stockStatus: null
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
        // TODO: 调用API加载数据
        // const response = await this.$http.get('/api/user/inventories', {
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
        warehouseLocation: '',
        stockStatus: null
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
.inventory-query-container {
  padding: 20px;

  .search-form {
    .el-form-item {
      margin-bottom: 0;
    }
  }

  .stock-warning {
    color: #F56C6C;
    font-weight: bold;
  }
}
</style>

