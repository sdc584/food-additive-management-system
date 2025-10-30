<template>
  <div class="additive-query-container">
    <el-card shadow="never">
      <div slot="header">
        <span style="font-size: 18px; font-weight: bold;">食品添加剂查询</span>
      </div>
      
      <!-- 搜索表单 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="添加剂名称">
          <el-input v-model="searchForm.additiveName" placeholder="请输入添加剂名称" clearable></el-input>
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="searchForm.categoryId" placeholder="请选择分类" clearable>
            <el-option
              v-for="item in categoryList"
              :key="item.categoryId"
              :label="item.categoryName"
              :value="item.categoryId">
            </el-option>
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
        <el-table-column prop="additiveCode" label="编码" width="120"></el-table-column>
        <el-table-column prop="categoryName" label="分类" width="120"></el-table-column>
        <el-table-column prop="purpose" label="用途" min-width="150"></el-table-column>
        <el-table-column prop="maxUsage" label="最大使用量" width="120"></el-table-column>
        <el-table-column prop="safetyLevel" label="安全等级" width="100" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.safetyLevel === 'A'" type="success" size="small">A-安全</el-tag>
            <el-tag v-else-if="scope.row.safetyLevel === 'B'" type="warning" size="small">B-较安全</el-tag>
            <el-tag v-else type="danger" size="small">C-谨慎使用</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 详情对话框 -->
    <el-dialog title="添加剂详情" :visible.sync="detailVisible" width="700px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="添加剂名称">{{ detailData.additiveName }}</el-descriptions-item>
        <el-descriptions-item label="添加剂编码">{{ detailData.additiveCode }}</el-descriptions-item>
        <el-descriptions-item label="CAS号">{{ detailData.casNumber }}</el-descriptions-item>
        <el-descriptions-item label="分子式">{{ detailData.molecularFormula }}</el-descriptions-item>
        <el-descriptions-item label="分类">{{ detailData.categoryName }}</el-descriptions-item>
        <el-descriptions-item label="安全等级">
          <el-tag v-if="detailData.safetyLevel === 'A'" type="success" size="small">A-安全</el-tag>
          <el-tag v-else-if="detailData.safetyLevel === 'B'" type="warning" size="small">B-较安全</el-tag>
          <el-tag v-else type="danger" size="small">C-谨慎使用</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="用途" :span="2">{{ detailData.purpose }}</el-descriptions-item>
        <el-descriptions-item label="最大使用量" :span="2">{{ detailData.maxUsage }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'AdditiveQuery',
  data() {
    return {
      loading: false,
      searchForm: {
        additiveName: '',
        categoryId: null
      },
      tableData: [],
      categoryList: [],
      detailVisible: false,
      detailData: {}
    }
  },
  created() {
    this.loadCategoryList()
    this.loadData()
  },
  methods: {
    async loadCategoryList() {
      // TODO: 调用API加载分类列表
      this.categoryList = []
    },
    async loadData() {
      this.loading = true
      // TODO: 调用API加载数据
      setTimeout(() => {
        this.tableData = []
        this.loading = false
      }, 500)
    },
    handleSearch() {
      this.loadData()
    },
    handleReset() {
      this.searchForm = { additiveName: '', categoryId: null }
      this.loadData()
    },
    handleView(row) {
      this.detailData = { ...row }
      this.detailVisible = true
    }
  }
}
</script>

<style lang="scss" scoped>
.additive-query-container {
  padding: 20px;

  .search-form {
    .el-form-item {
      margin-bottom: 0;
    }
  }
}
</style>

