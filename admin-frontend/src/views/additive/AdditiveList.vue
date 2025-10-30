<template>
  <div class="additive-list-container">
    <!-- 搜索栏 -->
    <el-card class="search-card" shadow="never">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="添加剂名称">
          <el-input v-model="searchForm.additiveName" placeholder="请输入添加剂名称" clearable></el-input>
        </el-form-item>
        <el-form-item label="添加剂编号">
          <el-input v-model="searchForm.additiveCode" placeholder="请输入添加剂编号" clearable></el-input>
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
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="启用" :value="1"></el-option>
            <el-option label="禁用" :value="0"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleSearch">查询</el-button>
          <el-button icon="el-icon-refresh" @click="handleReset">重置</el-button>
          <el-button type="success" icon="el-icon-plus" @click="handleAdd">新增</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 数据表格 -->
    <el-card class="table-card" shadow="never">
      <el-table
        v-loading="loading"
        :data="tableData"
        stripe
        border
        style="width: 100%">
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="additiveName" label="添加剂名称" min-width="150"></el-table-column>
        <el-table-column prop="additiveCode" label="添加剂编号" width="120"></el-table-column>
        <el-table-column prop="categoryName" label="分类" width="120"></el-table-column>
        <el-table-column prop="casNumber" label="CAS号" width="120"></el-table-column>
        <el-table-column prop="specification" label="规格" width="100"></el-table-column>
        <el-table-column prop="unit" label="单位" width="80" align="center"></el-table-column>
        <el-table-column prop="safetyLevel" label="安全等级" width="100" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.safetyLevel === 'A'" type="success" size="small">安全</el-tag>
            <el-tag v-else-if="scope.row.safetyLevel === 'B'" type="warning" size="small">较安全</el-tag>
            <el-tag v-else-if="scope.row.safetyLevel === 'C'" type="danger" size="small">谨慎使用</el-tag>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'info'" size="small">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" icon="el-icon-view" @click="handleView(scope.row)">查看</el-button>
            <el-button type="text" size="small" icon="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="text" size="small" icon="el-icon-delete" @click="handleDelete(scope.row)" style="color: #F56C6C;">删除</el-button>
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

    <!-- 新增/编辑对话框 -->
    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      width="800px"
      :close-on-click-modal="false"
      @close="handleDialogClose">
      <el-form
        ref="dataForm"
        :model="formData"
        :rules="formRules"
        label-width="120px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="添加剂名称" prop="additiveName">
              <el-input v-model="formData.additiveName" placeholder="请输入添加剂名称"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="添加剂编号" prop="additiveCode">
              <el-input v-model="formData.additiveCode" placeholder="请输入添加剂编号"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="分类" prop="categoryId">
              <el-select v-model="formData.categoryId" placeholder="请选择分类" style="width: 100%">
                <el-option
                  v-for="item in categoryList"
                  :key="item.categoryId"
                  :label="item.categoryName"
                  :value="item.categoryId">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="CAS号" prop="casNumber">
              <el-input v-model="formData.casNumber" placeholder="请输入CAS号"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="分子式" prop="molecularFormula">
              <el-input v-model="formData.molecularFormula" placeholder="请输入分子式"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="规格" prop="specification">
              <el-input v-model="formData.specification" placeholder="请输入规格"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="单位" prop="unit">
              <el-input v-model="formData.unit" placeholder="请输入单位"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="最大使用量" prop="maxUsage">
              <el-input v-model="formData.maxUsage" placeholder="请输入最大使用量(g/kg)">
                <template slot="append">g/kg</template>
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="安全等级" prop="safetyLevel">
              <el-select v-model="formData.safetyLevel" placeholder="请选择安全等级" style="width: 100%">
                <el-option label="A-安全" value="A"></el-option>
                <el-option label="B-较安全" value="B"></el-option>
                <el-option label="C-谨慎使用" value="C"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="formData.status">
                <el-radio :label="1">启用</el-radio>
                <el-radio :label="0">禁用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="使用范围" prop="usageScope">
          <el-input v-model="formData.usageScope" type="textarea" :rows="3" placeholder="请输入使用范围"></el-input>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="formData.description" type="textarea" :rows="3" placeholder="请输入描述"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确 定</el-button>
      </div>
    </el-dialog>

    <!-- 查看详情对话框 -->
    <el-dialog
      title="添加剂详情"
      :visible.sync="viewDialogVisible"
      width="800px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="添加剂名称">{{ viewData.additiveName }}</el-descriptions-item>
        <el-descriptions-item label="添加剂编号">{{ viewData.additiveCode }}</el-descriptions-item>
        <el-descriptions-item label="分类">{{ viewData.categoryName }}</el-descriptions-item>
        <el-descriptions-item label="CAS号">{{ viewData.casNumber }}</el-descriptions-item>
        <el-descriptions-item label="分子式">{{ viewData.molecularFormula }}</el-descriptions-item>
        <el-descriptions-item label="规格">{{ viewData.specification }}</el-descriptions-item>
        <el-descriptions-item label="单位">{{ viewData.unit }}</el-descriptions-item>
        <el-descriptions-item label="最大使用量">{{ viewData.maxUsage }} g/kg</el-descriptions-item>
        <el-descriptions-item label="安全等级">
          <el-tag v-if="viewData.safetyLevel === 'A'" type="success" size="small">安全</el-tag>
          <el-tag v-else-if="viewData.safetyLevel === 'B'" type="warning" size="small">较安全</el-tag>
          <el-tag v-else-if="viewData.safetyLevel === 'C'" type="danger" size="small">谨慎使用</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="viewData.status === 1 ? 'success' : 'info'" size="small">
            {{ viewData.status === 1 ? '启用' : '禁用' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="使用范围" :span="2">{{ viewData.usageScope }}</el-descriptions-item>
        <el-descriptions-item label="描述" :span="2">{{ viewData.description }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ viewData.createTime }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ viewData.updateTime }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="viewDialogVisible = false">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getFoodAdditiveList, addFoodAdditive, updateFoodAdditive, deleteFoodAdditive, getFoodAdditiveById } from '@/api/foodAdditive'
import { getCategoryList } from '@/api/additiveCategory'

export default {
  name: 'AdditiveList',
  data() {
    return {
      loading: false,
      submitLoading: false,
      searchForm: {
        additiveName: '',
        additiveCode: '',
        categoryId: null,
        status: null
      },
      tableData: [],
      categoryList: [],
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0
      },
      dialogVisible: false,
      viewDialogVisible: false,
      dialogTitle: '',
      dialogType: 'add', // add, edit
      formData: {},
      viewData: {},
      formRules: {
        additiveName: [
          { required: true, message: '请输入添加剂名称', trigger: 'blur' }
        ],
        additiveCode: [
          { required: true, message: '请输入添加剂编号', trigger: 'blur' }
        ],
        categoryId: [
          { required: true, message: '请选择分类', trigger: 'change' }
        ]
      }
    }
  },
  created() {
    this.loadData()
    this.loadCategoryList()
  },
  methods: {
    // 加载数据
    async loadData() {
      this.loading = true
      try {
        const res = await getFoodAdditiveList(this.searchForm)
        if (res.code === 200) {
          this.tableData = res.data || []
          this.pagination.total = this.tableData.length
        }
      } catch (error) {
        console.error('加载数据失败:', error)
      } finally {
        this.loading = false
      }
    },
    // 加载分类列表
    async loadCategoryList() {
      try {
        const res = await getCategoryList()
        if (res.code === 200) {
          this.categoryList = res.data || []
        }
      } catch (error) {
        console.error('加载分类列表失败:', error)
      }
    },
    // 搜索
    handleSearch() {
      this.pagination.currentPage = 1
      this.loadData()
    },
    // 重置
    handleReset() {
      this.searchForm = {
        additiveName: '',
        additiveCode: '',
        categoryId: null,
        status: null
      }
      this.loadData()
    },
    // 新增
    handleAdd() {
      this.dialogType = 'add'
      this.dialogTitle = '新增添加剂'
      this.formData = {
        status: 1,
        unit: 'kg'
      }
      this.dialogVisible = true
    },
    // 编辑
    handleEdit(row) {
      this.dialogType = 'edit'
      this.dialogTitle = '编辑添加剂'
      this.formData = { ...row }
      this.dialogVisible = true
    },
    // 查看
    handleView(row) {
      this.viewData = { ...row }
      // 添加分类名称
      const category = this.categoryList.find(c => c.categoryId === row.categoryId)
      if (category) {
        this.viewData.categoryName = category.categoryName
      }
      this.viewDialogVisible = true
    },
    // 删除
    handleDelete(row) {
      this.$confirm(`确定要删除添加剂"${row.additiveName}"吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await deleteFoodAdditive(row.additiveId)
          if (res.code === 200) {
            this.$message.success('删除成功')
            this.loadData()
          }
        } catch (error) {
          console.error('删除失败:', error)
        }
      })
    },
    // 提交表单
    handleSubmit() {
      this.$refs.dataForm.validate(async (valid) => {
        if (valid) {
          this.submitLoading = true
          try {
            let res
            if (this.dialogType === 'add') {
              res = await addFoodAdditive(this.formData)
            } else {
              res = await updateFoodAdditive(this.formData)
            }
            if (res.code === 200) {
              this.$message.success(this.dialogType === 'add' ? '新增成功' : '更新成功')
              this.dialogVisible = false
              this.loadData()
            }
          } catch (error) {
            console.error('提交失败:', error)
          } finally {
            this.submitLoading = false
          }
        }
      })
    },
    // 对话框关闭
    handleDialogClose() {
      this.$refs.dataForm.resetFields()
      this.formData = {}
    },
    // 分页
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
.additive-list-container {
  padding: 20px;

  .search-card {
    margin-bottom: 20px;
  }

  .search-form {
    .el-form-item {
      margin-bottom: 0;
    }
  }

  .table-card {
    .el-table {
      margin-bottom: 20px;
    }
  }
}
</style>

