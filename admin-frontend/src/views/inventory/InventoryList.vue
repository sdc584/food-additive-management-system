<template>
  <div class="inventory-list-container">
    <!-- 搜索栏 -->
    <el-card class="search-card" shadow="never">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="添加剂">
          <el-select v-model="searchForm.additiveId" placeholder="请选择添加剂" clearable filterable>
            <el-option
              v-for="item in additiveList"
              :key="item.additiveId"
              :label="item.additiveName"
              :value="item.additiveId">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="仓库位置">
          <el-input v-model="searchForm.warehouseLocation" placeholder="请输入仓库位置" clearable></el-input>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="正常" :value="1"></el-option>
            <el-option label="停用" :value="0"></el-option>
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
        <el-table-column prop="currentStock" label="当前库存" width="120" align="right">
          <template slot-scope="scope">
            <span :class="{'stock-warning': scope.row.currentStock < scope.row.minStock}">
              {{ scope.row.currentStock }}
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="minStock" label="最小库存" width="120" align="right"></el-table-column>
        <el-table-column prop="maxStock" label="最大库存" width="120" align="right"></el-table-column>
        <el-table-column prop="warehouseLocation" label="仓库位置" width="150"></el-table-column>
        <el-table-column prop="lastPurchaseDate" label="最后采购日期" width="120"></el-table-column>
        <el-table-column prop="lastUsageDate" label="最后使用日期" width="120"></el-table-column>
        <el-table-column prop="status" label="状态" width="80" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'info'" size="small">
              {{ scope.row.status === 1 ? '正常' : '停用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" align="center" fixed="right">
          <template slot-scope="scope">
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
      width="700px"
      :close-on-click-modal="false"
      @close="handleDialogClose">
      <el-form
        ref="dataForm"
        :model="formData"
        :rules="formRules"
        label-width="120px">
        <el-form-item label="添加剂" prop="additiveId">
          <el-select v-model="formData.additiveId" placeholder="请选择添加剂" style="width: 100%" filterable>
            <el-option
              v-for="item in additiveList"
              :key="item.additiveId"
              :label="item.additiveName"
              :value="item.additiveId">
            </el-option>
          </el-select>
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="当前库存" prop="currentStock">
              <el-input-number v-model="formData.currentStock" :min="0" :precision="2" style="width: 100%"></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="最小库存" prop="minStock">
              <el-input-number v-model="formData.minStock" :min="0" :precision="2" style="width: 100%"></el-input-number>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="最大库存" prop="maxStock">
              <el-input-number v-model="formData.maxStock" :min="0" :precision="2" style="width: 100%"></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="仓库位置" prop="warehouseLocation">
              <el-input v-model="formData.warehouseLocation" placeholder="请输入仓库位置"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="最后采购日期" prop="lastPurchaseDate">
              <el-date-picker
                v-model="formData.lastPurchaseDate"
                type="date"
                placeholder="选择日期"
                value-format="yyyy-MM-dd"
                style="width: 100%">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="最后使用日期" prop="lastUsageDate">
              <el-date-picker
                v-model="formData.lastUsageDate"
                type="date"
                placeholder="选择日期"
                value-format="yyyy-MM-dd"
                style="width: 100%">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio :label="1">正常</el-radio>
            <el-radio :label="0">停用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getInventoryList, addInventory, updateInventory, deleteInventory } from '@/api/inventory'
import { getFoodAdditiveList } from '@/api/foodAdditive'

export default {
  name: 'InventoryList',
  data() {
    return {
      loading: false,
      submitLoading: false,
      searchForm: {
        additiveId: null,
        warehouseLocation: '',
        status: null
      },
      tableData: [],
      additiveList: [],
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0
      },
      dialogVisible: false,
      dialogTitle: '',
      dialogType: 'add',
      formData: {},
      formRules: {
        additiveId: [
          { required: true, message: '请选择添加剂', trigger: 'change' }
        ],
        currentStock: [
          { required: true, message: '请输入当前库存', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.loadData()
    this.loadAdditiveList()
  },
  methods: {
    // 加载数据
    async loadData() {
      this.loading = true
      try {
        const res = await getInventoryList(this.searchForm)
        if (res.code === 200) {
          this.tableData = res.data || []
          // 添加添加剂名称
          this.tableData.forEach(item => {
            const additive = this.additiveList.find(a => a.additiveId === item.additiveId)
            if (additive) {
              item.additiveName = additive.additiveName
            }
          })
          this.pagination.total = this.tableData.length
        }
      } catch (error) {
        console.error('加载数据失败:', error)
      } finally {
        this.loading = false
      }
    },
    // 加载添加剂列表
    async loadAdditiveList() {
      try {
        const res = await getFoodAdditiveList()
        if (res.code === 200) {
          this.additiveList = res.data || []
        }
      } catch (error) {
        console.error('加载添加剂列表失败:', error)
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
        additiveId: null,
        warehouseLocation: '',
        status: null
      }
      this.loadData()
    },
    // 新增
    handleAdd() {
      this.dialogType = 'add'
      this.dialogTitle = '新增库存'
      this.formData = {
        status: 1,
        currentStock: 0,
        minStock: 0,
        maxStock: 0
      }
      this.dialogVisible = true
    },
    // 编辑
    handleEdit(row) {
      this.dialogType = 'edit'
      this.dialogTitle = '编辑库存'
      this.formData = { ...row }
      this.dialogVisible = true
    },
    // 删除
    handleDelete(row) {
      this.$confirm(`确定要删除该库存记录吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await deleteInventory(row.inventoryId)
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
              res = await addInventory(this.formData)
            } else {
              res = await updateInventory(this.formData)
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
.inventory-list-container {
  padding: 20px;

  .search-card {
    margin-bottom: 20px;
  }

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

