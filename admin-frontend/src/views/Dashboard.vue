<template>
  <div class="dashboard-container">
    <!-- 欢迎横幅 -->
    <div class="welcome-banner">
      <div class="welcome-content">
        <h2>欢迎使用食品添加剂管理系统</h2>
        <p>智能化管理，让食品安全更有保障</p>
      </div>
      <div class="welcome-icon">
        <i class="el-icon-s-marketing"></i>
      </div>
    </div>

    <!-- 统计卡片 -->
    <el-row :gutter="20" class="panel-group">
      <el-col :xs="12" :sm="12" :lg="6" class="card-panel-col">
        <div class="card-panel card-panel-1">
          <div class="card-panel-icon-wrapper">
            <i class="el-icon-s-goods card-panel-icon"></i>
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">添加剂种类</div>
            <count-to :start-val="0" :end-val="stats.additiveCount" :duration="2600" class="card-panel-num" />
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :lg="6" class="card-panel-col">
        <div class="card-panel card-panel-2">
          <div class="card-panel-icon-wrapper">
            <i class="el-icon-s-data card-panel-icon"></i>
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">库存总量(kg)</div>
            <count-to :start-val="0" :end-val="stats.inventoryTotal" :duration="3000" class="card-panel-num" />
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :lg="6" class="card-panel-col">
        <div class="card-panel card-panel-3">
          <div class="card-panel-icon-wrapper">
            <i class="el-icon-warning card-panel-icon"></i>
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">供应商数量</div>
            <count-to :start-val="0" :end-val="stats.supplierCount" :duration="3200" class="card-panel-num" />
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :lg="6" class="card-panel-col">
        <div class="card-panel card-panel-4">
          <div class="card-panel-icon-wrapper">
            <i class="el-icon-s-order card-panel-icon"></i>
          </div>
          <div class="card-panel-description">
            <div class="card-panel-text">本月操作</div>
            <count-to :start-val="0" :end-val="stats.operationCount" :duration="3600" class="card-panel-num" />
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 快捷功能和数据展示 -->
    <el-row :gutter="20">
      <!-- 快捷功能区 -->
      <el-col :xs="24" :sm="24" :lg="12">
        <div class="quick-actions-section">
          <h3 class="section-title">快捷功能</h3>
          <el-row :gutter="20">
            <el-col :xs="12" :sm="12" :lg="12">
              <div class="action-card" @click="handleQuickAction('search')">
                <div class="action-icon action-icon-1">
                  <i class="el-icon-search"></i>
                </div>
                <p class="action-text">添加剂查询</p>
              </div>
            </el-col>
            <el-col :xs="12" :sm="12" :lg="12">
              <div class="action-card" @click="handleQuickAction('inventory')">
                <div class="action-icon action-icon-2">
                  <i class="el-icon-s-data"></i>
                </div>
                <p class="action-text">库存查看</p>
              </div>
            </el-col>
            <el-col :xs="12" :sm="12" :lg="12">
              <div class="action-card" @click="handleQuickAction('record')">
                <div class="action-icon action-icon-3">
                  <i class="el-icon-document"></i>
                </div>
                <p class="action-text">使用登记</p>
              </div>
            </el-col>
            <el-col :xs="12" :sm="12" :lg="12">
              <div class="action-card" @click="handleQuickAction('report')">
                <div class="action-icon action-icon-4">
                  <i class="el-icon-s-marketing"></i>
                </div>
                <p class="action-text">检测报告</p>
              </div>
            </el-col>
          </el-row>
        </div>
      </el-col>

      <!-- 添加剂分类占比图表 -->
      <el-col :xs="24" :sm="24" :lg="12">
        <div class="chart-wrapper chart-wrapper-tall">
          <div class="chart-title">
            <i class="el-icon-pie-chart"></i>
            添加剂分类占比
          </div>
          <div id="categoryChart" style="height: 380px; display: flex; align-items: center; justify-content: center; color: #999;">
            图表功能开发中...
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 最近操作记录 -->
    <el-row :gutter="20">
      <el-col :xs="24" :sm="24" :lg="24">
        <div class="chart-wrapper">
          <div class="chart-title">
            <i class="el-icon-s-order"></i>
            最近操作记录
          </div>
          <el-table :data="recentLogs" style="width: 100%" stripe>
            <el-table-column prop="time" label="时间" width="180"></el-table-column>
            <el-table-column prop="user" label="操作人" width="120"></el-table-column>
            <el-table-column prop="action" label="操作"></el-table-column>
            <el-table-column prop="status" label="状态" width="100" align="center">
              <template slot-scope="scope">
                <el-tag :type="scope.row.status === '成功' ? 'success' : 'danger'" size="small">
                  {{ scope.row.status }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { getDashboardStats, getRecentLogs } from '@/api/dashboard'

export default {
  name: 'Dashboard',
  data() {
    return {
      stats: {
        additiveCount: 0,
        inventoryTotal: 0,
        supplierCount: 0,
        operationCount: 0
      },
      recentLogs: [],
      loading: false
    }
  },
  mounted() {
    this.loadStats()
    this.loadRecentLogs()
    this.initCharts()
  },
  methods: {
    // 加载统计数据
    async loadStats() {
      try {
        const res = await getDashboardStats()
        if (res.code === 200) {
          this.stats = {
            additiveCount: res.data.additiveCount || 0,
            inventoryTotal: parseFloat(res.data.inventoryTotal) || 0,
            supplierCount: res.data.supplierCount || 0,
            operationCount: res.data.operationCount || 0
          }
        }
      } catch (error) {
        console.error('加载统计数据失败', error)
        this.$message.error('加载统计数据失败')
      }
    },
    // 加载最近的操作日志
    async loadRecentLogs() {
      try {
        this.loading = true
        const res = await getRecentLogs(5)
        if (res.code === 200 && res.data && res.data.length > 0) {
          // 转换数据格式以适配页面显示
          this.recentLogs = res.data.map(log => ({
            time: this.formatDateTime(log.operationTime),
            user: log.username || '系统',
            action: log.operation || log.method,
            status: log.status === 1 ? '成功' : '失败'
          }))
        } else {
          // 如果没有数据，显示提示
          this.recentLogs = [
            { time: '暂无数据', user: '-', action: '暂无操作记录', status: '-' }
          ]
        }
      } catch (error) {
        console.error('加载操作日志失败', error)
        // 如果加载失败，使用默认数据
        this.recentLogs = [
          { time: '暂无数据', user: '-', action: '暂无操作记录', status: '-' }
        ]
      } finally {
        this.loading = false
      }
    },
    // 格式化日期时间
    formatDateTime(dateTime) {
      if (!dateTime) return '-'
      const date = new Date(dateTime)
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      const hours = String(date.getHours()).padStart(2, '0')
      const minutes = String(date.getMinutes()).padStart(2, '0')
      const seconds = String(date.getSeconds()).padStart(2, '0')
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
    },
    initCharts() {
      // 这里可以初始化图表，暂时留空
      console.log('图表初始化')
    },
    handleQuickAction(action) {
      this.$message.info(`${action} 功能开发中`)
    }
  },
  components: {
    CountTo: {
      props: {
        startVal: { type: Number, default: 0 },
        endVal: { type: Number, default: 0 },
        duration: { type: Number, default: 3000 }
      },
      data() {
        return {
          displayValue: this.startVal
        }
      },
      watch: {
        endVal(newVal, oldVal) {
          if (newVal !== oldVal) {
            this.animateValue(oldVal, newVal)
          }
        }
      },
      mounted() {
        if (this.endVal > 0) {
          this.animateValue(this.startVal, this.endVal)
        }
      },
      methods: {
        animateValue(start, end) {
          this.displayValue = start
          const range = end - start
          const increment = range / (this.duration / 16)
          const step = () => {
            this.displayValue += increment
            if ((increment > 0 && this.displayValue < end) || (increment < 0 && this.displayValue > end)) {
              requestAnimationFrame(step)
            } else {
              this.displayValue = end
            }
          }
          requestAnimationFrame(step)
        }
      },
      render(h) {
        return h('span', Math.floor(this.displayValue))
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.dashboard-container {
  padding: 20px;
  background-color: #f0f2f5;
  min-height: calc(100vh - 50px);
}

/* 欢迎横幅 */
.welcome-banner {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  padding: 40px;
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
  color: white;

  .welcome-content {
    h2 {
      font-size: 28px;
      margin: 0 0 10px 0;
      font-weight: 600;
    }

    p {
      font-size: 16px;
      margin: 0;
      opacity: 0.9;
    }
  }

  .welcome-icon {
    i {
      font-size: 100px;
      opacity: 0.3;
    }
  }
}

/* 统计卡片 */
.panel-group {
  margin-bottom: 20px;
}

.card-panel-col {
  margin-bottom: 20px;
}

.card-panel {
  height: 108px;
  cursor: pointer;
  font-size: 12px;
  position: relative;
  overflow: hidden;
  color: #666;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, .1);
  border-radius: 8px;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 4px 16px rgba(0, 0, 0, .15);
  }

  .card-panel-icon-wrapper {
    float: left;
    margin: 14px 0 0 14px;
    padding: 16px;
    transition: all 0.38s ease-out;
    border-radius: 12px;
    color: white;
  }

  .card-panel-icon {
    float: left;
    font-size: 48px;
  }

  .card-panel-description {
    float: right;
    font-weight: bold;
    margin: 26px 26px 26px 0;

    .card-panel-text {
      line-height: 18px;
      color: rgba(0, 0, 0, 0.45);
      font-size: 16px;
      margin-bottom: 12px;
    }

    .card-panel-num {
      font-size: 24px;
      color: #333;
    }
  }
}

/* 不同卡片的颜色 */
.card-panel-1 .card-panel-icon-wrapper {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.card-panel-2 .card-panel-icon-wrapper {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.card-panel-3 .card-panel-icon-wrapper {
  background: linear-gradient(135deg, #ffa751 0%, #ffe259 100%);
}

.card-panel-4 .card-panel-icon-wrapper {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

/* 快捷功能区域 */
.quick-actions-section {
  background: white;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, .1);

  .section-title {
    margin: 0 0 20px 0;
    font-size: 18px;
    font-weight: 600;
    color: #333;
  }

  .action-card {
    background: #f8f9fa;
    border-radius: 8px;
    padding: 30px 20px;
    text-align: center;
    cursor: pointer;
    transition: all 0.3s;
    border: 2px solid transparent;
    margin-bottom: 20px;

    &:hover {
      background: white;
      border-color: #667eea;
      transform: translateY(-5px);
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
    }

    .action-icon {
      width: 60px;
      height: 60px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 15px;
      color: white;

      i {
        font-size: 30px;
      }
    }

    .action-icon-1 {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }

    .action-icon-2 {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    }

    .action-icon-3 {
      background: linear-gradient(135deg, #ffa751 0%, #ffe259 100%);
    }

    .action-icon-4 {
      background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    }

    .action-text {
      margin: 0;
      color: #333;
      font-size: 14px;
      font-weight: 500;
    }
  }
}

/* 图表区域 */
.chart-wrapper {
  background: #fff;
  padding: 20px;
  margin-bottom: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, .1);

  .chart-title {
    font-size: 16px;
    font-weight: 600;
    color: #333;
    margin-bottom: 16px;
    display: flex;
    align-items: center;

    i {
      margin-right: 8px;
      color: #667eea;
    }
  }
}

/* 响应式 */
@media (max-width:1024px) {
  .card-panel-description {
    display: none;
  }

  .card-panel-icon-wrapper {
    float: none !important;
    width: 100%;
    height: 100%;
    margin: 0 !important;

    .card-panel-icon {
      display: block;
      margin: 14px auto !important;
      float: none !important;
    }
  }

  .welcome-banner {
    padding: 30px 20px;

    .welcome-icon {
      display: none;
    }
  }
}
</style>

