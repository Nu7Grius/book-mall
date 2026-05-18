<template>
  <div class="customer-service-page">
    <div class="service-container">
      <div class="service-header">
        <h1>联系客服</h1>
        <p class="subtitle">我们随时为您服务</p>
      </div>

      <div class="service-cards">
        <div class="service-card" @click="callHotline">
          <div class="card-icon phone-icon">📞</div>
          <div class="card-content">
            <h3>电话客服</h3>
            <p class="phone-number">400-888-8888</p>
            <p class="service-time">工作日 9:00-18:00</p>
          </div>
          <i class="el-icon-arrow-right arrow-icon"></i>
        </div>

        <div class="service-card" @click="copyWechat">
          <div class="card-icon wechat-icon green">💬</div>
          <div class="card-content">
            <h3>微信客服</h3>
            <p class="phone-number">bookmall888</p>
            <p class="service-time">平均响应 5 分钟</p>
          </div>
          <i class="el-icon-arrow-right arrow-icon"></i>
        </div>

        <div class="service-card" @click="sendEmail">
          <div class="card-icon email-icon blue">✉️</div>
          <div class="card-content">
            <h3>邮箱联系</h3>
            <p class="phone-number">{{ email }}</p>
            <p class="service-time">24小时内回复</p>
          </div>
          <i class="el-icon-arrow-right arrow-icon"></i>
        </div>
      </div>

      <div class="tips-section">
        <h3>温馨提示</h3>
        <ul class="tips-list">
          <li>请详细描述您遇到的问题</li>
          <li>提供订单号可加快处理速度</li>
          <li>遇到支付问题建议保留截图</li>
          <li>客服工作时间内必回复</li>
        </ul>
      </div>

      <div class="common-questions">
        <h3>常见问题</h3>
        <el-collapse>
          <el-collapse-item title="如何修改收货地址？" name="1">
            <div>
              进入"我的 →
              收货地址"，点击右上角"新增地址"按钮，填写完整信息后保存即可。
            </div>
          </el-collapse-item>
          <el-collapse-item title="订单如何申请退款？" name="2">
            <div>
              进入"我的订单"，找到对应订单，点击"申请退款"按钮，填写退款原因后提交即可。退款申请提交后，商家会在1-3个工作日内处理。
            </div>
          </el-collapse-item>
          <el-collapse-item title="如何查看物流信息？" name="3">
            <div>
              订单发货后，将鼠标悬停在订单商品的"待收货"、"待评价"或"已完成"状态标签上，系统会自动显示当前物流信息（快递公司和快递单号）。
            </div>
          </el-collapse-item>
          <el-collapse-item title="忘记登录密码怎么办？" name="4">
            <div>
              请通过电话客服（400-888-8888）、微信客服（bookmall888）或邮箱（{{
                email
              }}）联系平台客服管理员，提供您的账号信息，管理员会帮您重置密码。
            </div>
          </el-collapse-item>
        </el-collapse>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "CustomerService",
  data() {
    return {
      hotline: "400-888-8888",
      wechat: "bookmall888",
      email: "admin@bookmall.com",
    };
  },
  mounted() {
    this.fetchAdminContact();
  },
  methods: {
    fetchAdminContact() {
      this.$axios.get("/user/admin-contact").then((res) => {
        if (res.data.code === 200 && res.data.data) {
          this.email = res.data.data.email || "admin@bookmall.com";
          this.hotline = res.data.data.phone || "400-888-8888";
        }
      });
    },
    callHotline() {
      window.location.href = "tel:" + this.hotline;
      this.$message.success("正在拨打 " + this.hotline);
    },
    copyWechat() {
      navigator.clipboard
        .writeText(this.wechat)
        .then(() => {
          this.$message.success("微信号已复制到剪贴板");
        })
        .catch(() => {
          this.$message.error("复制失败，请手动复制");
        });
    },
    sendEmail() {
      window.location.href = "mailto:" + this.email;
    },
  },
};
</script>

<style scoped>
.customer-service-page {
  min-height: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 40px 20px;
}

.service-container {
  max-width: 800px;
  margin: 0 auto;
}

.service-header {
  text-align: center;
  color: white;
  margin-bottom: 40px;
}

.service-header h1 {
  font-size: 36px;
  margin-bottom: 10px;
}

.subtitle {
  font-size: 18px;
  opacity: 0.9;
}

.service-cards {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-bottom: 40px;
}

.service-card {
  background: white;
  border-radius: 16px;
  padding: 24px;
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.service-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
}

.card-icon {
  width: 64px;
  height: 64px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 32px;
  margin-right: 20px;
  flex-shrink: 0;
}

.phone-icon {
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
}

.wechat-icon.green {
  background: linear-gradient(135deg, #26de81 0%, #20bf6b 100%);
}

.email-icon.blue {
  background: linear-gradient(135deg, #4b7bec 0%, #3867d6 100%);
}

.card-content {
  flex: 1;
}

.card-content h3 {
  font-size: 18px;
  color: #333;
  margin-bottom: 6px;
}

.phone-number {
  font-size: 20px;
  font-weight: bold;
  color: #409eff;
  margin: 4px 0;
}

.service-time {
  font-size: 14px;
  color: #999;
}

.arrow-icon {
  font-size: 24px;
  color: #ccc;
}

.tips-section {
  background: white;
  border-radius: 16px;
  padding: 24px;
  margin-bottom: 40px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.tips-section h3 {
  font-size: 18px;
  color: #333;
  margin-bottom: 16px;
}

.tips-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.tips-list li {
  padding: 10px 0;
  color: #666;
  font-size: 15px;
  border-bottom: 1px solid #f0f0f0;
}

.tips-list li:last-child {
  border-bottom: none;
}

.common-questions {
  background: white;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.common-questions h3 {
  font-size: 18px;
  color: #333;
  margin-bottom: 16px;
}
</style>
