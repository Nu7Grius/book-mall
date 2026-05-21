(global["webpackJsonp"] = global["webpackJsonp"] || []).push([["pages/order-detail/order-detail"],{

/***/ 123:
/*!*************************************************************************************************************************************************************************************!*\
  !*** D:/CommonDataAndInformation/永远期待/永远期待2.0/AI时代/全栈学习计划——书魂管理系统及微信小程序读者端/week10-12（4.27开始）/project/book-mall/mini-program/main.js?{"page":"pages%2Forder-detail%2Forder-detail"} ***!
  \*************************************************************************************************************************************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(wx, createPage) {

var _interopRequireDefault = __webpack_require__(/*! @babel/runtime/helpers/interopRequireDefault */ 4);
__webpack_require__(/*! uni-pages */ 30);
var _vue = _interopRequireDefault(__webpack_require__(/*! vue */ 25));
var _orderDetail = _interopRequireDefault(__webpack_require__(/*! ./pages/order-detail/order-detail.vue */ 124));
// @ts-ignore
wx.__webpack_require_UNI_MP_PLUGIN__ = __webpack_require__;
createPage(_orderDetail.default);
/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./node_modules/@dcloudio/uni-mp-weixin/dist/wx.js */ 1)["default"], __webpack_require__(/*! ./node_modules/@dcloudio/uni-mp-weixin/dist/index.js */ 2)["createPage"]))

/***/ }),

/***/ 124:
/*!******************************************************************************************************************************************************************!*\
  !*** D:/CommonDataAndInformation/永远期待/永远期待2.0/AI时代/全栈学习计划——书魂管理系统及微信小程序读者端/week10-12（4.27开始）/project/book-mall/mini-program/pages/order-detail/order-detail.vue ***!
  \******************************************************************************************************************************************************************/
/*! no static exports found */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _order_detail_vue_vue_type_template_id_d80893f4_scoped_true___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! ./order-detail.vue?vue&type=template&id=d80893f4&scoped=true& */ 125);
/* harmony import */ var _order_detail_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! ./order-detail.vue?vue&type=script&lang=js& */ 127);
/* harmony reexport (unknown) */ for(var __WEBPACK_IMPORT_KEY__ in _order_detail_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__) if(["default"].indexOf(__WEBPACK_IMPORT_KEY__) < 0) (function(key) { __webpack_require__.d(__webpack_exports__, key, function() { return _order_detail_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__[key]; }) }(__WEBPACK_IMPORT_KEY__));
/* harmony import */ var _order_detail_vue_vue_type_style_index_0_id_d80893f4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./order-detail.vue?vue&type=style&index=0&id=d80893f4&scoped=true&lang=css& */ 130);
/* harmony import */ var _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/vue-cli-plugin-uni/packages/vue-loader/lib/runtime/componentNormalizer.js */ 36);

var renderjs





/* normalize component */

var component = Object(_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_runtime_componentNormalizer_js__WEBPACK_IMPORTED_MODULE_3__["default"])(
  _order_detail_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_1__["default"],
  _order_detail_vue_vue_type_template_id_d80893f4_scoped_true___WEBPACK_IMPORTED_MODULE_0__["render"],
  _order_detail_vue_vue_type_template_id_d80893f4_scoped_true___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"],
  false,
  null,
  "d80893f4",
  null,
  false,
  _order_detail_vue_vue_type_template_id_d80893f4_scoped_true___WEBPACK_IMPORTED_MODULE_0__["components"],
  renderjs
)

component.options.__file = "pages/order-detail/order-detail.vue"
/* harmony default export */ __webpack_exports__["default"] = (component.exports);

/***/ }),

/***/ 125:
/*!*************************************************************************************************************************************************************************************************************!*\
  !*** D:/CommonDataAndInformation/永远期待/永远期待2.0/AI时代/全栈学习计划——书魂管理系统及微信小程序读者端/week10-12（4.27开始）/project/book-mall/mini-program/pages/order-detail/order-detail.vue?vue&type=template&id=d80893f4&scoped=true& ***!
  \*************************************************************************************************************************************************************************************************************/
/*! exports provided: render, staticRenderFns, recyclableRender, components */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_17_0_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_template_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_uni_app_loader_page_meta_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_template_id_d80893f4_scoped_true___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/vue-cli-plugin-uni/packages/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/vue-cli-plugin-uni/packages/webpack-preprocess-loader??ref--17-0!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/webpack-uni-mp-loader/lib/template.js!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/vue-cli-plugin-uni/packages/webpack-uni-app-loader/page-meta.js!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/vue-cli-plugin-uni/packages/vue-loader/lib??vue-loader-options!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/webpack-uni-mp-loader/lib/style.js!./order-detail.vue?vue&type=template&id=d80893f4&scoped=true& */ 126);
/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "render", function() { return _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_17_0_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_template_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_uni_app_loader_page_meta_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_template_id_d80893f4_scoped_true___WEBPACK_IMPORTED_MODULE_0__["render"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_17_0_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_template_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_uni_app_loader_page_meta_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_template_id_d80893f4_scoped_true___WEBPACK_IMPORTED_MODULE_0__["staticRenderFns"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "recyclableRender", function() { return _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_17_0_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_template_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_uni_app_loader_page_meta_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_template_id_d80893f4_scoped_true___WEBPACK_IMPORTED_MODULE_0__["recyclableRender"]; });

/* harmony reexport (safe) */ __webpack_require__.d(__webpack_exports__, "components", function() { return _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_loaders_templateLoader_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_17_0_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_template_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_uni_app_loader_page_meta_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_template_id_d80893f4_scoped_true___WEBPACK_IMPORTED_MODULE_0__["components"]; });



/***/ }),

/***/ 126:
/*!*************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/@dcloudio/vue-cli-plugin-uni/packages/vue-loader/lib/loaders/templateLoader.js??vue-loader-options!./node_modules/@dcloudio/vue-cli-plugin-uni/packages/webpack-preprocess-loader??ref--17-0!./node_modules/@dcloudio/webpack-uni-mp-loader/lib/template.js!./node_modules/@dcloudio/vue-cli-plugin-uni/packages/webpack-uni-app-loader/page-meta.js!./node_modules/@dcloudio/vue-cli-plugin-uni/packages/vue-loader/lib??vue-loader-options!./node_modules/@dcloudio/webpack-uni-mp-loader/lib/style.js!D:/CommonDataAndInformation/永远期待/永远期待2.0/AI时代/全栈学习计划——书魂管理系统及微信小程序读者端/week10-12（4.27开始）/project/book-mall/mini-program/pages/order-detail/order-detail.vue?vue&type=template&id=d80893f4&scoped=true& ***!
  \*************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************/
/*! exports provided: render, staticRenderFns, recyclableRender, components */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "render", function() { return render; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "staticRenderFns", function() { return staticRenderFns; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "recyclableRender", function() { return recyclableRender; });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "components", function() { return components; });
var components
var render = function () {
  var _vm = this
  var _h = _vm.$createElement
  var _c = _vm._self._c || _h
  var g0 = _vm.orderItems.length
  var l0 =
    g0 > 0
      ? _vm.__map(_vm.orderItems, function (item, __i0__) {
          var $orig = _vm.__get_orig(item)
          var m0 = _vm.getItemImage(item)
          var m1 = _vm.getDisplayStatus(item)
          var m2 =
            _vm.getDisplayStatus(item) === "待付款" ||
            _vm.getDisplayStatus(item) === "退款中" ||
            _vm.getDisplayStatus(item) === "待评价"
          var m3 =
            _vm.getDisplayStatus(item) === "已完成" ||
            _vm.getDisplayStatus(item) === "待收货"
          var m4 =
            _vm.getDisplayStatus(item) === "已退款" ||
            _vm.getDisplayStatus(item) === "已取消"
          var m5 = _vm.getItemStatusText(item.status, item.commented)
          var m6 = _vm.getItemPrice(item)
          return {
            $orig: $orig,
            m0: m0,
            m1: m1,
            m2: m2,
            m3: m3,
            m4: m4,
            m5: m5,
            m6: m6,
          }
        })
      : null
  var m7 = _vm.formatDate(_vm.order.createTime)
  var m8 =
    _vm.order.paymentTime || _vm.order.payTime
      ? _vm.formatDate(_vm.order.paymentTime || _vm.order.payTime)
      : null
  var m9 =
    _vm.order.shippingTime || _vm.order.deliveryTime
      ? _vm.formatDate(_vm.order.shippingTime || _vm.order.deliveryTime)
      : null
  var m10 =
    _vm.order.completionTime || _vm.order.receiveTime
      ? _vm.formatDate(_vm.order.completionTime || _vm.order.receiveTime)
      : null
  var g1 = _vm.showCommentPopup ? _vm.commentForm.content.length : null
  var g2 = _vm.showCommentPopup ? _vm.commentForm.images.length : null
  _vm.$mp.data = Object.assign(
    {},
    {
      $root: {
        g0: g0,
        l0: l0,
        m7: m7,
        m8: m8,
        m9: m9,
        m10: m10,
        g1: g1,
        g2: g2,
      },
    }
  )
}
var recyclableRender = false
var staticRenderFns = []
render._withStripped = true



/***/ }),

/***/ 127:
/*!*******************************************************************************************************************************************************************************************!*\
  !*** D:/CommonDataAndInformation/永远期待/永远期待2.0/AI时代/全栈学习计划——书魂管理系统及微信小程序读者端/week10-12（4.27开始）/project/book-mall/mini-program/pages/order-detail/order-detail.vue?vue&type=script&lang=js& ***!
  \*******************************************************************************************************************************************************************************************/
/*! no static exports found */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_babel_loader_lib_index_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_13_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_script_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/babel-loader/lib!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/vue-cli-plugin-uni/packages/webpack-preprocess-loader??ref--13-1!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/webpack-uni-mp-loader/lib/script.js!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/vue-cli-plugin-uni/packages/vue-loader/lib??vue-loader-options!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/webpack-uni-mp-loader/lib/style.js!./order-detail.vue?vue&type=script&lang=js& */ 128);
/* harmony import */ var _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_babel_loader_lib_index_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_13_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_script_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_babel_loader_lib_index_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_13_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_script_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__);
/* harmony reexport (unknown) */ for(var __WEBPACK_IMPORT_KEY__ in _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_babel_loader_lib_index_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_13_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_script_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__) if(["default"].indexOf(__WEBPACK_IMPORT_KEY__) < 0) (function(key) { __webpack_require__.d(__webpack_exports__, key, function() { return _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_babel_loader_lib_index_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_13_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_script_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0__[key]; }) }(__WEBPACK_IMPORT_KEY__));
 /* harmony default export */ __webpack_exports__["default"] = (_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_babel_loader_lib_index_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_13_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_script_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_script_lang_js___WEBPACK_IMPORTED_MODULE_0___default.a); 

/***/ }),

/***/ 128:
/*!**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/babel-loader/lib!./node_modules/@dcloudio/vue-cli-plugin-uni/packages/webpack-preprocess-loader??ref--13-1!./node_modules/@dcloudio/webpack-uni-mp-loader/lib/script.js!./node_modules/@dcloudio/vue-cli-plugin-uni/packages/vue-loader/lib??vue-loader-options!./node_modules/@dcloudio/webpack-uni-mp-loader/lib/style.js!D:/CommonDataAndInformation/永远期待/永远期待2.0/AI时代/全栈学习计划——书魂管理系统及微信小程序读者端/week10-12（4.27开始）/project/book-mall/mini-program/pages/order-detail/order-detail.vue?vue&type=script&lang=js& ***!
  \**************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* WEBPACK VAR INJECTION */(function(uni) {

var _interopRequireDefault = __webpack_require__(/*! @babel/runtime/helpers/interopRequireDefault */ 4);
Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;
var _regenerator = _interopRequireDefault(__webpack_require__(/*! @babel/runtime/regenerator */ 44));
var _defineProperty2 = _interopRequireDefault(__webpack_require__(/*! @babel/runtime/helpers/defineProperty */ 11));
var _asyncToGenerator2 = _interopRequireDefault(__webpack_require__(/*! @babel/runtime/helpers/asyncToGenerator */ 46));
var _order = __webpack_require__(/*! ../../api/order.js */ 111);
var _comment = __webpack_require__(/*! ../../api/comment.js */ 129);
var _image = __webpack_require__(/*! ../../utils/image.js */ 50);
var _methods;
function _createForOfIteratorHelper(o, allowArrayLike) { var it = typeof Symbol !== "undefined" && o[Symbol.iterator] || o["@@iterator"]; if (!it) { if (Array.isArray(o) || (it = _unsupportedIterableToArray(o)) || allowArrayLike && o && typeof o.length === "number") { if (it) o = it; var i = 0; var F = function F() {}; return { s: F, n: function n() { if (i >= o.length) return { done: true }; return { done: false, value: o[i++] }; }, e: function e(_e) { throw _e; }, f: F }; } throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); } var normalCompletion = true, didErr = false, err; return { s: function s() { it = it.call(o); }, n: function n() { var step = it.next(); normalCompletion = step.done; return step; }, e: function e(_e2) { didErr = true; err = _e2; }, f: function f() { try { if (!normalCompletion && it.return != null) it.return(); } finally { if (didErr) throw err; } } }; }
function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }
function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }
function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); enumerableOnly && (symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; })), keys.push.apply(keys, symbols); } return keys; }
function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = null != arguments[i] ? arguments[i] : {}; i % 2 ? ownKeys(Object(source), !0).forEach(function (key) { (0, _defineProperty2.default)(target, key, source[key]); }) : Object.getOwnPropertyDescriptors ? Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)) : ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } return target; }
var _default = {
  data: function data() {
    return {
      orderId: null,
      order: {},
      showCommentPopup: false,
      currentCommentItem: null,
      autoOpenComment: false,
      commentForm: {
        rating: 5,
        content: "",
        images: []
      },
      submitting: false,
      userCommentedItems: new Set()
    };
  },
  computed: {
    statusIcon: function statusIcon() {
      var status = this.order.orderStatus || this.order.status;
      var iconMap = {
        待付款: "💳",
        待发货: "📦",
        待收货: "🚚",
        待评价: "⭐",
        交易完成: "✅",
        已完成: "✅",
        订单已取消: "❌",
        已取消: "❌",
        退款处理中: "💰",
        退款中: "💰",
        已退款: "💵"
      };
      return iconMap[status] || "❓";
    },
    statusText: function statusText() {
      var status = this.order.orderStatus || this.order.status;
      var map = {
        待付款: "待支付",
        待发货: "待发货",
        待收货: "待收货",
        待评价: "待评价",
        交易完成: "已完成",
        已完成: "已完成",
        订单已取消: "已取消",
        已取消: "已取消",
        退款处理中: "退款中",
        退款中: "退款中",
        已退款: "已退款"
      };
      return map[status] || status || "未知状态";
    },
    formattedTotalAmount: function formattedTotalAmount() {
      var amount = this.order.totalAmount;
      if (amount === null || amount === undefined || amount === "") {
        return "0.00";
      }
      var num = typeof amount === "number" ? amount : parseFloat(amount);
      return isNaN(num) ? "0.00" : num.toFixed(2);
    },
    formattedFreight: function formattedFreight() {
      return "0.00";
    },
    formattedActualPayment: function formattedActualPayment() {
      var amount = this.order.totalAmount;
      if (amount === null || amount === undefined || amount === "") {
        return "0.00";
      }
      var num = typeof amount === "number" ? amount : parseFloat(amount);
      return isNaN(num) ? "0.00" : num.toFixed(2);
    },
    orderItems: function orderItems() {
      if (this.order.items && this.order.items.length > 0) {
        return this.order.items;
      }
      return [];
    },
    showBottomBar: function showBottomBar() {
      var status = this.order.orderStatus || this.order.status;
      var hiddenStatuses = ["已取消", "已退款"];
      return !hiddenStatuses.includes(status);
    },
    hasPendingShipItems: function hasPendingShipItems() {
      if (!this.orderItems || this.orderItems.length === 0) return false;
      return this.orderItems.some(function (item) {
        return item.status === "待发货";
      });
    },
    hasRefundableItems: function hasRefundableItems() {
      if (!this.orderItems || this.orderItems.length === 0) return false;
      var refundableStatuses = ["待发货", "待收货", "待评价"];
      return this.orderItems.some(function (item) {
        return refundableStatuses.includes(item.status);
      });
    },
    hasRefundingItems: function hasRefundingItems() {
      if (!this.orderItems || this.orderItems.length === 0) return false;
      return this.orderItems.some(function (item) {
        return item.status === "退款中";
      });
    },
    hasPendingReceiveItems: function hasPendingReceiveItems() {
      if (!this.orderItems || this.orderItems.length === 0) return false;
      return this.orderItems.some(function (item) {
        return item.status === "待收货";
      });
    },
    hasPendingPayItem: function hasPendingPayItem() {
      if (!this.orderItems || this.orderItems.length === 0) return false;
      return this.orderItems.some(function (item) {
        return item.status === "待付款";
      });
    }
  },
  onLoad: function onLoad(options) {
    if (options.id) {
      if (options.id === "[object Object]") {
        uni.showToast({
          title: "订单信息错误",
          icon: "none"
        });
        setTimeout(function () {
          return uni.navigateBack();
        }, 1500);
        return;
      }
      this.orderId = options.id;
    }
    if (options.action === "comment") {
      this.autoOpenComment = true;
    }
    this.loadOrderDetail();
  },
  methods: (_methods = {
    getItemImage: function getItemImage(item) {
      if (item.coverImage) {
        return (0, _image.getImageUrl)(item.coverImage);
      }
      if (item.book && item.book.coverImage) {
        return (0, _image.getImageUrl)(item.book.coverImage);
      }
      return "/static/default-cover.png";
    },
    getItemPrice: function getItemPrice(item) {
      var price = item.price || item.bookPrice || item.unitPrice || item.book && item.book.price || 0;
      return parseFloat(price).toFixed(2);
    },
    loadOrderDetail: function loadOrderDetail() {
      var _this = this;
      return (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee() {
        var res, orderData, items, processedItems, firstUncommented;
        return _regenerator.default.wrap(function _callee$(_context) {
          while (1) {
            switch (_context.prev = _context.next) {
              case 0:
                _context.prev = 0;
                _context.next = 3;
                return (0, _order.getOrderDetail)(_this.orderId);
              case 3:
                res = _context.sent;
                if (res.code === 200 && res.data) {
                  orderData = res.data.order || res.data;
                  items = res.data.items || [];
                  processedItems = items.map(function (item) {
                    var status = item.status;
                    if (item.refundStatus === "申请中" || item.refundStatus === "处理中") {
                      status = "退款中";
                    } else if (item.refundStatus === "已通过" || item.refundStatus === "已完成") {
                      status = "已退款";
                    }
                    return _objectSpread(_objectSpread({}, item), {}, {
                      status: status,
                      coverImage: item.coverImage ? (0, _image.getImageUrl)(item.coverImage) : "/static/default-cover.png"
                    });
                  });
                  _this.order = _objectSpread(_objectSpread({}, orderData), {}, {
                    items: processedItems
                  });
                  if (_this.order.orderStatus === "待评价") {
                    if (_this.autoOpenComment && _this.order.items && _this.order.items.length > 0) {
                      firstUncommented = _this.order.items.find(function (item) {
                        return !item.commented;
                      });
                      if (firstUncommented) {
                        _this.openCommentPopup(firstUncommented);
                      }
                    }
                  }
                }
                _context.next = 11;
                break;
              case 7:
                _context.prev = 7;
                _context.t0 = _context["catch"](0);
                console.error("加载订单详情失败:", _context.t0);
                uni.showToast({
                  title: "加载失败",
                  icon: "none"
                });
              case 11:
              case "end":
                return _context.stop();
            }
          }
        }, _callee, null, [[0, 7]]);
      }))();
    },
    formatDate: function formatDate(date) {
      if (!date) return "";
      var d = new Date(date);
      return "".concat(d.getFullYear(), "-").concat(String(d.getMonth() + 1).padStart(2, "0"), "-").concat(String(d.getDate()).padStart(2, "0"), " ").concat(String(d.getHours()).padStart(2, "0"), ":").concat(String(d.getMinutes()).padStart(2, "0"));
    },
    formatAmount: function formatAmount(amount) {
      if (amount === null || amount === undefined || amount === "") {
        return "0.00";
      }
      var num = typeof amount === "number" ? amount : parseFloat(amount);
      return isNaN(num) ? "0.00" : num.toFixed(2);
    },
    getItemStatusText: function getItemStatusText(status) {
      var commented = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : false;
      if (!status) {
        return "未知";
      }
      if (status === "待评价" && commented) {
        return "已完成";
      }
      var map = {
        待付款: "待付款",
        待发货: "待发货",
        待收货: "待收货",
        待评价: "待评价",
        已完成: "已完成",
        退款中: "退款中",
        已退款: "已退款",
        已取消: "已取消"
      };
      return map[status] || status;
    },
    getDisplayStatus: function getDisplayStatus(item) {
      if (item.status === "待评价" && item.commented) {
        return "已完成";
      }
      return item.status;
    },
    copyOrderNo: function copyOrderNo() {
      var orderNo = this.order.orderNumber || this.order.orderNo;
      if (!orderNo) {
        uni.showToast({
          title: "订单号不存在",
          icon: "none"
        });
        return;
      }
      uni.setClipboardData({
        data: orderNo,
        success: function success() {
          setTimeout(function () {
            uni.showToast({
              title: "订单号已复制",
              icon: "success",
              duration: 1500,
              mask: true
            });
          }, 0);
        }
      });
    },
    goToBookDetail: function goToBookDetail(bookId) {
      uni.navigateTo({
        url: "/pages/book-detail/book-detail?id=".concat(bookId)
      });
    },
    cancelOrder: function cancelOrder() {
      var _this2 = this;
      return (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee2() {
        var res;
        return _regenerator.default.wrap(function _callee2$(_context2) {
          while (1) {
            switch (_context2.prev = _context2.next) {
              case 0:
                _context2.next = 2;
                return new Promise(function (resolve) {
                  uni.showModal({
                    title: "提示",
                    content: "确定要取消该订单吗？",
                    success: function success(modalRes) {
                      resolve(modalRes.confirm);
                    }
                  });
                });
              case 2:
                res = _context2.sent;
                if (!res) {
                  _context2.next = 14;
                  break;
                }
                _context2.prev = 4;
                _context2.next = 7;
                return (0, _order.cancelOrder)(_this2.orderId);
              case 7:
                uni.showToast({
                  title: "订单已取消",
                  icon: "success"
                });
                setTimeout(function () {
                  uni.navigateBack();
                }, 1500);
                _context2.next = 14;
                break;
              case 11:
                _context2.prev = 11;
                _context2.t0 = _context2["catch"](4);
                console.error("取消订单失败:", _context2.t0);
              case 14:
              case "end":
                return _context2.stop();
            }
          }
        }, _callee2, null, [[4, 11]]);
      }))();
    },
    confirmReceive: function confirmReceive() {
      var _this3 = this;
      return (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee3() {
        var res;
        return _regenerator.default.wrap(function _callee3$(_context3) {
          while (1) {
            switch (_context3.prev = _context3.next) {
              case 0:
                _context3.next = 2;
                return new Promise(function (resolve) {
                  uni.showModal({
                    title: "提示",
                    content: "确认已收到货物吗？",
                    success: function success(modalRes) {
                      resolve(modalRes.confirm);
                    }
                  });
                });
              case 2:
                res = _context3.sent;
                if (!res) {
                  _context3.next = 14;
                  break;
                }
                _context3.prev = 4;
                _context3.next = 7;
                return (0, _order.confirmReceive)(_this3.orderId);
              case 7:
                uni.showToast({
                  title: "确认收货成功",
                  icon: "success"
                });
                _this3.loadOrderDetail();
                _context3.next = 14;
                break;
              case 11:
                _context3.prev = 11;
                _context3.t0 = _context3["catch"](4);
                console.error("确认收货失败:", _context3.t0);
              case 14:
              case "end":
                return _context3.stop();
            }
          }
        }, _callee3, null, [[4, 11]]);
      }))();
    },
    applyRefund: function applyRefund() {
      uni.navigateTo({
        url: "/subpkg/refund-apply/refund-apply?orderId=".concat(this.orderId)
      });
    },
    remindShipForItem: function remindShipForItem(item) {
      var _this4 = this;
      uni.showModal({
        title: "提醒发货",
        content: "\u786E\u5B9A\u63D0\u9192\u5546\u5BB6\u53D1\u8D27 \"".concat(item.bookName || "该商品", "\" \u5417\uFF1F"),
        success: function () {
          var _success = (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee4(res) {
            return _regenerator.default.wrap(function _callee4$(_context4) {
              while (1) {
                switch (_context4.prev = _context4.next) {
                  case 0:
                    if (!res.confirm) {
                      _context4.next = 11;
                      break;
                    }
                    _context4.prev = 1;
                    _context4.next = 4;
                    return (0, _order.remindShip)(_this4.orderId);
                  case 4:
                    uni.showToast({
                      title: "已提醒商家发货",
                      icon: "success"
                    });
                    _context4.next = 11;
                    break;
                  case 7:
                    _context4.prev = 7;
                    _context4.t0 = _context4["catch"](1);
                    console.error("提醒发货失败:", _context4.t0);
                    uni.showToast({
                      title: "提醒失败，请重试",
                      icon: "none"
                    });
                  case 11:
                  case "end":
                    return _context4.stop();
                }
              }
            }, _callee4, null, [[1, 7]]);
          }));
          function success(_x) {
            return _success.apply(this, arguments);
          }
          return success;
        }()
      });
    }
  }, (0, _defineProperty2.default)(_methods, "applyRefund", function applyRefund() {
    uni.navigateTo({
      url: "/subpkg/refund-apply/refund-apply?orderId=".concat(this.orderId)
    });
  }), (0, _defineProperty2.default)(_methods, "applyRefundForItem", function applyRefundForItem(item) {
    if (item.status === "退款中") {
      uni.showModal({
        title: "退款状态",
        content: "\u5546\u54C1 \"".concat(item.bookName || "该商品", "\" \u6B63\u5728\u9000\u6B3E\u5904\u7406\u4E2D\uFF0C\u8BF7\u8010\u5FC3\u7B49\u5F85\u3002"),
        showCancel: false
      });
      return;
    }
    uni.navigateTo({
      url: "/subpkg/refund-apply/refund-apply?orderId=".concat(this.orderId, "&bookId=").concat(item.id)
    });
  }), (0, _defineProperty2.default)(_methods, "viewRefundDetail", function viewRefundDetail(item) {
    uni.navigateTo({
      url: "/subpkg/refund-detail/refund-detail?orderItemId=".concat(item.id)
    });
  }), (0, _defineProperty2.default)(_methods, "handleStatusClick", function handleStatusClick(item) {
    if (item.status === "待收货" && item.expressNo) {
      this.showExpressInfo(item);
    }
  }), (0, _defineProperty2.default)(_methods, "showExpressInfo", function showExpressInfo(item) {
    if (!item.expressNo) return;
    uni.showModal({
      title: "物流信息",
      content: "".concat(item.expressCompany || "快递", "\uFF1A").concat(item.expressNo),
      showCancel: true,
      confirmText: "复制单号",
      success: function success(res) {
        if (res.confirm) {
          uni.setClipboardData({
            data: item.expressNo,
            success: function success() {
              uni.showToast({
                title: "已复制快递单号",
                icon: "success"
              });
            }
          });
        }
      }
    });
  }), (0, _defineProperty2.default)(_methods, "payOrder", function payOrder() {
    var _this5 = this;
    uni.showModal({
      title: "确认支付",
      content: "\u786E\u8BA4\u652F\u4ED8 \xA5".concat(this.formattedActualPayment, "\uFF1F\n\n\u652F\u6301\u5FAE\u4FE1\u652F\u4ED8"),
      confirmText: "微信支付",
      success: function () {
        var _success2 = (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee5(modalRes) {
          var res;
          return _regenerator.default.wrap(function _callee5$(_context5) {
            while (1) {
              switch (_context5.prev = _context5.next) {
                case 0:
                  if (!modalRes.confirm) {
                    _context5.next = 15;
                    break;
                  }
                  uni.showLoading({
                    title: "正在发起支付..."
                  });
                  _context5.prev = 2;
                  _context5.next = 5;
                  return (0, _order.payOrder)(_this5.orderId);
                case 5:
                  res = _context5.sent;
                  uni.hideLoading();
                  if (res.code === 200) {
                    uni.showToast({
                      title: "支付成功",
                      icon: "success"
                    });
                    setTimeout(function () {
                      _this5.loadOrderDetail();
                    }, 1500);
                  } else {
                    uni.showToast({
                      title: res.message || "支付失败",
                      icon: "none"
                    });
                  }
                  _context5.next = 15;
                  break;
                case 10:
                  _context5.prev = 10;
                  _context5.t0 = _context5["catch"](2);
                  uni.hideLoading();
                  console.error("支付失败:", _context5.t0);
                  uni.showToast({
                    title: "支付失败，请重试",
                    icon: "none"
                  });
                case 15:
                case "end":
                  return _context5.stop();
              }
            }
          }, _callee5, null, [[2, 10]]);
        }));
        function success(_x2) {
          return _success2.apply(this, arguments);
        }
        return success;
      }()
    });
  }), (0, _defineProperty2.default)(_methods, "checkUserComments", function checkUserComments() {
    var _this6 = this;
    return (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee6() {
      var userInfo, res;
      return _regenerator.default.wrap(function _callee6$(_context6) {
        while (1) {
          switch (_context6.prev = _context6.next) {
            case 0:
              userInfo = uni.getStorageSync("userInfo");
              if (!(!userInfo || !userInfo.id)) {
                _context6.next = 3;
                break;
              }
              return _context6.abrupt("return");
            case 3:
              _context6.prev = 3;
              _context6.next = 6;
              return (0, _comment.getCommentsByUserId)(userInfo.id);
            case 6:
              res = _context6.sent;
              if (res.code === 200 && res.data) {
                res.data.forEach(function (comment) {
                  _this6.userCommentedItems.add(comment.bookId);
                });
                _this6.updateItemsCommentStatus();
              }
              _context6.next = 13;
              break;
            case 10:
              _context6.prev = 10;
              _context6.t0 = _context6["catch"](3);
              console.error("获取用户评论失败:", _context6.t0);
            case 13:
            case "end":
              return _context6.stop();
          }
        }
      }, _callee6, null, [[3, 10]]);
    }))();
  }), (0, _defineProperty2.default)(_methods, "updateItemsCommentStatus", function updateItemsCommentStatus() {
    var _this7 = this;
    if (!this.order.items) return;
    this.order.items.forEach(function (item) {
      _this7.$set(item, "commented", _this7.userCommentedItems.has(item.bookId));
    });
  }), (0, _defineProperty2.default)(_methods, "openCommentPopup", function openCommentPopup(item) {
    this.currentCommentItem = item;
    this.commentForm = {
      rating: 5,
      content: "",
      images: []
    };
    this.showCommentPopup = true;
  }), (0, _defineProperty2.default)(_methods, "closeCommentPopup", function closeCommentPopup() {
    this.showCommentPopup = false;
    this.currentCommentItem = null;
  }), (0, _defineProperty2.default)(_methods, "setRating", function setRating(star) {
    this.commentForm.rating = star;
  }), (0, _defineProperty2.default)(_methods, "insertFormat", function insertFormat(type) {
    var formats = {
      bold: "<b>加粗文字</b>",
      italic: "<i>斜体文字</i>",
      underline: "<u>下划线文字</u>",
      br: "\n"
    };
    this.commentForm.content += formats[type] || "";
  }), (0, _defineProperty2.default)(_methods, "clearFormat", function clearFormat() {
    this.commentForm.content = "";
  }), (0, _defineProperty2.default)(_methods, "chooseImage", function chooseImage() {
    var _this8 = this;
    if (this.commentForm.images.length >= 3) {
      uni.showToast({
        title: "最多上传3张图片",
        icon: "none"
      });
      return;
    }
    uni.chooseImage({
      count: 3 - this.commentForm.images.length,
      sizeType: ["compressed"],
      sourceType: ["album", "camera"],
      success: function () {
        var _success3 = (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee7(res) {
          var _iterator, _step, tempFilePath, uploadRes;
          return _regenerator.default.wrap(function _callee7$(_context7) {
            while (1) {
              switch (_context7.prev = _context7.next) {
                case 0:
                  _iterator = _createForOfIteratorHelper(res.tempFilePaths);
                  _context7.prev = 1;
                  _iterator.s();
                case 3:
                  if ((_step = _iterator.n()).done) {
                    _context7.next = 22;
                    break;
                  }
                  tempFilePath = _step.value;
                  if (!(_this8.commentForm.images.length >= 3)) {
                    _context7.next = 7;
                    break;
                  }
                  return _context7.abrupt("break", 22);
                case 7:
                  uni.showLoading({
                    title: "上传中..."
                  });
                  _context7.prev = 8;
                  _context7.next = 11;
                  return _this8.uploadImage(tempFilePath);
                case 11:
                  uploadRes = _context7.sent;
                  _this8.commentForm.images.push(uploadRes);
                  uni.hideLoading();
                  _context7.next = 20;
                  break;
                case 16:
                  _context7.prev = 16;
                  _context7.t0 = _context7["catch"](8);
                  uni.hideLoading();
                  uni.showToast({
                    title: "上传失败",
                    icon: "none"
                  });
                case 20:
                  _context7.next = 3;
                  break;
                case 22:
                  _context7.next = 27;
                  break;
                case 24:
                  _context7.prev = 24;
                  _context7.t1 = _context7["catch"](1);
                  _iterator.e(_context7.t1);
                case 27:
                  _context7.prev = 27;
                  _iterator.f();
                  return _context7.finish(27);
                case 30:
                case "end":
                  return _context7.stop();
              }
            }
          }, _callee7, null, [[1, 24, 27, 30], [8, 16]]);
        }));
        function success(_x3) {
          return _success3.apply(this, arguments);
        }
        return success;
      }(),
      fail: function fail() {
        // 用户取消选择
      }
    });
  }), (0, _defineProperty2.default)(_methods, "uploadImage", function uploadImage(filePath) {
    return new Promise(function (resolve, reject) {
      var userInfo = uni.getStorageSync("userInfo");
      var userId = userInfo ? userInfo.id : "unknown";
      var timestamp = Date.now();
      var randomStr = Math.random().toString(36).substr(2, 9);
      var fileName = "comment_".concat(userId, "_").concat(timestamp, "_").concat(randomStr, ".jpg");
      uni.uploadFile({
        url: "".concat(uni.getStorageSync("baseUrl") || getApp().globalData.baseUrl, "/upload/image"),
        filePath: filePath,
        name: "file",
        formData: {
          folder: "comments"
        },
        success: function success(uploadRes) {
          try {
            var data = JSON.parse(uploadRes.data);
            if (data.code === 200 && data.url) {
              resolve(data.url);
            } else {
              reject(new Error(data.msg || "上传失败"));
            }
          } catch (e) {
            reject(e);
          }
        },
        fail: function fail(err) {
          reject(err);
        }
      });
    });
  }), (0, _defineProperty2.default)(_methods, "deleteImage", function deleteImage(index) {
    this.commentForm.images.splice(index, 1);
  }), (0, _defineProperty2.default)(_methods, "submitComment", function submitComment() {
    var _this9 = this;
    return (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee8() {
      var userInfo;
      return _regenerator.default.wrap(function _callee8$(_context8) {
        while (1) {
          switch (_context8.prev = _context8.next) {
            case 0:
              if (_this9.commentForm.content.trim()) {
                _context8.next = 3;
                break;
              }
              uni.showToast({
                title: "请输入评价内容",
                icon: "none"
              });
              return _context8.abrupt("return");
            case 3:
              userInfo = uni.getStorageSync("userInfo");
              if (!(!userInfo || !userInfo.id)) {
                _context8.next = 7;
                break;
              }
              uni.showToast({
                title: "请先登录",
                icon: "none"
              });
              return _context8.abrupt("return");
            case 7:
              _this9.submitting = true;
              _context8.prev = 8;
              _context8.next = 11;
              return (0, _comment.addComment)({
                bookId: _this9.currentCommentItem.bookId,
                userId: userInfo.id,
                rating: _this9.commentForm.rating,
                content: _this9.commentForm.content,
                orderId: _this9.order.id,
                images: _this9.commentForm.images.length > 0 ? _this9.commentForm.images.join(",") : ""
              });
            case 11:
              uni.showToast({
                title: "评价成功",
                icon: "success"
              });
              _this9.userCommentedItems.add(_this9.currentCommentItem.bookId);
              _this9.closeCommentPopup();
              _this9.order.items.forEach(function (item) {
                item.commented = _this9.userCommentedItems.has(item.bookId);
              });
              _context8.prev = 15;
              _context8.next = 18;
              return (0, _order.completeOrder)(_this9.order.id);
            case 18:
              _context8.next = 23;
              break;
            case 20:
              _context8.prev = 20;
              _context8.t0 = _context8["catch"](15);
              console.error("更新后端状态失败", _context8.t0);
            case 23:
              setTimeout(function () {
                _this9.loadOrderDetail();
              }, 500);
              _context8.next = 30;
              break;
            case 26:
              _context8.prev = 26;
              _context8.t1 = _context8["catch"](8);
              console.error("提交评价失败:", _context8.t1);
              uni.showToast({
                title: "评价失败",
                icon: "none"
              });
            case 30:
              _context8.prev = 30;
              _this9.submitting = false;
              return _context8.finish(30);
            case 33:
            case "end":
              return _context8.stop();
          }
        }
      }, _callee8, null, [[8, 26, 30, 33], [15, 20]]);
    }))();
  }), _methods)
};
exports.default = _default;
/* WEBPACK VAR INJECTION */}.call(this, __webpack_require__(/*! ./node_modules/@dcloudio/uni-mp-weixin/dist/index.js */ 2)["default"]))

/***/ }),

/***/ 130:
/*!***************************************************************************************************************************************************************************************************************************!*\
  !*** D:/CommonDataAndInformation/永远期待/永远期待2.0/AI时代/全栈学习计划——书魂管理系统及微信小程序读者端/week10-12（4.27开始）/project/book-mall/mini-program/pages/order-detail/order-detail.vue?vue&type=style&index=0&id=d80893f4&scoped=true&lang=css& ***!
  \***************************************************************************************************************************************************************************************************************************/
/*! no static exports found */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_mini_css_extract_plugin_dist_loader_js_ref_6_oneOf_1_0_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_css_loader_dist_cjs_js_ref_6_oneOf_1_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_loaders_stylePostLoader_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_6_oneOf_1_2_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_postcss_loader_src_index_js_ref_6_oneOf_1_3_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_style_index_0_id_d80893f4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! -!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/mini-css-extract-plugin/dist/loader.js??ref--6-oneOf-1-0!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/css-loader/dist/cjs.js??ref--6-oneOf-1-1!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/vue-cli-plugin-uni/packages/vue-loader/lib/loaders/stylePostLoader.js!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/vue-cli-plugin-uni/packages/webpack-preprocess-loader??ref--6-oneOf-1-2!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/postcss-loader/src??ref--6-oneOf-1-3!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/vue-cli-plugin-uni/packages/vue-loader/lib??vue-loader-options!../../../../../../../../../../../MostUsedSoftware/HBuilderX.5.07.2026041006/HBuilderX/plugins/uniapp-cli/node_modules/@dcloudio/webpack-uni-mp-loader/lib/style.js!./order-detail.vue?vue&type=style&index=0&id=d80893f4&scoped=true&lang=css& */ 131);
/* harmony import */ var _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_mini_css_extract_plugin_dist_loader_js_ref_6_oneOf_1_0_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_css_loader_dist_cjs_js_ref_6_oneOf_1_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_loaders_stylePostLoader_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_6_oneOf_1_2_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_postcss_loader_src_index_js_ref_6_oneOf_1_3_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_style_index_0_id_d80893f4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0___default = /*#__PURE__*/__webpack_require__.n(_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_mini_css_extract_plugin_dist_loader_js_ref_6_oneOf_1_0_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_css_loader_dist_cjs_js_ref_6_oneOf_1_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_loaders_stylePostLoader_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_6_oneOf_1_2_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_postcss_loader_src_index_js_ref_6_oneOf_1_3_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_style_index_0_id_d80893f4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0__);
/* harmony reexport (unknown) */ for(var __WEBPACK_IMPORT_KEY__ in _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_mini_css_extract_plugin_dist_loader_js_ref_6_oneOf_1_0_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_css_loader_dist_cjs_js_ref_6_oneOf_1_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_loaders_stylePostLoader_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_6_oneOf_1_2_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_postcss_loader_src_index_js_ref_6_oneOf_1_3_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_style_index_0_id_d80893f4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0__) if(["default"].indexOf(__WEBPACK_IMPORT_KEY__) < 0) (function(key) { __webpack_require__.d(__webpack_exports__, key, function() { return _MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_mini_css_extract_plugin_dist_loader_js_ref_6_oneOf_1_0_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_css_loader_dist_cjs_js_ref_6_oneOf_1_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_loaders_stylePostLoader_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_6_oneOf_1_2_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_postcss_loader_src_index_js_ref_6_oneOf_1_3_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_style_index_0_id_d80893f4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0__[key]; }) }(__WEBPACK_IMPORT_KEY__));
 /* harmony default export */ __webpack_exports__["default"] = (_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_mini_css_extract_plugin_dist_loader_js_ref_6_oneOf_1_0_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_css_loader_dist_cjs_js_ref_6_oneOf_1_1_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_loaders_stylePostLoader_js_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_webpack_preprocess_loader_index_js_ref_6_oneOf_1_2_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_postcss_loader_src_index_js_ref_6_oneOf_1_3_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_vue_cli_plugin_uni_packages_vue_loader_lib_index_js_vue_loader_options_MostUsedSoftware_HBuilderX_5_07_2026041006_HBuilderX_plugins_uniapp_cli_node_modules_dcloudio_webpack_uni_mp_loader_lib_style_js_order_detail_vue_vue_type_style_index_0_id_d80893f4_scoped_true_lang_css___WEBPACK_IMPORTED_MODULE_0___default.a); 

/***/ }),

/***/ 131:
/*!*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************!*\
  !*** ./node_modules/mini-css-extract-plugin/dist/loader.js??ref--6-oneOf-1-0!./node_modules/css-loader/dist/cjs.js??ref--6-oneOf-1-1!./node_modules/@dcloudio/vue-cli-plugin-uni/packages/vue-loader/lib/loaders/stylePostLoader.js!./node_modules/@dcloudio/vue-cli-plugin-uni/packages/webpack-preprocess-loader??ref--6-oneOf-1-2!./node_modules/postcss-loader/src??ref--6-oneOf-1-3!./node_modules/@dcloudio/vue-cli-plugin-uni/packages/vue-loader/lib??vue-loader-options!./node_modules/@dcloudio/webpack-uni-mp-loader/lib/style.js!D:/CommonDataAndInformation/永远期待/永远期待2.0/AI时代/全栈学习计划——书魂管理系统及微信小程序读者端/week10-12（4.27开始）/project/book-mall/mini-program/pages/order-detail/order-detail.vue?vue&type=style&index=0&id=d80893f4&scoped=true&lang=css& ***!
  \*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

// extracted by mini-css-extract-plugin
    if(false) { var cssReload; }
  

/***/ })

},[[123,"common/runtime","common/vendor"]]]);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/order-detail/order-detail.js.map