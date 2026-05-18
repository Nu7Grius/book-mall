<template>
  <div class="order-detail">
    <el-card v-if="order">
      <div slot="header" class="clearfix">
        <span>订单详情</span>
        <el-button
          style="float: right"
          size="small"
          @click="$router.push('/home/my-orders').catch(() => {})"
          >返回</el-button
        >
      </div>

      <div class="detail-content">
        <el-steps
          :active="getStepActive(order.orderStatus)"
          finish-status="success"
          class="order-steps"
        >
          <el-step
            title="提交订单"
            :description="formatTime(order.createTime)"
          ></el-step>
          <el-step
            title="支付订单"
            :description="formatTime(order.paymentTime) || '待支付'"
          ></el-step>
          <el-step
            title="商家发货"
            :description="formatTime(order.shippingTime) || '待发货'"
          ></el-step>
          <el-step
            title="确认收货"
            :description="formatTime(order.completionTime) || '待收货'"
          ></el-step>
        </el-steps>

        <el-descriptions :column="2" border>
          <el-descriptions-item label="订单编号">{{
            order.orderNumber
          }}</el-descriptions-item>
          <el-descriptions-item label="订单状态">
            <el-tag
              v-if="order.orderStatus === '待付款'"
              type="warning"
              size="small"
              ><i class="el-icon-time"></i> 待付款</el-tag
            >
            <el-tag
              v-else-if="order.orderStatus === '待发货'"
              type="primary"
              size="small"
              ><i class="el-icon-box"></i> 待发货</el-tag
            >
            <el-tag
              v-else-if="order.orderStatus === '待收货'"
              type="success"
              size="small"
              ><i class="el-icon-truck"></i> 待收货</el-tag
            >
            <el-tag
              v-else-if="order.orderStatus === '待评价'"
              type="warning"
              size="small"
              ><i class="el-icon-edit"></i> 待评价</el-tag
            >
            <el-tag
              v-else-if="order.orderStatus === '退款中'"
              type="warning"
              size="small"
              ><i class="el-icon-warning-outline"></i> 退款中</el-tag
            >
            <el-tag
              v-else-if="order.orderStatus === '已完成'"
              type="success"
              size="small"
              ><i class="el-icon-circle-check"></i> 已完成</el-tag
            >
            <el-tag
              v-else-if="order.orderStatus === '已取消'"
              type="danger"
              size="small"
              ><i class="el-icon-circle-close"></i> 已取消</el-tag
            >
            <el-tag
              v-else-if="order.orderStatus === '已退款'"
              type="danger"
              size="small"
              ><i class="el-icon-circle-close"></i> 已退款</el-tag
            >
            <el-tag v-else type="info" size="small">{{
              order.orderStatus
            }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="下单时间">{{
            order.createTime
          }}</el-descriptions-item>
          <el-descriptions-item label="支付时间">{{
            order.paymentTime || "未支付"
          }}</el-descriptions-item>
          <el-descriptions-item label="收货地址" :span="2">
            {{ order.address || "暂无地址信息" }}
          </el-descriptions-item>
          <el-descriptions-item label="收货人">{{
            order.receiverName || "未知"
          }}</el-descriptions-item>
          <el-descriptions-item label="联系电话">{{
            order.receiverPhone || "未知"
          }}</el-descriptions-item>
        </el-descriptions>

        <div class="book-list">
          <h3>商品清单</h3>
          <el-table :data="orderItems" border>
            <el-table-column prop="bookName" label="书名" min-width="250">
              <template slot-scope="scope">
                <div
                  class="book-info"
                  @click="goToBookDetail(scope.row.bookId)"
                >
                  <img
                    v-if="scope.row.coverImage"
                    :src="getImageUrl(scope.row.coverImage)"
                    class="book-cover"
                  />
                  <div v-else class="book-cover no-image">无图</div>
                  <div class="book-detail">
                    <span class="book-name">{{ scope.row.bookName }}</span>
                    <span class="merchant-info" v-if="scope.row.merchantName">
                      <i class="el-icon-shopping-bag-1"></i>
                      {{ scope.row.merchantName }}
                      <span
                        v-if="scope.row.merchantPhone"
                        class="merchant-phone"
                      >
                        {{ scope.row.merchantPhone }}
                      </span>
                    </span>
                  </div>
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="author" label="作者" width="120">
            </el-table-column>
            <el-table-column prop="price" label="单价" width="100">
              <template slot-scope="scope">
                ¥{{ scope.row.price.toFixed(2) }}
              </template>
            </el-table-column>
            <el-table-column prop="quantity" label="数量" width="80">
            </el-table-column>
            <el-table-column label="小计" width="120">
              <template slot-scope="scope">
                <span class="subtotal">
                  {{
                    formatPrice(
                      scope.row.subtotal || scope.row.price * scope.row.quantity
                    )
                  }}
                </span>
              </template>
            </el-table-column>
            <el-table-column label="状态" width="100">
              <template slot-scope="scope">
                <div class="status-cell">
                  <el-tooltip
                    :disabled="
                      !scope.row.expressNo ||
                      !['待收货', '待评价', '已完成'].includes(
                        getDisplayStatus(scope.row)
                      )
                    "
                    effect="dark"
                    :content="
                      scope.row.expressCompany + '：' + scope.row.expressNo
                    "
                    placement="top"
                    :open-delay="300"
                  >
                    <el-tag
                      v-if="getDisplayStatus(scope.row) === '待收货'"
                      type="success"
                      size="small"
                      class="express-tag"
                    >
                      <i class="el-icon-truck"></i> 待收货
                    </el-tag>
                    <el-tag
                      v-else-if="getDisplayStatus(scope.row) === '待评价'"
                      type="warning"
                      size="small"
                      class="express-tag"
                    >
                      <i class="el-icon-edit"></i> 待评价
                    </el-tag>
                    <el-tag
                      v-else-if="getDisplayStatus(scope.row) === '已完成'"
                      type="success"
                      size="small"
                      class="express-tag"
                    >
                      <i class="el-icon-circle-check"></i> 已完成
                    </el-tag>
                  </el-tooltip>
                  <el-tag
                    v-if="
                      scope.row.status === '待收货' &&
                      !(scope.row.expressCompany && scope.row.expressNo)
                    "
                    type="success"
                    size="small"
                  >
                    <i class="el-icon-truck"></i> 待收货
                  </el-tag>
                  <el-tag
                    v-if="scope.row.status === '待付款'"
                    type="warning"
                    size="small"
                  >
                    <i class="el-icon-time"></i> 待付款
                  </el-tag>
                  <el-tag
                    v-if="scope.row.status === '待发货'"
                    type="primary"
                    size="small"
                  >
                    <i class="el-icon-box"></i> 待发货
                  </el-tag>
                  <el-tag
                    v-if="
                      getDisplayStatus(scope.row) === '待评价' &&
                      !(scope.row.expressCompany && scope.row.expressNo)
                    "
                    type="warning"
                    size="small"
                  >
                    <i class="el-icon-edit"></i> 待评价
                  </el-tag>
                  <el-tag
                    v-if="
                      scope.row.status === '已完成' &&
                      !(scope.row.expressCompany && scope.row.expressNo)
                    "
                    type="success"
                    size="small"
                  >
                    <i class="el-icon-circle-check"></i> 已完成
                  </el-tag>
                  <el-tag
                    v-if="scope.row.status === '退款中'"
                    type="warning"
                    size="small"
                  >
                    <i class="el-icon-warning-outline"></i> 退款中
                  </el-tag>
                  <el-tag
                    v-if="scope.row.status === '已退款'"
                    type="danger"
                    size="small"
                  >
                    <i class="el-icon-circle-close"></i> 已退款
                  </el-tag>
                  <el-tag
                    v-if="scope.row.status === '已取消'"
                    type="danger"
                    size="small"
                  >
                    <i class="el-icon-circle-close"></i> 已取消
                  </el-tag>
                  <el-tag v-if="!scope.row.status" type="info" size="small">
                    -
                  </el-tag>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="200">
              <template slot-scope="scope">
                <div class="action-buttons">
                  <el-tag
                    v-if="scope.row.status === '待付款'"
                    type="info"
                    size="small"
                  >
                    <i class="el-icon-info"></i> 待付款
                  </el-tag>
                  <el-button
                    v-if="scope.row.status === '待发货'"
                    type="primary"
                    size="mini"
                    @click="remindItemShip(scope.row.id)"
                  >
                    <i class="el-icon-bell"></i> 提醒发货
                  </el-button>
                  <el-button
                    v-if="scope.row.status === '待收货'"
                    type="success"
                    size="mini"
                    @click="confirmItemReceive(scope.row.id)"
                  >
                    确认收货
                  </el-button>
                  <el-button
                    v-if="canShowRefundButton(scope.row)"
                    type="warning"
                    size="mini"
                    @click="openRefundDialog(scope.row)"
                  >
                    <i class="el-icon-warning-outline"></i> 申请退款
                  </el-button>
                  <el-button
                    v-if="scope.row.status === '待评价' && !scope.row.commented"
                    type="primary"
                    size="mini"
                    plain
                    @click="goToComment(scope.row)"
                  >
                    <i class="el-icon-edit"></i> 去评价
                  </el-button>
                  <el-tag
                    v-if="scope.row.status === '已完成'"
                    type="info"
                    size="small"
                  >
                    <i class="el-icon-circle-check"></i> 已完成
                  </el-tag>
                  <el-tag
                    v-else-if="
                      scope.row.status === '待评价' && scope.row.commented
                    "
                    type="info"
                    size="small"
                  >
                    <i class="el-icon-info"></i> 已评价
                  </el-tag>
                  <el-button
                    v-if="
                      scope.row.status === '退款中' ||
                      scope.row.refundStatus === '待处理'
                    "
                    type="info"
                    size="mini"
                    @click="viewRefundDetail(scope.row)"
                  >
                    退款详情
                  </el-button>
                  <el-tag
                    v-if="scope.row.status === '已退款'"
                    type="info"
                    size="small"
                  >
                    <i class="el-icon-info"></i> 已退款
                  </el-tag>
                  <el-tag
                    v-if="scope.row.status === '已取消'"
                    type="info"
                    size="small"
                  >
                    <i class="el-icon-info"></i> 已取消
                  </el-tag>
                </div>
              </template>
            </el-table-column>
          </el-table>

          <div class="order-summary">
            <div class="summary-row">
              <span>商品总价：</span>
              <span>{{ formatPrice(itemsTotalAmount) }}</span>
            </div>
            <div class="summary-row">
              <span>运费：</span>
              <span>¥0.00</span>
            </div>
            <div class="summary-row total">
              <span>实付金额：</span>
              <span class="price">{{ formatPrice(order.totalAmount) }}</span>
            </div>
          </div>
        </div>

        <div class="order-actions">
          <el-button
            v-if="order.orderStatus === '待付款'"
            type="primary"
            @click="payOrder"
            >去支付</el-button
          >
          <el-button
            v-if="order.orderStatus === '待付款'"
            type="danger"
            @click="cancelOrder"
            >取消订单</el-button
          >
        </div>
      </div>
    </el-card>

    <div v-else class="loading">
      <el-skeleton :rows="10" animated />
    </div>

    <el-dialog
      :visible.sync="refundDialogVisible"
      width="700px"
      class="refund-apply-dialog"
      :show-close="false"
    >
      <div class="refund-apply-header">
        <div class="refund-apply-title">
          <i class="el-icon-s-promotion"></i>
          申请退款
        </div>
        <i
          class="el-icon-close refund-apply-close"
          @click="refundDialogVisible = false"
        ></i>
      </div>
      <div class="refund-apply-content">
        <div class="refund-item-card" v-if="currentRefundItemData">
          <div class="refund-item-header">
            <div class="refund-item-badge">
              <i class="el-icon-shopping-bag-2"></i>
              退款商品
            </div>
            <div class="refund-item-info">
              <img
                v-if="currentRefundItemData.coverImage"
                :src="getImageUrl(currentRefundItemData.coverImage)"
                class="refund-item-image"
              />
              <div v-else class="refund-item-image no-image">无图</div>
              <div class="refund-item-details">
                <h4 class="refund-item-title">
                  {{ currentRefundItemData.bookName }}
                </h4>
                <div class="refund-item-meta">
                  <span class="meta-tag">
                    <i class="el-icon-price-tag"></i>
                    单价：¥{{ currentRefundItemData.price }}
                  </span>
                  <span class="meta-tag">
                    <i class="el-icon-goods"></i>
                    数量：×{{ currentRefundItemData.quantity }}
                  </span>
                </div>
              </div>
              <div class="refund-item-amount">
                <div class="amount-label">退款金额</div>
                <div class="amount-value">
                  {{ formatPrice(currentRefundItemData.subtotal) }}
                </div>
              </div>
            </div>
          </div>
        </div>

        <el-form :model="refundForm" label-width="100px" class="refund-form">
          <el-form-item label="退款原因" required>
            <el-select
              v-model="refundForm.reason"
              placeholder="请选择退款原因"
              style="width: 100%"
            >
              <el-option label="商品损坏" value="1">
                <div class="refund-reason-option">
                  <i class="el-icon-warning"></i> 商品损坏
                </div>
              </el-option>
              <el-option label="商品错发" value="2">
                <div class="refund-reason-option">
                  <i class="el-icon-error"></i> 商品错发
                </div>
              </el-option>
              <el-option label="不想买了" value="3">
                <div class="refund-reason-option">
                  <i class="el-icon-circle-close"></i> 不想买了
                </div>
              </el-option>
              <el-option label="其他" value="4">
                <div class="refund-reason-option">
                  <i class="el-icon-info"></i> 其他原因
                </div>
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="详细说明">
            <el-input
              v-model="refundForm.description"
              type="textarea"
              :rows="4"
              placeholder="请详细描述您的退款原因，以便商家更好地处理..."
              maxlength="500"
              show-word-limit
            ></el-input>
          </el-form-item>

          <el-alert
            title="退款须知"
            type="info"
            :closable="false"
            show-icon
            class="refund-notice"
          >
            <template slot>
              <ul class="notice-list">
                <li>退款申请提交后，商家将在 48 小时内处理</li>
                <li>退款金额将原路返回您的支付账户</li>
                <li>如有疑问，可联系商家或平台客服</li>
              </ul>
            </template>
          </el-alert>
        </el-form>
      </div>
      <div slot="footer">
        <el-button @click="refundDialogVisible = false">取消</el-button>
        <el-button
          type="primary"
          :disabled="submitting"
          @click="submitRefund"
          icon="el-icon-s-promotion"
        >
          {{ submitting ? "提交中..." : "提交申请" }}
        </el-button>
      </div>
    </el-dialog>

    <el-dialog
      :visible.sync="refundDetailVisible"
      width="700px"
      class="refund-detail-dialog"
      :show-close="false"
    >
      <div class="refund-detail-header">
        <div class="refund-detail-title">
          <i class="el-icon-document-checked"></i>
          退款详情
        </div>
        <i
          class="el-icon-close refund-detail-close"
          @click="refundDetailVisible = false"
        ></i>
      </div>
      <div v-if="currentRefundItem" class="refund-detail-content">
        <div class="refund-item-card">
          <div class="refund-item-header">
            <div class="refund-item-badge">
              <i class="el-icon-shopping-bag-2"></i>
              商品信息
            </div>
            <div class="refund-item-info">
              <img
                v-if="currentRefundItem.coverImage"
                :src="getImageUrl(currentRefundItem.coverImage)"
                class="refund-item-image"
              />
              <div v-else class="refund-item-image no-image">无图</div>
              <div class="refund-item-details">
                <h4 class="refund-item-title">
                  {{ currentRefundItem.bookName }}
                </h4>
                <div class="refund-item-meta">
                  <span class="meta-tag">
                    <i class="el-icon-price-tag"></i>
                    单价：¥{{ currentRefundItem.price }}
                  </span>
                  <span class="meta-tag">
                    <i class="el-icon-goods"></i>
                    数量：×{{ currentRefundItem.quantity }}
                  </span>
                  <span class="meta-tag">
                    <i class="el-icon-coin"></i>
                    小计：{{ formatPrice(currentRefundItem.subtotal) }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <el-divider content-position="left">退款信息</el-divider>

        <el-descriptions :column="2" border>
          <el-descriptions-item label="退款状态">
            <el-tag
              :type="getStatusType(currentRefundItem.status)"
              size="small"
            >
              <i :class="getStatusIcon(currentRefundItem.status)"></i>
              {{ currentRefundItem.status }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="退款金额">
            <span class="refund-amount-text">{{
              formatPrice(
                refundDetail.refundAmount || currentRefundItem.subtotal
              )
            }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="退款原因">
            {{ getRefundReasonText(refundDetail.refundReason) }}
          </el-descriptions-item>
          <el-descriptions-item label="申请时间">
            {{
              formatTime(
                refundDetail.createTime || currentRefundItem.createTime
              )
            }}
          </el-descriptions-item>
          <el-descriptions-item label="详细说明" :span="2">
            {{ refundDetail.refundDescription || "无" }}
          </el-descriptions-item>
        </el-descriptions>

        <template
          v-if="
            refundDetail.merchantReply ||
            refundDetail.refundStatus === '已拒绝' ||
            refundDetail.refundStatus === '已通过'
          "
        >
          <el-divider content-position="left">商家回复</el-divider>
          <el-alert
            :title="
              refundDetail.refundStatus === '已拒绝'
                ? '商家已拒绝退款'
                : '商家已通过退款'
            "
            :type="refundDetail.refundStatus === '已拒绝' ? 'error' : 'success'"
            :description="
              refundDetail.merchantReply ||
              (refundDetail.refundStatus === '已拒绝'
                ? '商家拒绝了您的退款申请'
                : '商家已通过您的退款申请')
            "
            show-icon
            :closable="false"
          >
          </el-alert>
          <p class="process-time" v-if="refundDetail.processTime">
            处理时间：{{ formatTime(refundDetail.processTime) }}
          </p>
        </template>

        <template v-if="refundDetail.refundStatus === '已拒绝'">
          <el-divider content-position="left">后续操作</el-divider>
          <div class="action-buttons-detail">
            <el-button
              type="warning"
              size="small"
              icon="el-icon-refresh"
              @click="reapplyRefund"
            >
              再次申请退款
            </el-button>
            <el-button
              v-if="currentRefundItem.merchantPhone"
              type="primary"
              size="small"
              icon="el-icon-phone"
              @click="contactMerchantFromDetail"
            >
              联系商家
            </el-button>
          </div>
        </template>

        <template v-else-if="refundDetail.refundStatus === '已通过'">
          <el-divider content-position="left">退款完成</el-divider>
          <el-alert
            title="退款已通过"
            description="商家已通过您的退款申请，款项将原路返回，请注意查收"
            type="success"
            show-icon
            :closable="false"
          >
          </el-alert>
        </template>
      </div>
      <div v-else class="loading-detail">
        <el-skeleton :rows="5" animated />
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from "@/api/request";
import { Message } from "element-ui";
import { getImageUrl } from "@/utils/img";

export default {
  name: "OrderDetail",
  data() {
    return {
      order: null,
      orderItems: [],
      orderId: null,
      refundInfo: null,
      refundDialogVisible: false,
      refundDetailVisible: false,
      currentRefundItem: null,
      currentRefundItemData: null,
      refundDetail: {},
      refundForm: {
        orderItemId: "",
        refundAmount: 0,
        reason: "",
        description: "",
      },
      submitting: false,
    };
  },
  computed: {
    getSelectedItem() {
      if (!this.refundForm.orderItemId) return null;
      return this.orderItems.find(
        (item) => item.id === this.refundForm.orderItemId
      );
    },
    itemsTotalAmount() {
      if (!this.orderItems || this.orderItems.length === 0) return 0;
      return this.orderItems.reduce((sum, item) => {
        const subtotal = item.subtotal || item.price * item.quantity;
        return sum + subtotal;
      }, 0);
    },
  },
  mounted() {
    this.orderId = this.$route.params.id;
    if (this.orderId) {
      this.loadOrderDetail();
    } else {
      Message.error("订单ID不存在");
      this.$router.push("/my-orders");
    }
  },
  methods: {
    getDisplayStatus(item) {
      if (item.status === "待评价" && item.commented) {
        return "已完成";
      }
      return item.status;
    },
    formatPrice(value) {
      if (value === null || value === undefined) {
        return "¥0.00";
      }
      const num = typeof value === "string" ? parseFloat(value) : value;
      if (isNaN(num)) {
        return "¥0.00";
      }
      return "¥" + num.toFixed(2);
    },
    async loadOrderDetail() {
      try {
        const res = await axios.get(`/order/${this.orderId}`);
        if (res.code === 200) {
          this.order = res.data.order;
          this.refundInfo = res.data.refund || null;
          await this.loadOrderItems();
        } else {
          Message.error(res.msg || "获取订单详情失败");
        }
      } catch (error) {
        Message.error("获取订单详情失败");
      }
    },
    async loadOrderItems() {
      try {
        const res = await axios.get(`/order/items/${this.orderId}`);
        if (res.code === 200) {
          this.orderItems = res.data || [];
        }
      } catch (error) {}
    },
    canShowRefundButton(item) {
      const canRefundStatuses = ["待发货", "已发货", "待收货"];
      if (!canRefundStatuses.includes(item.status)) {
        return false;
      }
      if (item.refundStatus === "待处理" || item.refundStatus === "退款中") {
        return false;
      }
      if (item.status === "已完成") {
        return false;
      }
      return true;
    },
    async remindItemShip(itemId) {
      try {
        await axios.post(`/order/${this.orderId}/remind`);
        this.$message.success("已提醒买家发货");
        this.loadOrderDetail();
      } catch (error) {
        console.error("提醒发货失败:", error);
        this.$message.error("提醒发货失败");
      }
    },
    goToBookDetail(bookId) {
      this.$router.push(`/home/book-detail/${bookId}`);
    },
    formatTime(time) {
      if (!time) return "";
      const d = new Date(time);
      const year = d.getFullYear();
      const month = (d.getMonth() + 1).toString().padStart(2, "0");
      const day = d.getDate().toString().padStart(2, "0");
      const hours = d.getHours().toString().padStart(2, "0");
      const minutes = d.getMinutes().toString().padStart(2, "0");
      return `${year}-${month}-${day} ${hours}:${minutes}`;
    },
    getStepActive(status) {
      const steps = {
        待付款: 0,
        退款中: 1,
        待发货: 1,
        待收货: 2,
        待评价: 3,
        已完成: 4,
        已取消: -1,
        已退款: -1,
      };
      return steps[status] !== undefined ? steps[status] : 0;
    },
    payOrder() {
      this.$confirm("确认支付此订单吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "info",
      })
        .then(async () => {
          try {
            const res = await axios.put("/order/pay", {
              id: this.order.id,
            });
            if (res.code === 200) {
              Message.success("支付成功");
              this.loadOrderDetail();
            } else {
              Message.error(res.msg || "支付失败");
            }
          } catch (error) {
            Message.error("支付失败");
          }
        })
        .catch(() => {
          return Promise.resolve();
        });
    },
    cancelOrder() {
      this.$confirm("确认取消此订单吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      })
        .then(async () => {
          try {
            const res = await axios.put("/order/cancel", {
              id: this.order.id,
            });
            if (res.code === 200) {
              Message.success("订单已取消");
              this.loadOrderDetail();
            } else {
              Message.error(res.msg || "取消订单失败");
            }
          } catch (error) {
            Message.error("取消订单失败");
          }
        })
        .catch(() => {
          return Promise.resolve();
        });
    },
    confirmReceive() {
      this.$confirm("确认已收到商品吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "success",
      })
        .then(async () => {
          try {
            const res = await axios.put("/order/confirm", {
              id: this.order.id,
            });
            if (res.code === 200) {
              Message.success("已确认收货");
              this.loadOrderDetail();
            } else {
              Message.error(res.msg || "确认收货失败");
            }
          } catch (error) {
            Message.error("确认收货失败");
          }
        })
        .catch(() => {
          return Promise.resolve();
        });
    },
    goToComment(item) {
      if (!item || !item.bookId) {
        this.$message.error("商品信息不完整");
        return;
      }

      this.$router
        .push({
          path: "/home/book-detail/" + item.bookId,
          query: {
            orderId: this.order.id,
            orderItemId: item.id,
          },
        })
        .catch(() => {});
    },
    showRefundDialog() {
      this.refundForm = {
        orderItemId: this.orderItems.length > 0 ? this.orderItems[0].id : "",
        refundAmount:
          this.orderItems.length > 0 ? this.orderItems[0].subtotal : 0,
        reason: "",
        description: "",
      };
      this.refundDialogVisible = true;
    },
    contactMerchant(item) {
      if (!item || !item.merchantId) {
        this.$message.error("无法获取商家信息");
        return;
      }

      if (item.merchantPhone) {
        this.$confirm(
          `商家联系电话：${item.merchantPhone}<br/>是否拨打？`,
          "联系商家",
          {
            confirmButtonText: "拨打",
            cancelButtonText: "取消",
            dangerouslyUseHTMLString: true,
            type: "info",
          }
        )
          .then(() => {
            window.location.href = `tel:${item.merchantPhone}`;
          })
          .catch(() => {});
      } else {
        this.$message.info("该商家暂未提供联系电话");
      }
    },
    handleItemChange(itemId) {
      const item = this.orderItems.find((i) => i.id === itemId);
      if (item) {
        this.refundForm.refundAmount = item.subtotal;
      }
    },
    submitRefund() {
      if (!this.refundForm.orderItemId) {
        this.$message.error("请选择要退款的商品");
        return;
      }

      if (!this.refundForm.reason) {
        this.$message.error("请选择退款原因");
        return;
      }

      if (this.submitting) {
        return;
      }
      this.submitting = true;

      axios
        .post("/refund/apply-by-item", {
          orderId: this.order.id,
          userId: this.order.userId,
          orderItemId: this.refundForm.orderItemId,
          reason: this.refundForm.reason,
          description: this.refundForm.description,
        })
        .then((res) => {
          if (res.code === 200) {
            this.$message.success("退款申请已提交");
            this.refundDialogVisible = false;
            this.loadOrderDetail();
          }
        })
        .catch(() => {})
        .finally(() => {
          this.submitting = false;
        });
    },
    contactMerchant() {
      this.$message.info("商家联系方式：请查看订单中的商家信息");
    },
    confirmItemReceive(orderItemId) {
      this.$confirm("确认已收到该商品吗？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "success",
      })
        .then(async () => {
          try {
            const res = await axios.put("/order/confirm", {
              id: this.order.id,
              orderItemId: orderItemId,
            });
            if (res.code === 200) {
              Message.success("已确认收货");
              this.loadOrderDetail();
            } else {
              Message.error(res.msg || "确认收货失败");
            }
          } catch (error) {
            Message.error("确认收货失败");
          }
        })
        .catch(() => {
          return Promise.resolve();
        });
    },
    openRefundDialog(item) {
      this.currentRefundItemData = item;
      this.refundForm = {
        orderItemId: item.id,
        refundAmount: item.subtotal,
        reason: "",
        description: "",
      };
      this.refundDialogVisible = true;
    },
    showItemRefundDialog(item) {
      this.currentRefundItemData = item;
      this.refundForm = {
        orderItemId: item.id,
        refundAmount: item.subtotal,
        reason: "",
        description: "",
      };
      this.refundDialogVisible = true;
    },
    viewRefundDetail(item) {
      this.currentRefundItem = item;
      this.refundDetail = {};

      axios
        .get("/refund/latest/" + item.id)
        .then((res) => {
          if (res.code === 200 && res.data) {
            this.refundDetail = res.data;
          }
          this.refundDetailVisible = true;
        })
        .catch(() => {
          this.refundDetailVisible = true;
        });
    },
    getRefundReasonText(reason) {
      const reasons = {
        1: "商品损坏",
        2: "商品错发",
        3: "不想买了",
        4: "其他",
      };
      return reasons[reason] || reason || "其他";
    },
    getStatusType(status) {
      const typeMap = {
        待付款: "warning",
        待发货: "primary",
        待收货: "success",
        已完成: "success",
        退款中: "warning",
        已退款: "danger",
        已取消: "info",
      };
      return typeMap[status] || "info";
    },
    getStatusIcon(status) {
      const iconMap = {
        待付款: "el-icon-time",
        待发货: "el-icon-box",
        待收货: "el-icon-truck",
        已完成: "el-icon-circle-check",
        退款中: "el-icon-warning-outline",
        已退款: "el-icon-circle-close",
        已取消: "el-icon-circle-close",
      };
      return iconMap[status] || "el-icon-info";
    },
    reapplyRefund() {
      this.refundDetailVisible = false;
      this.currentRefundItemData = null;
      this.refundForm = {
        orderItemId: this.currentRefundItem.id,
        refundAmount: this.currentRefundItem.subtotal,
        reason: "",
        description: "",
      };
      this.refundDialogVisible = true;
    },
    contactMerchantFromDetail() {
      if (this.currentRefundItem && this.currentRefundItem.merchantPhone) {
        this.$confirm(
          `商家联系电话：${this.currentRefundItem.merchantPhone}<br/>是否拨打？`,
          "联系商家",
          {
            confirmButtonText: "拨打",
            cancelButtonText: "取消",
            dangerouslyUseHTMLString: true,
            type: "info",
          }
        )
          .then(() => {
            window.location.href = `tel:${this.currentRefundItem.merchantPhone}`;
          })
          .catch(() => {});
      } else {
        this.$message.info("该商家暂未提供联系电话");
      }
    },
  },
};
</script>

<style scoped>
.status-hint {
  color: #909399;
  font-size: 12px;
}

.status-hint i {
  margin-right: 4px;
}

.status-cell {
  /* 保持默认display，不占用额外空间 */
}

.express-tag {
  cursor: pointer;
  transition: all 0.3s;
}

.express-tag:hover {
  box-shadow: 0 2px 8px rgba(103, 194, 58, 0.4);
  transform: translateY(-1px);
}

.express-info {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: #409eff;
  background: #ecf5ff;
  padding: 4px 8px;
  border-radius: 4px;
}

.express-info i {
  font-weight: bold;
}

.action-buttons {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 4px;
  flex-wrap: nowrap;
}

.refund-amount {
  font-size: 18px;
  color: #f56c6c;
  font-weight: bold;
}

.refund-info-card {
  margin-top: 20px;
  padding: 20px;
  background: linear-gradient(135deg, #fdfbfb 0%, #ebedee 100%);
  border-radius: 8px;
  border-left: 4px solid #e6a23c;
}

.refund-info-card .el-icon-success {
  color: #67c23a;
  font-size: 24px;
}

.refund-info-card .el-icon-warning {
  color: #e6a23c;
  font-size: 24px;
}

.refund-status-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 15px;
}

.refund-status-title {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
}

.refund-detail {
  background: white;
  padding: 15px;
  border-radius: 6px;
  margin-bottom: 15px;
}

.refund-amount-info {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
  font-size: 15px;
}

.refund-amount-info .label {
  color: #606266;
  min-width: 80px;
}

.refund-amount-info .value {
  color: #f56c6c;
  font-weight: 600;
  font-size: 18px;
}

.refund-reason {
  background: #fef0f0;
  padding: 12px;
  border-radius: 6px;
  margin-bottom: 12px;
}

.reason-label {
  color: #f56c6c;
  font-weight: 500;
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 5px;
}

.reason-content {
  color: #606266;
  line-height: 1.6;
  padding-left: 20px;
}

.refund-time {
  display: flex;
  align-items: center;
  font-size: 13px;
  color: #909399;
}

.refund-time .label {
  min-width: 80px;
}

.refund-actions {
  display: flex;
  gap: 10px;
}

.refund-detail-dialog ::v-deep .el-dialog__header {
  display: none;
}

.refund-detail-dialog ::v-deep .el-dialog__body {
  padding: 0;
}

.refund-detail-header {
  background: linear-gradient(135deg, #67c23a 0%, #5daf34 100%);
  color: white;
  padding: 10px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.refund-detail-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  font-weight: 600;
}

.refund-detail-title i {
  font-size: 18px;
}

.refund-detail-close {
  font-size: 16px;
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  transition: background 0.3s;
}

.refund-detail-close:hover {
  background: rgba(255, 255, 255, 0.2);
}

.refund-detail-content {
  padding: 15px 20px;
}

.refund-item-card {
  margin-bottom: 20px;
  background: #f5f7fa;
  border-radius: 6px;
  padding: 12px;
  border: 1px solid #ebeef5;
}

.refund-item-header {
  margin-bottom: 0;
}

.refund-item-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 3px 10px;
  background: linear-gradient(135deg, #67c23a 0%, #5daf34 100%);
  color: white;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 600;
  margin-bottom: 10px;
}

.refund-item-badge i {
  font-size: 13px;
}

.refund-item-info {
  display: flex;
  gap: 12px;
  align-items: flex-start;
  background: white;
  padding: 10px;
  border-radius: 6px;
  border: 1px solid #e4e7ed;
}

.refund-item-image {
  width: 70px;
  height: 70px;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid #e4e7ed;
  background: #f5f7fa;
  flex-shrink: 0;
}

.refund-item-image.no-image {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
  color: #909399;
  font-size: 12px;
}

.refund-item-details {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.refund-item-title {
  margin: 0;
  font-size: 15px;
  color: #303133;
  font-weight: 600;
  line-height: 1.5;
}

.refund-item-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.meta-tag {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 3px 10px;
  background: #f4f4f5;
  border-radius: 4px;
  font-size: 12px;
  color: #606266;
}

.meta-tag i {
  color: #67c23a;
}

.refund-item-amount {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  justify-content: center;
  gap: 4px;
  flex-shrink: 0;
}

.refund-item-amount .amount-label {
  font-size: 12px;
  color: #909399;
}

.refund-item-amount .amount-value {
  font-size: 20px;
  font-weight: bold;
  color: #f56c6c;
}

.item-info-card {
  margin-bottom: 20px;
  background: #f5f7fa;
  border-radius: 8px;
  padding: 15px;
  border: 1px solid #ebeef5;
}

.item-header {
  display: flex;
  gap: 15px;
  align-items: flex-start;
  background: white;
  padding: 12px;
  border-radius: 6px;
  border: 1px solid #e4e7ed;
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
  background: #f5f7fa;
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

.process-time {
  margin-top: 10px;
  font-size: 13px;
  color: #909399;
  text-align: right;
}

.action-buttons-detail {
  display: flex;
  gap: 10px;
  justify-content: center;
  padding: 15px 0;
}

.loading-detail {
  padding: 20px;
}

.refund-apply-dialog ::v-deep .el-dialog__header {
  display: none;
}

.refund-apply-dialog ::v-deep .el-dialog__body {
  padding: 0;
}

.refund-apply-content {
  padding: 15px 20px;
}

.refund-apply-header {
  background: linear-gradient(135deg, #67c23a 0%, #5daf34 100%);
  color: white;
  padding: 10px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.refund-apply-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  font-weight: 600;
}

.refund-apply-title i {
  font-size: 18px;
}

.refund-apply-close {
  font-size: 16px;
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  transition: background 0.3s;
}

.refund-apply-close:hover {
  background: rgba(255, 255, 255, 0.2);
}

.refund-item-card {
  margin-bottom: 15px;
  background: #f5f7fa;
  border-radius: 6px;
  padding: 12px;
  border: 1px solid #ebeef5;
}

.refund-item-header {
  margin-bottom: 0;
}

.refund-item-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 12px;
  background: linear-gradient(135deg, #67c23a 0%, #5daf34 100%);
  color: white;
  border-radius: 4px;
  font-size: 13px;
  font-weight: 600;
  margin-bottom: 12px;
}

.refund-item-badge i {
  font-size: 14px;
}

.refund-item-info {
  display: flex;
  gap: 15px;
  align-items: flex-start;
  background: white;
  padding: 12px;
  border-radius: 6px;
  border: 1px solid #e4e7ed;
}

.refund-item-image {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid #e4e7ed;
  background: #f5f7fa;
  flex-shrink: 0;
}

.refund-item-image.no-image {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f7fa;
  color: #909399;
  font-size: 12px;
}

.refund-item-details {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.refund-item-title {
  margin: 0;
  font-size: 15px;
  color: #303133;
  font-weight: 600;
  line-height: 1.5;
}

.refund-item-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.meta-tag {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 3px 10px;
  background: #f4f4f5;
  border-radius: 4px;
  font-size: 12px;
  color: #606266;
}

.meta-tag i {
  color: #67c23a;
}

.refund-item-amount {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  justify-content: center;
  gap: 4px;
  flex-shrink: 0;
}

.refund-item-amount .amount-label {
  font-size: 12px;
  color: #909399;
}

.refund-item-amount .amount-value {
  font-size: 20px;
  font-weight: bold;
  color: #f56c6c;
}

.refund-form {
  margin-top: 15px;
}

.refund-reason-option {
  display: flex;
  align-items: center;
  gap: 8px;
}

.refund-reason-option i {
  color: #409eff;
}

.refund-notice {
  margin-top: 15px;
}

.notice-list {
  margin: 0;
  padding-left: 20px;
  color: #606266;
  font-size: 13px;
}

.notice-list li {
  margin-bottom: 5px;
  line-height: 1.6;
}

.notice-list li:last-child {
  margin-bottom: 0;
}

.order-detail {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.detail-content {
  margin-top: 20px;
}

.book-list {
  margin-top: 30px;
}

.book-list h3 {
  margin-bottom: 15px;
  color: #333;
}

.book-info {
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: all 0.3s;
  padding: 4px;
  border-radius: 4px;
}

.book-info:hover {
  background-color: #f5f7fa;
  transform: translateX(4px);
}

.book-info:hover .book-name {
  color: #409eff;
}

.book-detail {
  display: flex;
  flex-direction: column;
}

.book-cover {
  width: 50px;
  height: 60px;
  object-fit: cover;
  margin-right: 10px;
  border-radius: 4px;
}

.book-cover.no-image {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
  color: #999;
  font-size: 12px;
}

.book-name {
  font-weight: 500;
}

.merchant-info {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}

.merchant-info i {
  margin-right: 4px;
}

.merchant-phone {
  margin-left: 10px;
  color: #c0c4cc;
}

.subtotal {
  color: #ff4400;
  font-weight: bold;
}

.order-summary {
  margin-top: 20px;
  padding: 20px;
  background: #f9f9f9;
  border-radius: 8px;
  max-width: 300px;
  margin-left: auto;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
  color: #666;
}

.summary-row.total {
  padding-top: 10px;
  border-top: 1px solid #ddd;
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.summary-row .price {
  color: #ff4400;
  font-size: 20px;
}

.order-actions {
  margin-top: 30px;
  display: flex;
  gap: 10px;
}

.loading {
  padding: 20px;
}
</style>
