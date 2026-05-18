/**
 * 富文本/HTML格式化工具
 */

/**
 * 处理富文本内容，转换为小程序可显示的格式
 * 保留段落和换行结构
 * @param {string} html 富文本内容
 * @returns {string} 处理后的文本
 */
export const formatRichText = (html) => {
	if (!html || typeof html !== 'string') return ''

	let text = html

	// 1. 将块级标签转换为换行
	// 处理 <p> 标签 - 保留内容并添加换行
	text = text.replace(/<p[^>]*>/gi, '\n')
	text = text.replace(/<\/p>/gi, '\n')

	// 处理 <div> 标签
	text = text.replace(/<div[^>]*>/gi, '\n')
	text = text.replace(/<\/div>/gi, '\n')

	// 处理 <br> 标签
	text = text.replace(/<br\s*\/?>/gi, '\n')

	// 处理 <li> 列表项
	text = text.replace(/<li[^>]*>/gi, '\n• ')
	text = text.replace(/<\/li>/gi, '')

	// 处理 <h1> 到 <h6> 标题
	text = text.replace(/<h[1-6][^>]*>/gi, '\n【')
	text = text.replace(/<\/h[1-6]>/gi, '】\n')

	// 2. 移除剩余的 HTML 标签
	text = text.replace(/<[^>]+>/g, '')

	// 3. 转换 HTML 实体
	text = text.replace(/&nbsp;/g, ' ')
	text = text.replace(/&amp;/g, '&')
	text = text.replace(/&lt;/g, '<')
	text = text.replace(/&gt;/g, '>')
	text = text.replace(/&quot;/g, '"')
	text = text.replace(/&#39;/g, "'")
	text = text.replace(/&ldquo;/g, '"')
	text = text.replace(/&rdquo;/g, '"')
	text = text.replace(/&lsquo;/g, "'")
	text = text.replace(/&rsquo;/g, "'")
	text = text.replace(/&mdash;/g, '—')
	text = text.replace(/&ndash;/g, '–')
	text = text.replace(/&middot;/g, '·')
	text = text.replace(/&hellip;/g, '...')
	text = text.replace(/&copy;/g, '©')
	text = text.replace(/&reg;/g, '®')
	text = text.replace(/&trade;/g, '™')

	// 4. 清理多余的空行（不超过2个连续换行）
	text = text.replace(/\n{3,}/g, '\n\n')

	// 5. 去除首尾空白
	text = text.trim()

	return text
}

/**
 * 处理富文本，保留换行符
 * @param {string} html 富文本内容
 * @returns {string} 处理后的文本
 */
export const formatRichTextWithBreak = (html) => {
	if (!html || typeof html !== 'string') return ''
	return formatRichText(html)
}

/**
 * 截断文本，添加省略号
 * @param {string} text 文本内容
 * @param {number} maxLength 最大长度
 * @param {boolean} preserveLines 是否保留换行
 * @returns {string} 截断后的文本
 */
export const truncateText = (text, maxLength = 100, preserveLines = false) => {
	if (!text || text.length <= maxLength) return text

	// 如果要保留换行
	if (preserveLines) {
		const lines = text.split('\n')
		let result = []
		let currentLength = 0

		for (const line of lines) {
			if (currentLength + line.length + 1 <= maxLength) {
				result.push(line)
				currentLength += line.length + 1
			} else {
				// 这一行需要截断
				const remaining = maxLength - currentLength - 1
				if (remaining > 10) { // 至少还能显示10个字符
					result.push(line.substring(0, remaining) + '...')
				}
				break
			}
		}

		return result.join('\n')
	}

	return text.substring(0, maxLength) + '...'
}

/**
 * 格式化简介文本（用于卡片展示）
 * 保留段落结构，截断长文本
 * @param {string} html 富文本内容
 * @param {number} maxLines 最大行数
 * @returns {string} 处理后的文本
 */
export const formatDescriptionForCard = (html, maxLines = 3) => {
	if (!html) return ''

	let text = formatRichText(html)

	// 按行分割
	const lines = text.split('\n').filter(line => line.trim())

	// 限制行数
	if (lines.length > maxLines) {
		text = lines.slice(0, maxLines).join('\n')
		// 如果最后一行太长，截断它
		const lastLine = lines[maxLines]
		if (lastLine && lastLine.length > 50) {
			text += '\n' + lastLine.substring(0, 50) + '...'
		} else if (lastLine) {
			text += '\n' + lastLine + '...'
		}
	} else {
		text = lines.join('\n')
	}

	return text
}

/**
 * 检查文本是否包含HTML标签
 * @param {string} text 文本内容
 * @returns {boolean}
 */
export const containsHtmlTags = (text) => {
	if (!text || typeof text !== 'string') return false
	return /<[^>]+>/.test(text)
}

export default {
	formatRichText,
	formatRichTextWithBreak,
	truncateText,
	formatDescriptionForCard,
	containsHtmlTags
}
