<template>
  <div class="test-report-container">
    <el-card shadow="never">
      <div style="margin-bottom: 20px;">
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增检测报告</el-button>
      </div>
      <el-table :data="tableData" v-loading="loading" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="additiveName" label="添加剂名称" min-width="150"></el-table-column>
        <el-table-column prop="reportNo" label="报告编号" width="150"></el-table-column>
        <el-table-column prop="testDate" label="检测日期" width="120"></el-table-column>
        <el-table-column prop="testResult" label="检测结果" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.testResult === '合格' ? 'success' : 'danger'" size="small">
              {{ scope.row.testResult }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="testOrganization" label="检测机构" width="150"></el-table-column>
        <el-table-column label="操作" width="150" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看</el-button>
            <el-button type="text" size="small" @click="handleDelete(scope.row)" style="color: #F56C6C;">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

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
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="700px">
      <el-form ref="reportForm" :model="formData" :rules="formRules" label-width="120px">
        <el-form-item label="添加剂" prop="additiveId">
          <el-select v-model="formData.additiveId" placeholder="请选择添加剂" filterable style="width: 100%;">
            <el-option
              v-for="item in additiveList"
              :key="item.additiveId"
              :label="item.additiveName"
              :value="item.additiveId">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="报告编号" prop="reportNo">
          <el-input v-model="formData.reportNo" placeholder="请输入报告编号"></el-input>
        </el-form-item>
        <el-form-item label="检测日期" prop="testDate">
          <el-date-picker
            v-model="formData.testDate"
            type="date"
            placeholder="选择日期"
            value-format="yyyy-MM-dd"
            style="width: 100%;">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="检测机构" prop="testOrganization">
          <el-input v-model="formData.testOrganization" placeholder="请输入检测机构"></el-input>
        </el-form-item>
        <el-form-item label="检测人员" prop="testPerson">
          <el-input v-model="formData.testPerson" placeholder="请输入检测人员"></el-input>
        </el-form-item>
        <el-form-item label="检测结果" prop="testResult">
          <el-radio-group v-model="formData.testResult">
            <el-radio label="合格">合格</el-radio>
            <el-radio label="不合格">不合格</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="检测项目" prop="testItems">
          <el-input
            v-model="formData.testItems"
            type="textarea"
            :rows="3"
            placeholder="请输入检测项目，多个项目用逗号分隔">
          </el-input>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input
            v-model="formData.remark"
            type="textarea"
            :rows="3"
            placeholder="请输入备注">
          </el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitting">确定</el-button>
      </div>
    </el-dialog>

    <!-- 查看详情对话框 -->
    <el-dialog title="检测报告详情" :visible.sync="detailVisible" width="700px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="报告编号">{{ detailData.reportNo }}</el-descriptions-item>
        <el-descriptions-item label="添加剂名称">{{ detailData.additiveName }}</el-descriptions-item>
        <el-descriptions-item label="检测日期">{{ detailData.testDate }}</el-descriptions-item>
        <el-descriptions-item label="检测机构">{{ detailData.testOrganization }}</el-descriptions-item>
        <el-descriptions-item label="检测人员">{{ detailData.testPerson }}</el-descriptions-item>
        <el-descriptions-item label="检测结果">
          <el-tag :type="detailData.testResult === '合格' ? 'success' : 'danger'" size="small">
            {{ detailData.testResult }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="检测项目" :span="2">{{ detailData.testItems }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间" :span="2">{{ detailData.createTime }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button type="primary" icon="el-icon-download">下载报告</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getTestReportList, getTestReportById, createTestReport, deleteTestReport } from '@/api/testReport'
import { getAdditiveList } from '@/api/additive'

export default {
  name: 'TestReport',
  data() {
    return {
      loading: false,
      submitting: false,
      tableData: [],
      additiveList: [],
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0
      },
      dialogVisible: false,
      detailVisible: false,
      dialogTitle: '新增检测报告',
      formData: {
        reportId: null,
        additiveId: null,
        reportNo: '',
        testDate: '',
        testOrganization: '',
        testPerson: '',
        testResult: '合格',
        testItems: '',
        remark: ''
      },
      detailData: {},
      formRules: {
        additiveId: [
          { required: true, message: '请选择添加剂', trigger: 'change' }
        ],
        reportNo: [
          { required: true, message: '请输入报告编号', trigger: 'blur' }
        ],
        testDate: [
          { required: true, message: '请选择检测日期', trigger: 'change' }
        ],
        testOrganization: [
          { required: true, message: '请输入检测机构', trigger: 'blur' }
        ],
        testPerson: [
          { required: true, message: '请输入检测人员', trigger: 'blur' }
        ],
        testResult: [
          { required: true, message: '请选择检测结果', trigger: 'change' }
        ]
      }
    }
  },
  created() {
    this.loadData()
    this.loadAdditiveList()
  },
  methods: {
    async loadData() {
      this.loading = true
      try {
        const res = await getTestReportList({
          page: this.pagination.currentPage,
          size: this.pagination.pageSize
        })
        if (res.code === 200) {
          this.tableData = res.data.records || []
          this.pagination.total = res.data.total || 0
        }
      } catch (error) {
        this.$message.error('加载数据失败')
      } finally {
        this.loading = false
      }
    },
    async loadAdditiveList() {
      try {
        const res = await getAdditiveList()
        if (res.code === 200) {
          this.additiveList = res.data || []
        }
      } catch (error) {
        console.error('加载添加剂列表失败:', error)
      }
    },
    handleAdd() {
      this.dialogTitle = '新增检测报告'
      this.formData = {
        reportId: null,
        additiveId: null,
        reportNo: '',
        testDate: '',
        testOrganization: '',
        testPerson: '',
        testResult: '合格',
        testItems: '',
        remark: ''
      }
      this.dialogVisible = true
      this.$nextTick(() => {
        this.$refs.reportForm.clearValidate()
      })
    },
    async handleView(row) {
      try {
        const res = await getTestReportById(row.reportId)
        if (res.code === 200) {
          this.detailData = res.data
          this.detailVisible = true
        }
      } catch (error) {
        this.$message.error('加载详情失败')
      }
    },
    handleSubmit() {
      this.$refs.reportForm.validate(async (valid) => {
        if (!valid) return false

        this.submitting = true
        try {
          const res = await createTestReport(this.formData)
          if (res.code === 200) {
            this.$message.success('新增成功')
            this.dialogVisible = false
            this.loadData()
          }
        } catch (error) {
          this.$message.error('新增失败')
        } finally {
          this.submitting = false
        }
      })
    },
    handleDelete(row) {
      this.$confirm('确定要删除该检测报告吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const res = await deleteTestReport(row.reportId)
          if (res.code === 200) {
            this.$message.success('删除成功')
            this.loadData()
          }
        } catch (error) {
          this.$message.error('删除失败')
        }
      })
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
.test-report-container {
  padding: 20px;
}
</style>

