// 显示加载中
const showLoading = (title = '加载中...') => {
	uni.showLoading({
		title,
		mask: true
	})
}

// 隐藏加载
const hideLoading = () => {
	uni.hideLoading()
}

// 显示成功提示
const showSuccess = (title = '成功') => {
	uni.showToast({
		title,
		icon: 'success',
		duration: 1500
	})
}

// 显示错误提示
const showError = (title = '错误') => {
	uni.showToast({
		title,
		icon: 'none',
		duration: 2000
	})
}

// 确认对话框
const showConfirm = (content, title = '提示') => {
	return new Promise((resolve) => {
		uni.showModal({
			title,
			content,
			success: (res) => {
				resolve(res.confirm)
			}
		})
	})
}

// 格式化价格
const formatPrice = (price) => {
	return Number(price).toFixed(2)
}

// 格式化日期
const formatDate = (date, format = 'YYYY-MM-DD HH:mm:ss') => {
	if (!date) return ''
	const d = new Date(date)
	const year = d.getFullYear()
	const month = String(d.getMonth() + 1).padStart(2, '0')
	const day = String(d.getDate()).padStart(2, '0')
	const hours = String(d.getHours()).padStart(2, '0')
	const minutes = String(d.getMinutes()).padStart(2, '0')
	const seconds = String(d.getSeconds()).padStart(2, '0')
	
	return format
		.replace('YYYY', year)
		.replace('MM', month)
		.replace('DD', day)
		.replace('HH', hours)
		.replace('mm', minutes)
		.replace('ss', seconds)
}

// 获取相对时间
const getRelativeTime = (date) => {
	if (!date) return ''
	const now = new Date()
	const d = new Date(date)
	const diff = now - d
	const seconds = Math.floor(diff / 1000)
	const minutes = Math.floor(seconds / 60)
	const hours = Math.floor(minutes / 60)
	const days = Math.floor(hours / 24)
	
	if (days > 0) return `${days}天前`
	if (hours > 0) return `${hours}小时前`
	if (minutes > 0) return `${minutes}分钟前`
	return '刚刚'
}

export default {
	showLoading,
	hideLoading,
	showSuccess,
	showError,
	showConfirm,
	formatPrice,
	formatDate,
	getRelativeTime
}
