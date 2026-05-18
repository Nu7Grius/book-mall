// API 基础配置
// 注意：微信开发者工具无法访问 localhost，需要使用电脑的局域网IP
// 开发环境：请将下面的 IP 地址改为你的电脑在局域网中的IP地址
// 生产环境：请改为你的正式服务器域名（必须是 HTTPS）

const BASE_URL = 'http://192.168.1.2:8080'

export default {
	baseUrl: BASE_URL,
	imgUrl: BASE_URL,
	timeout: 10000
}
