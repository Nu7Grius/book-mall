<template>
  <div class="order-list" v-loading="loading" element-loading-text="加载中...">
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-document"></i>
            订单管理
          </h2>
          <p class="header-subtitle">管理您的订单和发货</p>
        </div>
        <div class="header-stats">
          <div class="stat-item">
            <span class="stat-value">{{ orderStats.all }}</span>
            <span class="stat-label">全部订单</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item">
            <span class="stat-value" style="color: #e6a23c">{{
              orderStats.pending
            }}</span>
            <span class="stat-label">待付款</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item">
            <span class="stat-value" style="color: #409eff">{{
              orderStats.ship
            }}</span>
            <span class="stat-label">待发货</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item">
            <span class="stat-value" style="color: #67c23a">{{
              orderStats.completed
            }}</span>
            <span class="stat-label">已完成</span>
          </div>
        </div>
      </div>
    </el-card>

    <el-card class="search-card">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="订单号" class="search-item">
          <el-input
            v-model="searchForm.orderNo"
            placeholder="请输入订单号"
            clearable
            prefix-icon="el-icon-search"
            style="width: 200px"
          ></el-input>
        </el-form-item>
        <el-form-item label="下单人" class="search-item">
          <el-input
            v-model="searchForm.username"
            placeholder="下单人"
            clearable
            prefix-icon="el-icon-user"
            style="width: 160px"
          ></el-input>
        </el-form-item>
        <el-form-item label="收货人" class="search-item">
          <el-input
            v-model="searchForm.receiverName"
            placeholder="收货人"
            clearable
            prefix-icon="el-icon-location"
            style="width: 160px"
          ></el-input>
        </el-form-item>
        <el-form-item label="状态" class="search-item">
          <el-select
            v-model="searchForm.status"
            placeholder="选择状态"
            clearable
            style="width: 150px"
          >
            <el-option label="待付款" value="待付款"></el-option>
            <el-option label="待发货" value="待发货"></el-option>
            <el-option label="待收货" value="待收货"></el-option>
            <el-option label="待评价" value="待评价"></el-option>
            <el-option label="已完成" value="已完成"></el-option>
            <el-option label="已取消" value="已取消"></el-option>
            <el-option label="退款中" value="退款中"></el-option>
            <el-option label="已退款" value="已退款"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="时间" class="search-item">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd"
            style="width: 280px"
          >
          </el-date-picker>
        </el-form-item>
        <el-form-item class="search-actions">
          <el-button type="primary" @click="searchOrders" icon="el-icon-search">
            搜索
          </el-button>
          <el-button @click="resetSearch" icon="el-icon-refresh">
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <el-table :data="orderList" border stripe>
        <el-table-column prop="orderNumber" label="订单号" width="220">
          <template slot-scope="scope">
            <div class="order-number-cell">
              <span>{{ scope.row.orderNumber || "-" }}</span>
              <el-tooltip
                v-if="scope.row.remindShip === 1"
                :content="
                  '用户催促发货（' + formatDate(scope.row.remindTime) + '）'
                "
                placement="top"
              >
                <i class="remind-icon el-icon-bell"></i>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>
        <!-- 商品图片列暂时注释
        <el-table-column label="商品图片" width="100" align="center">
          <template slot-scope="scope">
            <div v-if="scope.row.items && scope.row.items.length > 0 && scope.row.items[0].coverImage">
              <img
                :src="getImageUrl(scope.row.items[0].coverImage)"
                @error="$event.target.style.display='none'"
                style="width: 60px; height: 60px; border-radius: 4px; object-fit: cover;"
              />
            </div>
            <div v-else>
              <i class="el-icon-picture-outline" style="font-size: 24px; color: #909399;"></i>
            </div>
          </template>
        </el-table-column>
        -->
        <el-table-column label="商品名称" min-width="150">
          <template slot-scope="scope">
            <div v-if="scope.row.items && scope.row.items.length > 0">
              <div
                v-for="item in scope.row.items"
                :key="item.id"
                class="order-item"
              >
                <span>{{ item.bookName || "-" }}</span>
                <span class="item-info"
                  >×{{ item.quantity }} ¥{{ item.price }}</span
                >
              </div>
            </div>
            <span v-else>-</span>
          </template>
        </el-table-column>
        <el-table-column prop="totalAmount" label="总金额" width="100">
          <template slot-scope="scope">
            ¥{{ scope.row.totalAmount || "0.00" }}
          </template>
        </el-table-column>
        <el-table-column label="下单人" width="120">
          <template slot-scope="scope">
            {{ scope.row.realName || scope.row.username || "-" }}
          </template>
        </el-table-column>
        <el-table-column prop="receiverName" label="收货人" width="100">
          <template slot-scope="scope">
            {{ scope.row.receiverName || "-" }}
          </template>
        </el-table-column>
        <el-table-column prop="receiverPhone" label="联系电话" width="120">
          <template slot-scope="scope">
            {{ scope.row.receiverPhone || "-" }}
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="下单时间" width="160">
          <template slot-scope="scope">
            {{ formatDate(scope.row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="状态" width="130">
          <template slot-scope="scope">
            <el-tag
              v-if="scope.row.merchantOrderStatus === '待付款'"
              type="warning"
              size="small"
            >
              <i class="el-icon-time"></i> 待付款
            </el-tag>
            <el-tag
              v-else-if="scope.row.merchantOrderStatus === '待发货'"
              type="primary"
              size="small"
            >
              <i class="el-icon-box"></i> 待发货
            </el-tag>
            <el-tag
              v-else-if="scope.row.merchantOrderStatus === '待收货'"
              type="success"
              size="small"
            >
              <i class="el-icon-truck"></i> 待收货
            </el-tag>
            <el-tag
              v-else-if="scope.row.merchantOrderStatus === '待评价'"
              type="warning"
              size="small"
            >
              <i class="el-icon-edit"></i> 待评价
            </el-tag>
            <el-tag
              v-else-if="scope.row.merchantOrderStatus === '已完成'"
              type="success"
              size="small"
            >
              <i class="el-icon-circle-check"></i> 已完成
            </el-tag>
            <el-tag
              v-else-if="scope.row.merchantOrderStatus === '已取消'"
              type="danger"
              size="small"
            >
              <i class="el-icon-circle-close"></i> 已取消
            </el-tag>
            <el-tag
              v-else-if="scope.row.merchantOrderStatus === '退款中'"
              type="warning"
              size="small"
            >
              <i class="el-icon-warning-outline"></i> 退款中
            </el-tag>
            <el-tag
              v-else-if="scope.row.merchantOrderStatus === '已退款'"
              type="danger"
              size="small"
            >
              <i class="el-icon-circle-close"></i> 已退款
            </el-tag>
            <el-tag v-else type="info" size="small">
              {{
                scope.row.merchantOrderStatus || scope.row.orderStatus || "-"
              }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="280" fixed="right">
          <template slot-scope="scope">
            <el-button
              v-if="hasPendingRefund(scope.row)"
              size="mini"
              type="warning"
              @click="handleRefund(scope.row)"
            >
              <i class="el-icon-warning-outline"></i> 处理退款
            </el-button>
            <el-button
              v-else-if="hasRefundingItems(scope.row)"
              size="mini"
              type="danger"
              @click="handleForceShip(scope.row)"
            >
              <i class="el-icon-truck"></i> 强制发货
            </el-button>
            <el-button
              v-if="hasPendingShipItems(scope.row)"
              size="mini"
              type="primary"
              @click="handleShip(scope.row)"
            >
              <i class="el-icon-s-opportunity"></i> 发货
            </el-button>
            <el-button size="mini" type="info" @click="viewDetail(scope.row)">
              <i class="el-icon-view"></i> 详情
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="pagination.page"
        :page-sizes="[10, 20, 50, 100]"
        :page-size="pagination.size"
        layout="total, sizes, prev, pager, next, jumper"
        :total="pagination.total"
        style="margin-top: 20px; text-align: right"
      >
      </el-pagination>
    </el-card>

    <el-dialog
      title="📋 订单详情"
      :visible.sync="detailDialogVisible"
      width="700px"
      class="detail-dialog"
    >
      <div v-if="currentOrder" class="order-detail">
        <div class="detail-header">
          <div class="order-number-display">
            <i class="el-icon-document"></i>
            <span class="order-number">{{ currentOrder.orderNumber }}</span>
            <el-tag
              v-if="currentOrder.merchantOrderStatus === '待付款'"
              type="warning"
              size="small"
            >
              <i class="el-icon-time"></i> 待付款
            </el-tag>
            <el-tag
              v-else-if="currentOrder.merchantOrderStatus === '待发货'"
              type="primary"
              size="small"
            >
              <i class="el-icon-box"></i> 待发货
            </el-tag>
            <el-tag
              v-else-if="currentOrder.merchantOrderStatus === '待收货'"
              type="success"
              size="small"
            >
              <i class="el-icon-truck"></i> 待收货
            </el-tag>
            <el-tag
              v-else-if="currentOrder.merchantOrderStatus === '待评价'"
              type="warning"
              size="small"
            >
              <i class="el-icon-edit"></i> 待评价
            </el-tag>
            <el-tag
              v-else-if="currentOrder.merchantOrderStatus === '已完成'"
              type="success"
              size="small"
            >
              <i class="el-icon-circle-check"></i> 已完成
            </el-tag>
            <el-tag
              v-else-if="currentOrder.merchantOrderStatus === '已取消'"
              type="danger"
              size="small"
            >
              <i class="el-icon-circle-close"></i> 已取消
            </el-tag>
            <el-tag
              v-else-if="currentOrder.merchantOrderStatus === '退款中'"
              type="warning"
              size="small"
            >
              <i class="el-icon-warning-outline"></i> 退款中
            </el-tag>
            <el-tag
              v-else-if="currentOrder.merchantOrderStatus === '已退款'"
              type="danger"
              size="small"
            >
              <i class="el-icon-circle-close"></i> 已退款
            </el-tag>
            <el-tag v-else type="info" size="small">
              {{ currentOrder.merchantOrderStatus || currentOrder.orderStatus }}
            </el-tag>
            <el-tooltip
              v-if="currentOrder.remindShip === 1"
              :content="
                '用户催促发货（' + formatDate(currentOrder.remindTime) + '）'
              "
              placement="top"
            >
              <i class="detail-remind-icon el-icon-bell"></i>
            </el-tooltip>
          </div>
        </div>

        <el-divider />

        <div class="detail-section">
          <div class="section-title">
            <i class="el-icon-goods"></i> 商品信息
          </div>
          <div class="order-items">
            <div
              v-if="currentOrder.items && currentOrder.items.length > 0"
              v-for="item in currentOrder.items.filter(
                (item) => item.merchantId == merchantId
              )"
              :key="item.id"
              class="order-item-card"
            >
              <div class="item-image" v-if="item.coverImage">
                <img
                  :src="getImageUrl(item.coverImage)"
                  @error="$event.target.style.display = 'none'"
                  style="
                    width: 80px;
                    height: 100px;
                    border-radius: 6px;
                    object-fit: cover;
                  "
                />
              </div>
              <div class="item-details">
                <div class="item-info-row">
                  <span class="item-name">{{ item.bookName || "-" }}</span>
                  <span class="item-price">¥{{ item.price }}</span>
                </div>
                <div v-if="item.author" class="item-author">
                  <i class="el-icon-user-solid"></i> {{ item.author }}
                </div>
                <div class="item-quantity-row">
                  <span class="quantity-label">数量：</span>
                  <span class="quantity-value">×{{ item.quantity }}</span>
                  <span class="subtotal"
                    >小计：¥{{ (item.price * item.quantity).toFixed(2) }}</span
                  >
                </div>
                <div
                  v-if="item.expressCompany && item.expressNo"
                  class="item-express-row"
                >
                  <i class="el-icon-truck"></i>
                  <span class="express-label">{{ item.expressCompany }}：</span>
                  <span class="express-no">{{ item.expressNo }}</span>
                </div>
                <div class="item-status-row">
                  <el-tag
                    v-if="item.status === '待付款'"
                    type="warning"
                    size="small"
                  >
                    <i class="el-icon-time"></i> 待付款
                  </el-tag>
                  <el-tag
                    v-else-if="item.status === '待发货'"
                    type="primary"
                    size="small"
                  >
                    <i class="el-icon-box"></i> 待发货
                  </el-tag>
                  <el-tag
                    v-else-if="item.status === '待收货'"
                    type="success"
                    size="small"
                  >
                    <i class="el-icon-truck"></i> 待收货
                  </el-tag>
                  <el-tag
                    v-else-if="item.status === '待评价'"
                    type="warning"
                    size="small"
                  >
                    <i class="el-icon-edit"></i> 待评价
                  </el-tag>
                  <el-tag
                    v-else-if="item.status === '已完成'"
                    type="success"
                    size="small"
                  >
                    <i class="el-icon-circle-check"></i> 已完成
                  </el-tag>
                  <el-tag
                    v-else-if="item.status === '已取消'"
                    type="danger"
                    size="small"
                  >
                    <i class="el-icon-circle-close"></i> 已取消
                  </el-tag>
                  <el-tag
                    v-else-if="item.status === '已退款'"
                    type="danger"
                    size="small"
                  >
                    <i class="el-icon-circle-close"></i> 已退款
                  </el-tag>
                  <el-tag
                    v-else-if="item.status === '退款中'"
                    type="warning"
                    size="small"
                  >
                    <i class="el-icon-warning-outline"></i> 退款中
                  </el-tag>
                  <el-tag v-else type="info" size="small">
                    {{ item.status || "-" }}
                  </el-tag>
                </div>
              </div>
            </div>
            <div v-else class="no-items">暂无商品信息</div>
          </div>
        </div>

        <el-divider />

        <div class="detail-content">
          <div class="detail-row">
            <span class="detail-label"
              ><i class="el-icon-user"></i> 下单人：</span
            >
            <span class="detail-value">{{
              currentOrder.realName || currentOrder.username || "-"
            }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label"
              ><i class="el-icon-mobile-phone"></i> 联系电话：</span
            >
            <span class="detail-value">{{
              currentOrder.receiverPhone || "-"
            }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label"
              ><i class="el-icon-location"></i> 收货地址：</span
            >
            <span class="detail-value address-value">{{
              currentOrder.address || "-"
            }}</span>
          </div>
          <div class="detail-row">
            <span class="detail-label"
              ><i class="el-icon-time"></i> 下单时间：</span
            >
            <span class="detail-value">{{
              formatDate(currentOrder.createTime)
            }}</span>
          </div>
          <div class="detail-row highlight">
            <span class="detail-label"
              ><i class="el-icon-money"></i> 订单总额：</span
            >
            <span class="detail-value total-amount"
              >¥{{ currentOrder.totalAmount || "0.00" }}</span
            >
          </div>
          <div v-if="currentOrder.remark" class="detail-row">
            <span class="detail-label"
              ><i class="el-icon-edit-outline"></i> 备注：</span
            >
            <span class="detail-value">{{ currentOrder.remark }}</span>
          </div>
          <div
            v-if="
              currentOrder.orderStatus === '退款中' ||
              currentOrder.orderStatus === '已退款'
            "
            class="detail-row refund-info"
          >
            <span class="detail-label"
              ><i class="el-icon-warning"></i> 退款信息：</span
            >
            <div class="refund-details">
              <div class="refund-reason" v-if="currentOrder.refundReason">
                <span class="refund-value" style="white-space: pre-wrap">{{
                  currentOrder.refundReason
                }}</span>
              </div>
              <div v-if="currentOrder.merchantReply" class="refund-reply">
                <span class="refund-label">处理回复：</span>
                <span class="refund-value">{{
                  currentOrder.merchantReply
                }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div slot="footer">
        <el-button
          v-if="currentOrder && hasPendingShipItems(currentOrder)"
          type="primary"
          size="medium"
          @click="handleShip(currentOrder)"
        >
          <i class="el-icon-s-opportunity"></i> 发货
        </el-button>
        <el-button @click="detailDialogVisible = false" size="medium"
          >关 闭</el-button
        >
      </div>
    </el-dialog>

    <el-dialog
      :title="'处理退款申请 (' + refundForm.refundItems.length + '个商品)'"
      :visible.sync="refundDialogVisible"
      width="800px"
      class="refund-detail-dialog"
    >
      <div class="refund-detail-content">
        <el-alert
          v-if="refundForm.refundItems.length > 1"
          :title="
            '共有 ' +
            refundForm.refundItems.length +
            ' 个商品申请退款，可批量处理'
          "
          type="info"
          :closable="false"
          show-icon
          style="margin-bottom: 20px"
        />

        <el-divider content-position="left">退款商品列表</el-divider>

        <div class="refund-items-list">
          <el-card
            v-for="(item, index) in refundForm.refundItems"
            :key="index"
            class="refund-item-card"
            :class="{ selected: item.selected }"
            shadow="hover"
          >
            <div class="refund-item-content">
              <div class="refund-checkbox">
                <el-checkbox
                  v-model="item.selected"
                  @change="updateSelectedCount"
                ></el-checkbox>
              </div>
              <div class="refund-item-image">
                <img
                  v-if="item.coverImage || item.bookCover"
                  :src="getImageUrl(item.coverImage || item.bookCover)"
                  alt="商品图片"
                />
                <div v-else class="no-image">无图</div>
              </div>
              <div class="refund-item-info">
                <h4 class="item-name">{{ item.bookName || item.itemName }}</h4>
                <p class="item-meta">
                  <span>单价：¥{{ item.price }}</span>
                  <span>数量：×{{ item.quantity }}</span>
                  <span>小计：¥{{ item.subtotal }}</span>
                </p>
                <p class="refund-reason-text">
                  <i class="el-icon-warning-outline"></i>
                  退款原因：{{ getReasonText(item.refundReason) }}
                  <span v-if="item.refundDescription">
                    - {{ item.refundDescription }}</span
                  >
                </p>
                <p class="refund-amount">
                  申请退款金额：<span class="amount">¥{{ item.subtotal }}</span>
                </p>
              </div>
            </div>
          </el-card>
        </div>

        <div class="selection-toolbar" v-if="refundForm.refundItems.length > 1">
          <el-button size="mini" @click="selectAllItems">全选</el-button>
          <el-button size="mini" @click="deselectAllItems">取消全选</el-button>
          <span class="selected-count">
            已选择 {{ selectedItemsCount }} /
            {{ refundForm.refundItems.length }} 个商品
          </span>
        </div>

        <el-divider content-position="left">订单信息</el-divider>

        <el-descriptions :column="2" border>
          <el-descriptions-item label="订单号">
            {{ refundForm.orderNumber }}
          </el-descriptions-item>
          <el-descriptions-item label="总退款金额">
            <span class="refund-amount-text">¥{{ totalRefundAmount }}</span>
          </el-descriptions-item>
        </el-descriptions>

        <template v-if="refundForm.merchantReply">
          <el-divider content-position="left">商家回复</el-divider>
          <el-alert
            :title="
              refundForm.refundStatus === '已拒绝' ? '拒绝原因' : '回复内容'
            "
            :type="refundForm.refundStatus === '已拒绝' ? 'error' : 'success'"
            :description="refundForm.merchantReply"
            show-icon
            :closable="false"
          >
          </el-alert>
        </template>

        <el-divider content-position="left">处理操作</el-divider>

        <el-form :model="refundForm" label-width="100px">
          <el-form-item label="处理回复">
            <el-input
              v-model="refundForm.merchantReply"
              type="textarea"
              :rows="3"
              placeholder="如果拒绝退款，请填写原因与用户沟通"
            ></el-input>
            <div class="refund-hint">
              <i class="el-icon-info"></i>
              同意退款无需填写原因；拒绝退款时请务必填写原因说明
            </div>
          </el-form-item>
        </el-form>
      </div>
      <div slot="footer">
        <div class="refund-footer">
          <div class="selected-info">
            已选择
            <span class="highlight">{{ selectedItemsCount }}</span> 个商品
          </div>
          <div class="footer-buttons">
            <el-button @click="refundDialogVisible = false">取消</el-button>
            <el-button
              type="success"
              @click="processRefund('approved')"
              :disabled="selectedItemsCount === 0"
            >
              <i class="el-icon-check"></i> 同意退款
            </el-button>
            <el-button
              type="danger"
              @click="processRefund('rejected')"
              :disabled="selectedItemsCount === 0"
            >
              <i class="el-icon-close"></i> 拒绝退款
            </el-button>
          </div>
        </div>
      </div>
    </el-dialog>

    <el-dialog
      title="填写物流信息"
      :visible.sync="shipDialogVisible"
      width="700px"
      class="ship-dialog"
    >
      <div class="ship-form-wrapper">
        <div class="ship-header">
          <div class="ship-order-info">
            <div class="info-row">
              <span class="info-label"
                ><i class="el-icon-document"></i> 订单号：</span
              >
              <span class="info-value">{{
                currentOrder?.orderNumber || "-"
              }}</span>
            </div>
            <div class="info-row">
              <span class="info-label"
                ><i class="el-icon-user"></i> 收货人：</span
              >
              <span class="info-value">{{
                currentOrder?.receiverName || "-"
              }}</span>
            </div>
          </div>
        </div>

        <el-divider></el-divider>

        <div
          class="ship-items-section"
          v-if="
            currentOrder && currentOrder.items && currentOrder.items.length > 0
          "
        >
          <div class="section-title">
            <i class="el-icon-box"></i> 待发货商品
          </div>
          <el-table
            :data="
              forceShipItemIds.length > 0
                ? currentOrder.items.filter((item) =>
                    forceShipItemIds.includes(item.id)
                  )
                : currentOrder.items.filter((item) => item.status === '待发货')
            "
            border
            size="small"
            max-height="200"
            style="margin-bottom: 20px"
          >
            <el-table-column prop="bookName" label="商品名称">
              <template slot-scope="scope">
                <div class="item-book-info">
                  <span>{{ scope.row.bookName }}</span>
                  <span class="item-author" v-if="scope.row.author">
                    {{ scope.row.author }}
                  </span>
                  <el-tag
                    v-if="forceShipItemIds.includes(scope.row.id)"
                    type="warning"
                    size="mini"
                    style="margin-left: 5px"
                  >
                    退款中
                  </el-tag>
                </div>
              </template>
            </el-table-column>
            <el-table-column
              prop="price"
              label="单价"
              width="100"
              align="center"
            >
              <template slot-scope="scope">
                ¥{{ scope.row.price?.toFixed(2) }}
              </template>
            </el-table-column>
            <el-table-column
              prop="quantity"
              label="数量"
              width="80"
              align="center"
            >
            </el-table-column>
            <el-table-column label="小计" width="100" align="center">
              <template slot-scope="scope">
                <span class="item-subtotal">
                  ¥{{
                    scope.row.subtotal?.toFixed(2) ||
                    (scope.row.price * scope.row.quantity)?.toFixed(2)
                  }}
                </span>
              </template>
            </el-table-column>
            <el-table-column label="状态" width="100" align="center">
              <template slot-scope="scope">
                <el-tag
                  :type="scope.row.status === '退款中' ? 'warning' : 'primary'"
                  size="small"
                >
                  <i
                    :class="
                      scope.row.status === '退款中'
                        ? 'el-icon-warning-outline'
                        : 'el-icon-box'
                    "
                  ></i>
                  {{ scope.row.status }}
                </el-tag>
              </template>
            </el-table-column>
          </el-table>
          <div class="items-hint">
            <i class="el-icon-info"></i>
            以上商品将从您的店铺发货
          </div>
        </div>

        <el-form
          ref="shipForm"
          :model="shipForm"
          label-position="top"
          class="ship-form"
        >
          <div class="form-section">
            <div class="section-title">
              <i class="el-icon-truck"></i> 物流信息
            </div>

            <el-form-item
              label="物流公司"
              prop="expressCompany"
              class="required-field"
            >
              <el-select
                v-model="shipForm.expressCompany"
                placeholder="请选择物流公司"
                style="width: 100%"
              >
                <el-option label="顺丰速运" value="顺丰速运"></el-option>
                <el-option label="圆通快递" value="圆通快递"></el-option>
                <el-option label="中通快递" value="中通快递"></el-option>
                <el-option label="韵达快递" value="韵达快递"></el-option>
                <el-option label="申通快递" value="申通快递"></el-option>
                <el-option label="京东物流" value="京东物流"></el-option>
                <el-option label="邮政EMS" value="邮政EMS"></el-option>
                <el-option label="德邦快递" value="德邦快递"></el-option>
                <el-option label="极兔速递" value="极兔速递"></el-option>
                <el-option label="菜鸟裹裹" value="菜鸟裹裹"></el-option>
              </el-select>
            </el-form-item>

            <el-form-item
              label="物流单号"
              prop="expressNo"
              class="required-field"
            >
              <el-input
                v-model="shipForm.expressNo"
                placeholder="请输入物流单号"
                maxlength="20"
                show-word-limit
              >
                <template slot="prefix">
                  <i class="el-icon-postcard"></i>
                </template>
              </el-input>
            </el-form-item>
          </div>

          <div class="form-section">
            <el-form-item label="备注信息">
              <el-input
                v-model="shipForm.remark"
                type="textarea"
                :rows="3"
                placeholder="可添加备注信息，如商品数量、发货时间等"
                maxlength="200"
                show-word-limit
              ></el-input>
              <div class="optional-hint">
                <i class="el-icon-info"></i>
                选填内容，可不填写
              </div>
            </el-form-item>
          </div>

          <div class="force-ship-notice" v-if="forceShipItemIds.length > 0">
            <el-alert
              title="强制发货说明"
              type="warning"
              :closable="false"
              show-icon
            >
              <template>
                <ul class="notice-list">
                  <li>
                    以下
                    <strong>{{ forceShipItemIds.length }}个商品</strong
                    >处于退款中，将被强制发货
                  </li>
                  <li>强制发货将取消这些商品的退款申请</li>
                  <li>请确认物流信息无误后点击确定发货</li>
                </ul>
              </template>
            </el-alert>
          </div>
        </el-form>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="shipDialogVisible = false" size="medium">
          <i class="el-icon-close"></i> 取 消
        </el-button>
        <el-button
          :type="forceShipItemIds.length > 0 ? 'danger' : 'primary'"
          @click="confirmShip"
          size="medium"
          class="confirm-btn"
        >
          <i class="el-icon-check"></i>
          {{ forceShipItemIds.length > 0 ? "强制发货" : "确定发货" }}
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from "@/api/request";

export default {
  name: "MerchantOrderList",
  data() {
    return {
      loading: false,
      isLoading: false,
      searchForm: {
        orderNo: "",
        username: "",
        receiverName: "",
        status: "",
        dateRange: [],
      },
      orderStats: {
        all: 0,
        pending: 0,
        ship: 0,
        completed: 0,
      },
      orderList: [],
      pagination: {
        page: 1,
        size: 10,
        total: 0,
      },
      detailDialogVisible: false,
      currentOrder: null,
      shipDialogVisible: false,
      shipForm: {
        expressCompany: "",
        expressNo: "",
        remark: "",
      },
      forceShipItemIds: [],
      refundDialogVisible: false,
      refundDialogTitle: "处理退款申请",
      refundForm: {
        orderId: null,
        refundId: null,
        orderNumber: "",
        refundAmount: 0,
        refundReason: "",
        refundDescription: "",
        merchantReply: "",
        refundItems: [],
      },
    };
  },
  computed: {
    merchantId() {
      return localStorage.getItem("merchantId");
    },
    remindedOrdersCount() {
      return this.orderList.filter((order) => order.remindShip === 1).length;
    },
    totalRefundAmount() {
      if (
        !this.refundForm.refundItems ||
        this.refundForm.refundItems.length === 0
      ) {
        return 0;
      }
      // 只计算选中的商品金额
      const selectedItems = this.refundForm.refundItems.filter(
        (item) => item.selected
      );
      if (selectedItems.length === 0) {
        return "0.00";
      }
      const total = selectedItems.reduce((sum, item) => {
        return sum + (parseFloat(item.subtotal) || 0);
      }, 0);
      return total.toFixed(2);
    },
    selectedItemsCount() {
      if (!this.refundForm.refundItems) {
        return 0;
      }
      return this.refundForm.refundItems.filter((item) => item.selected).length;
    },
  },
  mounted() {
    this.loadOrders();
  },
  watch: {
    "searchForm.orderNo"() {
      this.pagination.page = 1;
      this.loadOrders();
    },
    "searchForm.username"() {
      this.pagination.page = 1;
      this.loadOrders();
    },
    "searchForm.receiverName"() {
      this.pagination.page = 1;
      this.loadOrders();
    },
    "searchForm.status"() {
      this.pagination.page = 1;
      this.loadOrders();
    },
  },
  methods: {
    hasPendingRefund(order) {
      if (!order.items) {
        return order.orderStatus === "退款中";
      }
      return order.items.some((item) => item.refundStatus === "待处理");
    },
    hasRefundingItems(order) {
      if (!order.items) {
        return order.orderStatus === "退款中";
      }
      return order.items.some((item) => item.status === "退款中");
    },
    hasPendingShipItems(order) {
      // 只检查当前商家的商品
      if (!order.items) {
        return false;
      }
      const currentMerchantId = localStorage.getItem("merchantId");
      const merchantItems = order.items.filter(
        (item) => String(item.merchantId) === String(currentMerchantId)
      );
      return merchantItems.some((item) => item.status === "待发货");
    },
    loadOrders() {
      const merchantId = localStorage.getItem("merchantId");
      if (!merchantId) {
        this.$message.error("无法获取商家信息，请重新登录");
        return;
      }

      // 构建查询参数
      const params = {
        merchantId: parseInt(merchantId),
        page: this.pagination.page,
        pageSize: this.pagination.size,
      };

      // 添加搜索条件
      if (this.searchForm.orderNo) {
        params.orderNumber = this.searchForm.orderNo;
      }
      if (this.searchForm.username) {
        params.username = this.searchForm.username;
      }
      if (this.searchForm.receiverName) {
        params.receiverName = this.searchForm.receiverName;
      }
      if (this.searchForm.status) {
        params.orderStatus = this.searchForm.status;
      }
      if (this.searchForm.dateRange && this.searchForm.dateRange.length === 2) {
        params.startDate = this.searchForm.dateRange[0];
        params.endDate = this.searchForm.dateRange[1];
      }

      // 调用后端API
      this.$http
        .get("/order/merchant/page", { params })
        .then((res) => {
          if (res.code === 200) {
            const records = res.data?.records || res.data?.list || [];
            this.orderList = records;

            if (res.data?.total !== undefined) {
              this.pagination.total = res.data.total || 0;
            }
            this.updateOrderStats();
          } else {
            this.$message.error(res.message || "加载订单失败");
          }
        })
        .catch(() => {
          this.$message.error("加载订单失败，请稍后重试");
        });
    },
    updateOrderStats() {
      // 从订单列表中统计各状态的数量（使用商家视角的订单状态）
      this.orderStats.pending = this.orderList.filter(
        (o) => o.merchantOrderStatus === "待付款"
      ).length;
      this.orderStats.ship = this.orderList.filter(
        (o) => o.merchantOrderStatus === "待发货"
      ).length;
      this.orderStats.completed = this.orderList.filter(
        (o) => o.merchantOrderStatus === "已完成"
      ).length;
    },
    searchOrders() {
      this.pagination.page = 1;
      this.loadOrders();
    },
    resetSearch() {
      this.searchForm = {
        orderNo: "",
        username: "",
        receiverName: "",
        status: "",
        dateRange: [],
      };
      this.searchOrders();
    },
    startAutoRefresh() {
      if (this.refreshInterval) return;
      this.refreshInterval = setInterval(() => {
        this.loadOrders();
      }, 10000);
    },
    stopAutoRefresh() {
      if (this.refreshInterval) {
        clearInterval(this.refreshInterval);
        this.refreshInterval = null;
      }
    },
    handleSizeChange(size) {
      this.pagination.size = size;
      this.loadOrders();
    },
    handleCurrentChange(page) {
      this.pagination.page = page;
      this.loadOrders();
    },
    viewDetail(row) {
      // 先复制列表数据
      this.currentOrder = { ...row };
      // 打开对话框
      this.detailDialogVisible = true;
      // 重新加载订单详情，确保显示最新数据（包括物流信息）
      this.loadOrderDetail(row.id);
    },
    loadOrderDetail(orderId) {
      const merchantId = localStorage.getItem("merchantId");
      this.$http
        .get(`/order/${orderId}?merchantId=${merchantId}`)
        .then((res) => {
          if (res.code === 200) {
            // 后端返回的是 {order: {...}, items: [...], refund: {...}} 结构
            const orderData = res.data.order || res.data;
            if (orderData) {
              // 合并订单基本信息和详情数据
              this.currentOrder = { ...this.currentOrder, ...orderData };
              // 如果有商品列表，也更新商品列表
              if (res.data.items && res.data.items.length > 0) {
                this.currentOrder.items = res.data.items;
              } else {
                // 如果后端没有返回items，但order中有items，保持不变
              }
            }
          }
        })
        .catch(() => {
          console.error("加载订单详情失败");
        });
    },
    handleShip(row) {
      this.currentOrder = { ...row };
      this.shipForm = {
        expressCompany: "",
        expressNo: "",
        remark: "",
      };
      this.shipDialogVisible = true;
    },
    handleShipItem(item) {
      this.currentOrder = { ...this.currentOrder, id: item.orderId };
      this.shipForm = {
        orderItemId: item.id,
        expressCompany: "",
        expressNo: "",
        remark: "",
      };
      this.shipDialogVisible = true;
    },
    handleRefundItem(item) {
      const order = this.currentOrder;
      this.handleRefund(order);
    },
    confirmShip() {
      if (!this.shipForm.expressCompany) {
        this.$message.warning("请选择物流公司");
        return;
      }

      if (!this.shipForm.expressNo) {
        this.$message.warning("请输入物流单号");
        return;
      }

      const expressNoRegex = /^[A-Za-z0-9]{6,20}$/;
      if (!expressNoRegex.test(this.shipForm.expressNo)) {
        this.$message.warning("物流单号必须为6-20位字母或数字");
        return;
      }

      const orderId = this.currentOrder.id;
      const merchantId = localStorage.getItem("merchantId");

      if (orderId) {
        // 如果有强制发货的商品，进行批量强制发货
        if (this.forceShipItemIds && this.forceShipItemIds.length > 0) {
          // 逐个强制发货，传递原有的物流信息
          let promises = this.forceShipItemIds.map((itemId) => {
            // 找到对应的商品，获取原有的物流信息
            const item = this.currentOrder.items.find((i) => i.id === itemId);
            const params = {
              orderId: orderId,
              orderItemId: itemId,
            };
            // 如果商品已有物流信息，传递原有信息
            if (item && item.expressCompany) {
              params.expressCompany = item.expressCompany;
            }
            if (item && item.expressNo) {
              params.expressNo = item.expressNo;
            }
            if (this.shipForm.remark) {
              params.remark = this.shipForm.remark;
            }
            return this.$http.post("/order/force-ship-item", params);
          });

          Promise.all(promises)
            .then((results) => {
              const success = results.every((res) => res.code === 200);
              if (success) {
                this.$message.success("批量强制发货成功");
                this.loadOrders();
                this.shipDialogVisible = false;
                this.forceShipItemIds = [];
              } else {
                this.$message.error("部分商品强制发货失败");
                this.loadOrders();
                this.shipDialogVisible = false;
                this.forceShipItemIds = [];
              }
            })
            .catch(() => {
              this.$message.error("强制发货失败");
              this.forceShipItemIds = [];
            });
          return;
        }

        // 正常发货流程
        const shipParams = {
          id: orderId,
          merchantId: merchantId ? parseInt(merchantId) : null,
          expressCompany: this.shipForm.expressCompany,
          expressNo: this.shipForm.expressNo,
          remark: this.shipForm.remark,
        };

        if (this.shipForm.orderItemId) {
          shipParams.orderItemId = this.shipForm.orderItemId;
        }

        // 调用后端API发货
        this.$http
          .put("/order/ship", shipParams)
          .then((res) => {
            if (res.code === 200) {
              // 更新本地商品状态和物流信息为"待收货"
              if (this.currentOrder.items) {
                const merchantId = localStorage.getItem("merchantId");
                this.currentOrder.items.forEach((item) => {
                  if (this.shipForm.orderItemId) {
                    if (item.id === this.shipForm.orderItemId) {
                      item.status = "待收货";
                      item.expressCompany = this.shipForm.expressCompany;
                      item.expressNo = this.shipForm.expressNo;
                    }
                  } else if (
                    item.status === "待发货" &&
                    item.merchantId == merchantId
                  ) {
                    item.status = "待收货";
                    item.expressCompany = this.shipForm.expressCompany;
                    item.expressNo = this.shipForm.expressNo;
                  }
                });
              }
              // 更新订单列表中对应商品的状态和物流信息
              const orderInList = this.orderList.find((o) => o.id === orderId);
              if (orderInList && orderInList.items) {
                const merchantId = localStorage.getItem("merchantId");
                orderInList.items.forEach((item) => {
                  if (this.shipForm.orderItemId) {
                    if (item.id === this.shipForm.orderItemId) {
                      item.status = "待收货";
                      item.expressCompany = this.shipForm.expressCompany;
                      item.expressNo = this.shipForm.expressNo;
                    }
                  } else if (
                    item.status === "待发货" &&
                    item.merchantId == merchantId
                  ) {
                    item.status = "待收货";
                    item.expressCompany = this.shipForm.expressCompany;
                    item.expressNo = this.shipForm.expressNo;
                  }
                });
                // 检查是否还有待发货的商品
                const hasPendingItems = orderInList.items.some(
                  (item) => item.status === "待发货"
                );
                if (!hasPendingItems) {
                  orderInList.orderStatus = "待收货";
                }
              }
              // 更新统计数据
              this.orderStats.ship -= 1;
              // 触发自定义事件，通知其他组件（如首页统计）更新
              window.dispatchEvent(new Event("order-status-updated"));
              this.$message.success("发货成功");
              this.shipDialogVisible = false;
              // 刷新订单列表
              this.loadOrders();
            } else {
              this.$message.error(res.message || "发货失败");
            }
          })
          .catch(() => {
            this.$message.error("发货失败，请稍后重试");
          });
      }
    },
    formatDate(dateTime) {
      if (!dateTime) return "-";
      const date = new Date(dateTime);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      const hours = String(date.getHours()).padStart(2, "0");
      const minutes = String(date.getMinutes()).padStart(2, "0");
      const seconds = String(date.getSeconds()).padStart(2, "0");
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    },
    getReasonText(reason) {
      const reasons = {
        1: "商品损坏",
        2: "商品错发",
        3: "不想买了",
        4: "其他",
      };
      return reasons[reason] || reason || "其他";
    },
    handleRefund(order) {
      const merchantId = localStorage.getItem("merchantId");
      if (!merchantId) {
        this.$message.error("无法获取商家信息");
        return;
      }

      this.refundForm = {
        orderId: order.id,
        refundId: null,
        orderNumber: order.orderNumber,
        refundAmount: 0,
        refundReason: "",
        refundDescription: "",
        merchantReply: "",
        refundStatus: "",
        itemName: "",
        itemPrice: 0,
        itemQuantity: 0,
        itemCoverImage: "",
        refundItems: [],
      };

      // 查找该订单中退款状态为"待处理"的商品（仅当前商家的）
      const refundItems = order.items
        ? order.items.filter(
            (item) =>
              item.refundStatus === "待处理" && item.merchantId == merchantId
          )
        : [];

      if (refundItems.length > 0) {
        // 存储所有待处理的退款商品基本信息
        this.refundForm.refundItems = refundItems.map((item) => ({
          orderItemId: item.id,
          bookName: item.bookName || item.itemName || "",
          price: item.price || 0,
          quantity: item.quantity || 1,
          subtotal: item.subtotal,
          coverImage: item.coverImage || item.bookCover || "",
          refundReason: item.refundReason || "",
          refundDescription: item.refundDescription || "",
          refundId: null,
          selected: true,
        }));

        // 批量获取每个商品的退款申请ID
        this.batchQueryRefundRequests(order.id, refundItems);
      } else {
        this.$message.error("未找到该订单的退款申请");
      }
    },
    batchQueryRefundRequests(orderId, refundItems) {
      // 批量查询退款申请ID
      const promises = refundItems.map((item) =>
        axios.get("/refund/pending/" + item.id)
      );

      Promise.all(promises)
        .then((results) => {
          results.forEach((res, index) => {
            if (res.code === 200 && res.data) {
              this.refundForm.refundItems[index].refundId = res.data.id;
            }
          });

          // 获取第一个商品的信息用于表单初始化
          const firstItem = refundItems[0];
          this.refundForm.refundAmount = firstItem.subtotal;
          this.refundForm.refundReason = firstItem.refundReason || "";
          this.refundForm.refundDescription = firstItem.refundDescription || "";
          this.refundForm.refundItemId = firstItem.id;
          this.refundForm.itemName =
            firstItem.bookName || firstItem.itemName || "";
          this.refundForm.itemPrice = firstItem.price || 0;
          this.refundForm.itemQuantity = firstItem.quantity || 1;
          this.refundForm.itemCoverImage =
            firstItem.coverImage || firstItem.bookCover || "";

          // 获取第一个商品的退款详情
          this.queryRefundRequestByOrderItem(orderId, firstItem.id);
        })
        .catch(() => {
          this.$message.error("查询退款申请失败");
          this.refundDialogVisible = false;
        });
    },
    queryRefundRequestByOrderItem(orderId, orderItemId) {
      axios
        .get("/refund/pending/" + orderItemId)
        .then((res) => {
          if (res.code === 200 && res.data) {
            this.refundForm.refundId = res.data.id;
            this.refundForm.refundReason =
              res.data.refundReason || this.refundForm.refundReason;
            this.refundForm.refundDescription =
              res.data.refundDescription || this.refundForm.refundDescription;
            this.refundForm.refundAmount =
              res.data.refundAmount || this.refundForm.refundAmount;
            this.refundForm.merchantReply =
              res.data.merchantReply || this.refundForm.merchantReply;
            this.refundForm.refundStatus = res.data.refundStatus || "";

            // 更新 refundItems 中的 refundId
            if (
              this.refundForm.refundItems &&
              this.refundForm.refundItems.length > 0
            ) {
              const itemIndex = this.refundForm.refundItems.findIndex(
                (item) => item.orderItemId === orderItemId
              );
              if (itemIndex !== -1) {
                this.refundForm.refundItems[itemIndex].refundId = res.data.id;
              }
            }

            this.refundDialogVisible = true;
          } else {
            // 如果没有待处理的退款申请，提示商家
            this.$message.warning("该订单没有待处理的退款申请");
            this.refundDialogVisible = false;
          }
        })
        .catch(() => {
          this.$message.error("查询退款申请失败");
          this.refundDialogVisible = false;
        });
    },
    handleForceShip(order) {
      // 获取商家ID
      const merchantId = localStorage.getItem("merchantId");

      // 获取该订单中所有退款中的商品（只获取当前商家的商品）
      const refundingItems = (order.items || []).filter(
        (item) => item.status === "退款中" && item.merchantId == merchantId
      );

      if (refundingItems.length === 0) {
        this.$message.warning("没有需要强制发货的商品");
        return;
      }

      // 检查所有退款中的商品是否都有物流信息
      const allHaveExpressInfo = refundingItems.every(
        (item) => item.expressCompany && item.expressNo
      );

      if (allHaveExpressInfo) {
        // 所有商品都有物流信息，直接强制发货
        this.handleForceShipWithExistingInfo(order, refundingItems);
      } else {
        // 有些商品没有物流信息，需要打开发货对话框
        this.handleForceShipNeedExpress(order, refundingItems);
      }
    },

    handleForceShipWithExistingInfo(order, refundingItems) {
      // 构建商品列表HTML
      const itemsHtml = refundingItems
        .map(
          (item, index) =>
            `<div style="text-align: left; padding: 5px 0;">
              <span style="color: #409EFF; font-weight: bold;">${
                index + 1
              }.</span>
              <span style="margin-left: 8px;">${item.bookName}</span>
              <span style="color: #67C23A; font-size: 12px; margin-left: 10px;">
                ${item.expressCompany} ${item.expressNo}
              </span>
            </div>`
        )
        .join("");

      // 构建完整消息HTML
      const messageHtml = `
        <div style="text-align: left; line-height: 1.8;">
          <p style="margin-bottom: 15px; font-size: 14px;">
            以下商品已有物流信息，是否直接强制发货？
          </p>
          <div style="
            background: #f5f7fa;
            border-radius: 4px;
            padding: 12px;
            margin-bottom: 15px;
            max-height: 200px;
            overflow-y: auto;
          ">
            ${itemsHtml}
          </div>
          <p style="
            color: #909399;
            font-size: 12px;
            border-top: 1px dashed #dcdfe6;
            padding-top: 10px;
            margin-top: 10px;
          ">
            <i class="el-icon-info-outline" style="color: #409EFF;"></i>
            将使用原有的物流信息直接发货
          </p>
        </div>
      `;

      this.$confirm(messageHtml, "批量强制发货", {
        confirmButtonText: "确定发货",
        cancelButtonText: "取消",
        type: "warning",
        dangerouslyUseHTMLString: true,
        customClass: "force-ship-confirm-dialog",
      })
        .then(() => {
          // 设置当前订单和强制发货列表
          this.currentOrder = { ...order };
          this.forceShipItemIds = refundingItems.map((item) => item.id);

          // 直接调用批量强制发货
          this.confirmForceShip();
        })
        .catch(() => {});
    },

    handleForceShipNeedExpress(order, refundingItems) {
      // 构建商品列表HTML
      const itemsHtml = refundingItems
        .map((item, index) => {
          const hasExpress = item.expressCompany && item.expressNo;
          return `<div style="text-align: left; padding: 5px 0;">
              <span style="color: #409EFF; font-weight: bold;">${
                index + 1
              }.</span>
              <span style="margin-left: 8px;">${item.bookName}</span>
              ${
                hasExpress
                  ? `<span style="color: #67C23A; font-size: 12px; margin-left: 10px;">
                      ${item.expressCompany} ${item.expressNo}
                    </span>`
                  : `<span style="color: #E6A23C; font-size: 12px; margin-left: 10px;">
                      需填写物流信息
                    </span>`
              }
            </div>`;
        })
        .join("");

      // 构建完整消息HTML
      const messageHtml = `
        <div style="text-align: left; line-height: 1.8;">
          <p style="margin-bottom: 15px; font-size: 14px;">
            以下商品处于退款中，需要填写物流信息才能发货：
          </p>
          <div style="
            background: #f5f7fa;
            border-radius: 4px;
            padding: 12px;
            margin-bottom: 15px;
            max-height: 200px;
            overflow-y: auto;
          ">
            ${itemsHtml}
          </div>
          <p style="
            color: #909399;
            font-size: 12px;
            border-top: 1px dashed #dcdfe6;
            padding-top: 10px;
            margin-top: 10px;
          ">
            <i class="el-icon-warning-outline" style="color: #E6A23C;"></i>
            请填写物流信息完成发货，已有物流信息的商品将保留原有信息
          </p>
        </div>
      `;

      this.$confirm(messageHtml, "批量强制发货", {
        confirmButtonText: "去填写物流信息",
        cancelButtonText: "取消",
        type: "warning",
        dangerouslyUseHTMLString: true,
        customClass: "force-ship-confirm-dialog",
      })
        .then(() => {
          // 设置当前订单和强制发货列表
          this.currentOrder = { ...order };
          this.forceShipItemIds = refundingItems.map((item) => item.id);

          // 重置发货表单（但不覆盖原有物流信息，会在后续处理中保留）
          this.shipForm = {
            expressCompany: "",
            expressNo: "",
            remark: "",
          };

          // 显示发货对话框
          this.shipDialogVisible = true;
        })
        .catch(() => {});
    },

    confirmForceShip() {
      // 批量强制发货，逐个处理
      const orderId = this.currentOrder.id;
      const promises = this.forceShipItemIds.map((itemId) => {
        // 找到对应的商品，获取原有的物流信息
        const item = this.currentOrder.items.find((i) => i.id === itemId);
        const params = {
          orderId: orderId,
          orderItemId: itemId,
        };

        // 传递原有的物流信息
        if (item && item.expressCompany) {
          params.expressCompany = item.expressCompany;
        }
        if (item && item.expressNo) {
          params.expressNo = item.expressNo;
        }

        return this.$http.post("/order/force-ship-item", params);
      });

      Promise.all(promises)
        .then((results) => {
          const allSuccess = results.every((res) => res.code === 200);
          if (allSuccess) {
            this.$message.success("批量强制发货成功");
          } else {
            this.$message.error("部分商品强制发货失败");
          }

          // 关闭发货对话框
          this.shipDialogVisible = false;
          this.forceShipItemIds = [];

          // 重新加载订单列表
          this.loadOrders();

          // 重新打开订单详情
          const orderData = this.orderList.find(
            (o) => o.id === this.currentOrder.id
          );
          if (orderData) {
            this.viewDetail(orderData);
          }
        })
        .catch(() => {
          this.$message.error("强制发货失败");
          this.shipDialogVisible = false;
          this.forceShipItemIds = [];
        });
    },
    handleForceShipItem(item) {
      this.$confirm(
        "确定要强制发货吗？此操作将取消退款申请并直接发货。",
        "强制发货",
        {
          confirmButtonText: "确定发货",
          cancelButtonText: "取消",
          type: "warning",
        }
      )
        .then(() => {
          const params = {
            orderId: this.currentOrder.id,
            orderItemId: item.id,
          };
          // 如果商品已有物流信息，自动传递（用于之前已发货后申请退款的情况）
          if (item.expressCompany) {
            params.expressCompany = item.expressCompany;
          }
          if (item.expressNo) {
            params.expressNo = item.expressNo;
          }

          this.$http
            .post("/order/force-ship-item", params)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("强制发货成功");
                // 关闭发货对话框
                this.shipDialogVisible = false;
                // 关闭订单详情对话框
                this.detailDialogVisible = false;
                // 重新加载订单列表
                this.loadOrders();
                // 重新打开订单详情
                const orderData = this.orderList.find(
                  (o) => o.id === this.currentOrder.id
                );
                if (orderData) {
                  this.viewDetail(orderData);
                }
              } else {
                this.$message.error(res.message || "强制发货失败");
              }
            })
            .catch(() => {
              this.$message.error("强制发货失败");
            });
        })
        .catch(() => {});
    },
    processRefund(status) {
      // 只有拒绝退款时才需要填写原因
      if (status === "rejected" && !this.refundForm.merchantReply) {
        this.$message.error("请填写拒绝退款的原因");
        return;
      }

      if (
        !this.refundForm.refundItems ||
        this.refundForm.refundItems.length === 0
      ) {
        this.$message.error("没有可处理的退款申请");
        return;
      }

      // 只收集选中的退款申请ID
      const selectedItems = this.refundForm.refundItems.filter(
        (item) => item.selected
      );

      if (selectedItems.length === 0) {
        this.$message.error("请至少选择一个商品");
        return;
      }

      const refundIds = selectedItems.map((item) => item.refundId);

      if (refundIds.length === 0) {
        this.$message.error("无法获取退款申请信息");
        return;
      }

      // 批量处理退款
      let promises = refundIds.map((refundId) => {
        return this.$http.post("/refund/process", {
          refundId: refundId,
          status: status,
          merchantReply: this.refundForm.merchantReply || "",
        });
      });

      Promise.all(promises)
        .then((results) => {
          const success = results.every((res) => res.code === 200);
          if (success) {
            this.$message.success(
              status === "approved"
                ? `已同意 ${refundIds.length} 个退款申请`
                : `已拒绝 ${refundIds.length} 个退款申请`
            );
            this.refundDialogVisible = false;
            this.loadOrders();
          } else {
            this.$message.error("部分退款处理失败");
            this.loadOrders();
          }
        })
        .catch(() => {
          this.$message.error("退款处理失败");
        });
    },
    selectAllItems() {
      if (this.refundForm.refundItems) {
        this.refundForm.refundItems.forEach((item) => {
          this.$set(item, "selected", true);
        });
      }
    },
    deselectAllItems() {
      if (this.refundForm.refundItems) {
        this.refundForm.refundItems.forEach((item) => {
          this.$set(item, "selected", false);
        });
      }
    },
    updateSelectedCount() {
      this.$forceUpdate();
    },
  },
};
</script>

<style scoped>
.order-list {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
  min-height: calc(100vh - 60px);
}

.header-card {
  margin-bottom: 20px;
  border: none;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.header-card ::v-deep .el-card__body {
  padding: 20px 25px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
}

.header-left {
  flex: 1;
  min-width: 200px;
}

.header-title {
  margin: 0 0 5px 0;
  font-size: 24px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-subtitle {
  margin: 0;
  font-size: 14px;
  opacity: 0.9;
}

.header-stats {
  display: flex;
  gap: 20px;
  align-items: center;
  flex-wrap: nowrap;
}

.stat-item {
  text-align: center;
  min-width: 140px;
  padding: 10px 20px;
  background: rgba(255, 255, 255, 0.15);
  border-radius: 8px;
  transition: all 0.3s;
}

.stat-item:hover {
  background: rgba(255, 255, 255, 0.25);
  transform: scale(1.02);
}

.stat-value {
  display: block;
  font-size: 40px;
  font-weight: bold;
  margin-bottom: 10px;
  line-height: 1.2;
}

.stat-label {
  display: block;
  font-size: 15px;
  opacity: 0.95;
  font-weight: 500;
}

.stat-divider {
  width: 3px;
  height: 70px;
  background: rgba(255, 255, 255, 0.5);
  border-radius: 2px;
}

.search-card {
  margin-bottom: 20px;
  border: none;
  border-radius: 12px;
}

.search-form {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  align-items: flex-end;
}

.search-item {
  margin-bottom: 0;
}

.search-actions {
  margin-bottom: 0;
}

.table-card {
  border: none;
  border-radius: 12px;
}

.order-detail {
  padding: 10px;
}

.order-number-cell {
  display: flex;
  align-items: center;
  gap: 8px;
}

.remind-icon {
  color: #f56c6c;
  font-size: 16px;
  cursor: pointer;
  transition: transform 0.3s;
}

.remind-icon:hover {
  transform: scale(1.2);
}

.detail-remind-icon {
  color: #f56c6c;
  font-size: 18px;
  margin-left: 8px;
  cursor: pointer;
  transition: transform 0.3s;
}

.detail-remind-icon:hover {
  transform: scale(1.2);
}

.order-list {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
  min-height: calc(100vh - 60px);
}

.header-card {
  margin-bottom: 20px;
  border: none;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.header-card ::v-deep .el-card__body {
  padding: 20px 25px;
}

.detail-dialog ::v-deep .el-dialog__header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 15px 20px;
  margin-right: 0;
}

.detail-dialog ::v-deep .el-dialog__title {
  color: white;
  font-weight: 600;
}

.detail-dialog ::v-deep .el-dialog__headerbtn .el-dialog__close {
  color: white;
}

.detail-dialog ::v-deep .el-dialog__body {
  padding: 25px;
}

.order-detail {
  padding: 10px;
}

.detail-header {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 15px;
}

.order-number-display {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 16px;
}

.order-number {
  font-weight: 600;
  color: #303133;
}

.detail-section {
  margin: 20px 0;
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: #606266;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-title i {
  color: #409eff;
}

.order-items {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 15px;
}

.order-item-card {
  background: white;
  border-radius: 6px;
  padding: 12px;
  margin-bottom: 10px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  display: flex;
  gap: 15px;
  align-items: flex-start;
}

.order-item-card:last-child {
  margin-bottom: 0;
}

.item-image {
  flex-shrink: 0;
}

.item-details {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  min-height: 80px;
}

.item-info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.item-name {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  flex: 1;
}

.item-price {
  font-size: 14px;
  color: #409eff;
  font-weight: 600;
}

.item-quantity-row {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 13px;
  color: #909399;
  margin-top: 8px;
}

.item-express-row {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  color: #409eff;
  margin-top: 8px;
  background: #ecf5ff;
  padding: 6px 10px;
  border-radius: 4px;
}

.item-express-row i {
  font-weight: bold;
}

.express-label {
  font-weight: 500;
}

.express-no {
  font-family: "Courier New", monospace;
  font-weight: 600;
  letter-spacing: 1px;
}

.item-status-row {
  margin-top: 8px;
}

.item-action-row {
  margin-top: 8px;
  display: flex;
  gap: 8px;
}

.quantity-label {
  color: #909399;
}

.quantity-value {
  color: #606266;
  font-weight: 500;
}

.subtotal {
  color: #f56c6c;
  font-weight: 600;
  margin-left: auto;
}

.no-items {
  text-align: center;
  color: #909399;
  padding: 20px;
}

.detail-content {
  padding: 0 10px;
}

.detail-row {
  margin-bottom: 15px;
  display: flex;
  align-items: flex-start;
}

.detail-row.highlight {
  background: #f5f7fa;
  padding: 12px;
  border-radius: 6px;
  margin-left: -10px;
  margin-right: -10px;
}

.detail-label {
  font-size: 13px;
  color: #909399;
  min-width: 80px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.detail-label i {
  color: #409eff;
}

.detail-value {
  font-size: 13px;
  color: #606266;
}

.detail-value.address-value {
  flex: 1;
  line-height: 1.6;
}

.total-amount {
  font-size: 20px;
  font-weight: 700;
  color: #f56c6c;
}

.refund-amount {
  font-size: 24px;
  font-weight: 700;
  color: #f56c6c;
}

.refund-hint {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
  line-height: 1.5;
  padding: 8px 10px;
  background: #f5f7fa;
  border-radius: 4px;
  border-left: 3px solid #409eff;
}

.refund-hint i {
  color: #409eff;
  margin-right: 5px;
}

.refund-label {
  font-weight: 600;
  color: #606266;
}

.refund-value {
  color: #303133;
}

.refund-reply {
  margin-top: 10px;
  padding: 10px;
  background: #f5f7fa;
  border-radius: 6px;
  border-left: 3px solid #67c23a;
}

.ship-dialog ::v-deep .el-dialog__header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 15px 20px;
  margin-right: 0;
}

.ship-dialog ::v-deep .el-dialog__title {
  color: white;
  font-weight: 600;
}

.ship-dialog ::v-deep .el-dialog__headerbtn .el-dialog__close {
  color: white;
}

.refund-detail-dialog ::v-deep .el-dialog__header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 15px 20px;
  margin-right: 0;
}

.refund-detail-dialog ::v-deep .el-dialog__title {
  color: white;
  font-weight: 600;
}

.refund-detail-dialog ::v-deep .el-dialog__headerbtn .el-dialog__close {
  color: white;
}

.refund-detail-content {
  padding: 10px 0;
}

.item-info-card {
  margin-bottom: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
}

.item-header {
  display: flex;
  gap: 15px;
  align-items: flex-start;
}

.item-image-wrapper {
  flex-shrink: 0;
}

.item-image {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid #e4e7ed;
}

.item-image.no-image {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
  color: #909399;
  font-size: 12px;
  width: 80px;
  height: 80px;
  border-radius: 6px;
}

.item-detail {
  flex: 1;
}

.item-detail h4 {
  margin: 0 0 8px 0;
  font-size: 16px;
  color: #303133;
}

.item-meta {
  margin: 0;
  color: #606266;
  font-size: 13px;
  display: flex;
  gap: 15px;
}

.refund-amount-text {
  font-size: 18px;
  color: #f56c6c;
  font-weight: bold;
}

.ship-dialog ::v-deep .el-dialog__body {
  padding: 20px;
}

.ship-form-wrapper {
  padding: 10px;
}

.ship-header {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 15px;
}

.ship-order-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.info-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.info-label {
  font-size: 13px;
  color: #909399;
  display: flex;
  align-items: center;
  gap: 5px;
}

.info-label i {
  color: #409eff;
}

.info-value {
  font-size: 13px;
  color: #303133;
  font-weight: 500;
}

.ship-form {
  margin-top: 20px;
}

.form-section {
  margin-bottom: 25px;
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: #606266;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-title i {
  color: #409eff;
}

.ship-items-section {
  margin-bottom: 20px;
}

.item-book-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.item-book-info .item-author {
  font-size: 12px;
  color: #909399;
}

.item-subtotal {
  color: #f56c6c;
  font-weight: 600;
}

.items-hint {
  font-size: 12px;
  color: #909399;
  padding: 8px 10px;
  background: #f5f7fa;
  border-radius: 4px;
  display: flex;
  align-items: center;
  gap: 5px;
  margin-top: 10px;
}

.items-hint i {
  color: #409eff;
}

.required-field ::v-deep .el-form-item__label::before {
  content: "*";
  color: #f56c6c;
  margin-right: 4px;
  font-size: 14px;
  font-weight: bold;
}

.ship-form ::v-deep .el-form-item {
  margin-bottom: 18px;
}

.ship-form ::v-deep .el-form-item__label {
  font-weight: 600;
  color: #606266;
  padding-bottom: 8px;
  line-height: 1.5;
}

.ship-form ::v-deep .el-input__prefix {
  color: #409eff;
}

.optional-hint {
  font-size: 12px;
  color: #909399;
  margin-top: 8px;
  line-height: 1.5;
  padding: 8px 10px;
  background: #f5f7fa;
  border-radius: 4px;
  border-left: 3px solid #909399;
}

.optional-hint i {
  color: #909399;
  margin-right: 5px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 15px 20px;
  background: #f5f7fa;
  border-top: 1px solid #ebeef5;
  margin: 0 -20px -20px -20px;
}

.confirm-btn {
  padding: 10px 25px;
  font-weight: 600;
}

@media (max-width: 768px) {
  .order-items {
    padding: 10px;
  }

  .item-info-row {
    flex-direction: column;
    align-items: flex-start;
  }

  .item-price {
    margin-top: 5px;
  }

  .ship-dialog ::v-deep .el-dialog {
    width: 90% !important;
  }

  .dialog-footer {
    flex-direction: column;
  }

  .dialog-footer .el-button {
    width: 100%;
  }
}

.refund-items-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-bottom: 20px;
}

.refund-item-card {
  border: 1px solid #ebeef5;
  border-radius: 8px;
  transition: all 0.3s;
}

.refund-item-card:hover {
  border-color: #409eff;
  box-shadow: 0 2px 12px 0 rgba(64, 158, 255, 0.1);
}

.refund-item-content {
  display: flex;
  gap: 15px;
}

.refund-item-image {
  flex-shrink: 0;
}

.refund-item-image img {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid #e4e7ed;
}

.refund-item-image .no-image {
  width: 80px;
  height: 80px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
  color: #909399;
  font-size: 12px;
  border-radius: 6px;
}

.refund-item-info {
  flex: 1;
}

.refund-item-info .item-name {
  margin: 0 0 8px 0;
  font-size: 15px;
  font-weight: 600;
  color: #303133;
}

.refund-item-info .item-meta {
  margin: 0 0 8px 0;
  font-size: 13px;
  color: #606266;
  display: flex;
  gap: 15px;
}

.refund-reason-text {
  margin: 0 0 8px 0;
  font-size: 13px;
  color: #e6a23c;
  padding: 8px 10px;
  background: #fdf6ec;
  border-radius: 4px;
  border-left: 3px solid #e6a23c;
}

.refund-reason-text i {
  margin-right: 5px;
}

.refund-amount {
  margin: 0;
  font-size: 14px;
  color: #606266;
}

.refund-amount .amount {
  font-size: 18px;
  font-weight: bold;
  color: #f56c6c;
}

.refund-checkbox {
  display: flex;
  align-items: flex-start;
  padding-top: 30px;
}

.selection-toolbar {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 15px;
  background: #f5f7fa;
  border-radius: 6px;
  margin-bottom: 15px;
}

.selected-count {
  margin-left: auto;
  color: #606266;
  font-size: 13px;
}

.refund-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 0;
  border-top: 1px solid #ebeef5;
}

.selected-info {
  color: #606266;
  font-size: 14px;
}

.selected-info .highlight {
  color: #409eff;
  font-weight: bold;
  font-size: 18px;
}

.footer-buttons {
  display: flex;
  gap: 10px;
}

.refund-item-card.selected {
  border-color: #409eff;
  background: linear-gradient(135deg, #f0f9ff 0%, #e8f4fd 100%);
}

.refund-amount-text {
  font-size: 20px;
  font-weight: bold;
  color: #f56c6c;
}
</style>
