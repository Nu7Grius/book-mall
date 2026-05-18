import Vue from 'vue'
import App from './App.vue'
import router from './router'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import request from './api/request'
import imageUrlMixin from './mixins/imageUrlMixin'

Vue.config.productionTip = false

Vue.use(ElementUI)

Vue.prototype.$http = request

Vue.mixin(imageUrlMixin)

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
