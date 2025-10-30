<template>
  <div class="purchase-record-container">
    <el-card shadow="never">
      <div style="margin-bottom: 20px;">
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增采购记录</el-button>
      </div>
      <el-table :data="tableData" v-loading="loading" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="purchaseNo" label="采购单号" width="150"></el-table-column>
        <el-table-column prop="additiveName" label="添加剂名称" min-width="150"></el-table-column>
        <el-table-column prop="supplierName" label="供应商" width="150"></el-table-column>
        <el-table-column prop="quantity" label="采购数量" width="100" align="right"></el-table-column>
        <el-table-column prop="unitPrice" label="单价" width="100" align="right"></el-table-column>
        <el-table-column prop="totalPrice" label="总价" width="120" align="right"></el-table-column>
        <el-table-column prop="purchaseDate" label="采购日期" width="120"></el-table-column>
        <el-table-column prop="status" label="状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.status === 0" type="warning" size="small">待审核</el-tag>
            <el-tag v-else-if="scope.row.status === 1" type="success" size="small">已审核</el-tag>
            <el-tag v-else type="info" size="small">已入库</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="text" size="small" @click="handleDelete(scope.row)" style="color: #F56C6C;">删除</el-button>
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
      <el-form ref="dataForm" :model="formData" :rules="formRules" label-width="120px">
        <el-form-item label="采购单号" prop="purchaseNo">
          <el-input v-model="formData.purchaseNo" placeholder="请输入采购单号"></el-input>
        </el-form-item>
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
        <el-form-item label="供应商" prop="supplierId">
          <el-select v-model="formData.supplierId" placeholder="请选择供应商" style="width: 100%" filterable>
            <el-option
              v-for="item in supplierList"
              :key="item.supplierId"
              :label="item.supplierName"
              :value="item.supplierId">
            </el-option>
          </el-select>
        </el-form-item>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="采购数量" prop="quantity">
              <el-input-number v-model="formData.quantity" :min="0" :precision="2" style="width: 100%"></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="单价" prop="unitPrice">
              <el-input-number v-model="formData.unitPrice" :min="0" :precision="2" style="width: 100%"></el-input-number>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="采购日期" prop="purchaseDate">
          <el-date-picker
            v-model="formData.purchaseDate"
            type="date"
            placeholder="选择日期"
            value-format="yyyy-MM-dd"
            style="width: 100%">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio :label="0">待审核</el-radio>
            <el-radio :label="1">已审核</el-radio>
            <el-radio :label="2">已入库</el-radio>
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
import { getPurchaseRecordList, addPurchaseRecord, updatePurchaseRecord, deletePurchaseRecord } from '@/api/purchaseRecord'
import { getFoodAdditiveList } from '@/api/foodAdditive'
import { getSupplierList } from '@/api/supplier'

export default {
  name: 'PurchaseRecord',
  data() {
    return {
      loading: false,
      submitLoading: false,
      tableData: [],
      additiveList: [],
      supplierList: [],
      dialogVisible: false,
      dialogTitle: '',
      dialogType: 'add',
      formData: {},
      formRules: {
        purchaseNo: [{ required: true, message: '请输入采购单号', trigger: 'blur' }],
        additiveId: [{ required: true, message: '请选择添加剂', trigger: 'change' }],
        supplierId: [{ required: true, message: '请选择供应商', trigger: 'change' }],
        quantity: [{ required: true, message: '请输入采购数量', trigger: 'blur' }],
        unitPrice: [{ required: true, message: '请输入单价', trigger: 'blur' }]
      }
    }
  },
  created() {
    this.loadData()
    this.loadAdditiveList()
    this.loadSupplierList()
  },
  methods: {
    async loadData() {
      this.loading = true
      try {
        const res = await getPurchaseRecordList()
        if (res.code === 200) {
          this.tableData = res.data || []
          // 添加关联名称
          this.tableData.forEach(item => {
            const additive = this.additiveList.find(a => a.additiveId === item.additiveId)
            const supplier = this.supplierList.find(s => s.supplierId === item.supplierId)
            if (additive) item.additiveName = additive.additiveName
            if (supplier) item.supplierName = supplier.supplierName
            // 计算总价
            if (item.quantity && item.unitPrice) {
              item.totalPrice = (item.quantity * item.unitPrice).toFixed(2)
            }
          })
        }
      } catch (error) {
        console.error('加载数据失败:', error)
      } finally {
        this.loading = false
      }
    },
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
    async loadSupplierList() {
      try {
        const res = await getSupplierList()
        if (res.code === 200) {
          this.supplierList = res.data || []
        }
      } catch (error) {
        console.error('加载供应商列表失败:', error)
      }
    },
    handleAdd() {
      this.dialogType = 'add'
      this.dialogTitle = '新增采购记录'
      this.formData = { status: 0, quantity: 0, unitPrice: 0 }
      this.dialogVisible = true
    },
    handleEdit(row) {
      this.dialogType = 'edit'
      this.dialogTitle = '编辑采购记录'
      this.formData = { ...row }
      this.dialogVisible = true
    },
    handleDelete(row) {
      this.$confirm(`确定要删除采购单号"${row.purchaseNo}"吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await deletePurchaseRecord(row.recordId)
          if (res.code === 200) {
            this.$message.success('删除成功')
            this.loadData()
          }
        } catch (error) {
          console.error('删除失败:', error)
        }
      })
    },
    handleSubmit() {
      this.$refs.dataForm.validate(async (valid) => {
        if (valid) {
          this.submitLoading = true
          try {
            // 计算总价
            if (this.formData.quantity && this.formData.unitPrice) {
              this.formData.totalPrice = this.formData.quantity * this.formData.unitPrice
            }
            let res
            if (this.dialogType === 'add') {
              res = await addPurchaseRecord(this.formData)
            } else {
              res = await updatePurchaseRecord(this.formData)
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
    handleDialogClose() {
      this.$refs.dataForm.resetFields()
      this.formData = {}
    }
  }
}
</script>

<style lang="scss" scoped>
.purchase-record-container {
  padding: 20px;
}
</style>

