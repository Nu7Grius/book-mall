// 图片URL处理工具
import config from '../config/index.js'

/**
 * 处理图片URL，返回完整的服务器地址
 * @param {string} url 图片路径，可以是相对路径或完整URL
 * @returns {string} 完整的图片URL
 */
export const getImageUrl = (url) => {
	if (!url || typeof url !== 'string') return ''

	// 清理特殊字符（反引号等）
	let cleanUrl = url.trim()
	if (cleanUrl.startsWith('`') && cleanUrl.endsWith('`')) {
		cleanUrl = cleanUrl.slice(1, -1)
	}
	cleanUrl = cleanUrl.trim()

	// 如果清理后为空，返回空字符串
	if (!cleanUrl) return ''

	// 如果已经是完整URL，直接返回
	if (cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://')) {
		return cleanUrl
	}

	// 如果是相对路径，拼接服务器地址
	if (cleanUrl.startsWith('/')) {
		return config.imgUrl + cleanUrl
	}

	// 其他情况，拼接服务器地址
	return config.imgUrl + '/' + cleanUrl
}

export default {
	getImageUrl
}
