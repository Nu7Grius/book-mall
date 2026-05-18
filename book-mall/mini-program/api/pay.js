import request from "./request.js";

/**
 * 发起订单支付
 * @param {Object} params - 支付参数
 * @param {number} params.id - 订单ID
 * @param {string} params.paymentMethod - 支付方式（如"微信支付"）
 * @returns {Promise}
 */
export function payOrder(params) {
  return request({
    url: "/api/order/pay",
    method: "PUT",
    data: params,
  });
}

/**
 * 微信小程序支付
 * @param {Object} orderInfo - 订单信息
 * @returns {Promise}
 */
export function wxPay(orderInfo) {
  return new Promise((resolve, reject) => {
    // 微信小程序支付流程：
    // 1. 小程序调用后端获取支付参数
    // 2. 后端调用微信支付API获取prepay_id
    // 3. 小程序使用wx.requestPayment调起微信支付
    // 4. 支付完成后通知后端

    uni.showLoading({ title: "正在发起支付..." });

    // 这里先调用后端的支付接口
    payOrder({
      id: orderInfo.id,
      paymentMethod: "微信支付",
    })
      .then((res) => {
        uni.hideLoading();
        if (res.code === 200) {
          // 模拟支付成功（实际项目中这里需要调用 wx.requestPayment）
          uni.showToast({
            title: "支付成功",
            icon: "success",
          });
          resolve(res);
        } else {
          uni.showToast({
            title: res.message || "支付失败",
            icon: "none",
          });
          reject(new Error(res.message));
        }
      })
      .catch((err) => {
        uni.hideLoading();
        uni.showToast({
          title: "支付失败",
          icon: "none",
        });
        reject(err);
      });
  });
}
