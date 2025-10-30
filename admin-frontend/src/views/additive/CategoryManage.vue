<template>
  <div class="category-manage-container">
    <!-- 操作栏 -->
    <el-card class="toolbar-card" shadow="never">
      <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增分类</el-button>
      <el-button icon="el-icon-refresh" @click="loadData">刷新</el-button>
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
        <el-table-column prop="categoryName" label="分类名称" min-width="150"></el-table-column>
        <el-table-column prop="categoryCode" label="分类编码" width="150"></el-table-column>
        <el-table-column prop="description" label="描述" min-width="200"></el-table-column>
        <el-table-column prop="status" label="状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'info'" size="small">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180"></el-table-column>
        <el-table-column label="操作" width="180" align="center" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" icon="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="text" size="small" icon="el-icon-delete" @click="handleDelete(scope.row)" style="color: #F56C6C;">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      width="600px"
      :close-on-click-modal="false"
      @close="handleDialogClose">
      <el-form
        ref="dataForm"
        :model="formData"
        :rules="formRules"
        label-width="100px">
        <el-form-item label="分类名称" prop="categoryName">
          <el-input v-model="formData.categoryName" placeholder="请输入分类名称"></el-input>
        </el-form-item>
        <el-form-item label="分类编码" prop="categoryCode">
          <el-input v-model="formData.categoryCode" placeholder="请输入分类编码"></el-input>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="formData.description" type="textarea" :rows="4" placeholder="请输入描述"></el-input>
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
import { getCategoryList, addCategory, updateCategory, deleteCategory } from '@/api/additiveCategory'

export default {
  name: 'CategoryManage',
  data() {
    return {
      loading: false,
      submitLoading: false,
      tableData: [],
      dialogVisible: false,
      dialogTitle: '',
      dialogType: 'add',
      formData: {},
      formRules: {
        categoryName: [
          { required: true, message: '请输入分类名称', trigger: 'blur' }
        ],
        categoryCode: [
          { required: true, message: '请输入分类编码', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.loadData()
  },
  methods: {
    // 加载数据
    async loadData() {
      this.loading = true
      try {
        const res = await getCategoryList()
        if (res.code === 200) {
          this.tableData = res.data || []
        }
      } catch (error) {
        console.error('加载数据失败:', error)
      } finally {
        this.loading = false
      }
    },
    // 新增
    handleAdd() {
      this.dialogType = 'add'
      this.dialogTitle = '新增分类'
      this.formData = {
        status: 1
      }
      this.dialogVisible = true
    },
    // 编辑
    handleEdit(row) {
      this.dialogType = 'edit'
      this.dialogTitle = '编辑分类'
      this.formData = { ...row }
      this.dialogVisible = true
    },
    // 删除
    handleDelete(row) {
      this.$confirm(`确定要删除分类"${row.categoryName}"吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await deleteCategory(row.categoryId)
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
              res = await addCategory(this.formData)
            } else {
              res = await updateCategory(this.formData)
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
    }
  }
}
</script>

<style lang="scss" scoped>
.category-manage-container {
  padding: 20px;

  .toolbar-card {
    margin-bottom: 20px;
  }
}
</style>

