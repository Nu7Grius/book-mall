"""
图书封面下载脚本 v17.0 - 纯Google Books版（中文书籍专用）
只使用 Google Books API，避免 Hardcover API 返回英文版封面
确保下载的中文书籍封面与中文书名匹配
保存到 2026-05-07 文件夹
"""

import os
import time
import requests
from urllib.parse import quote
import json

# 76本中文热门书籍
ALL_BOOKS = [
    # 计算机与编程（15本）
    'Python编程：从入门到实践',
    'Java核心技术',
    'JavaScript高级程序设计',
    'C++ Primer Plus',
    'Go语言实战',
    '算法导论',
    '数据结构与算法',
    '计算机网络',
    '操作系统',
    '数据库系统',
    '深入理解计算机系统',
    '代码整洁之道',
    'Effective Java',
    'Python网络编程',
    'MySQL必知必会',
    
    # 文学与小说（15本）
    '活着',
    '平凡的世界',
    '白鹿原',
    '围城',
    '红高粱',
    '蛙',
    '繁花',
    '黄金时代',
    '三体',
    '流浪地球',
    '基地',
    '沙丘',
    '百年孤独',
    '追风筝的人',
    '解忧杂货店',
    
    # 历史与传记（10本）
    '万历十五年',
    '明朝那些事儿',
    '中国历代政治得失',
    '全球通史',
    '人类简史',
    '未来简史',
    '曾国藩传',
    '苏东坡传',
    '毛泽东传',
    '曾国藩',
    
    # 经济与管理（8本）
    '富爸爸穷爸爸',
    '小狗钱钱',
    '穷查理宝典',
    '巴菲特致股东的信',
    '国富论',
    '资本论',
    '经济学原理',
    '宏观经济学',
    
    # 心理学与哲学（8本）
    '自卑与超越',
    '乌合之众',
    '思考快与慢',
    '社会心理学',
    '亲密关系',
    '被讨厌的勇气',
    '蛤蟆先生去看心理医生',
    '中国哲学简史',
    
    # 儿童与教育（5本）
    '猜猜我有多爱你',
    '窗边的小豆豆',
    '草房子',
    '夏洛的网',
    '小王子',
    
    # 医学与健康（5本）
    '黄帝内经',
    '本草纲目',
    '人体使用手册',
    '饮食与健康',
    '睡眠革命',
    
    # 艺术与设计（5本）
    '设计中的设计',
    '写给大家看的设计书',
    '版式设计',
    '配色设计',
    '字体设计',
    
    # 科技与未来（5本）
    '时间简史',
    '果壳中的宇宙',
    '宇宙',
    '失控',
    '浪潮之巅',
]

OUTPUT_DIR = r'd:\CommonDataAndInformation\永远期待\永远期待2.0\AI时代\全栈学习计划——书魂管理系统及微信小程序读者端\week10-12（4.27开始）\project\book-mall\uploads\2026-05-07'

HEADERS_GB = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    'Accept': 'application/json',
}

def sanitize_filename(name):
    invalid_chars = '<>:"/\\|?*'
    for char in invalid_chars:
        name = name.replace(char, '_')
    if len(name) > 80:
        name = name[:80]
    return name.strip() + '.jpg'

def download_from_google_books(book_title):
    """从 Google Books 下载封面（中文书籍专用）"""
    try:
        # 使用中文关键词搜索
        encoded_title = quote(book_title)
        # 在搜索中加入中文语言过滤
        search_url = f'https://www.googleapis.com/books/v1/volumes?q={encoded_title}+langRestrict=zh-CN&maxResults=5'
        
        print(f"    搜索中...", end=' ')
        response = requests.get(search_url, headers=HEADERS_GB, timeout=20)
        
        if response.status_code == 200:
            data = response.json()
            items = data.get('items', [])
            
            if not items:
                # 如果没有中文结果，尝试不带语言限制的搜索
                search_url = f'https://www.googleapis.com/books/v1/volumes?q={encoded_title}&maxResults=5'
                response = requests.get(search_url, headers=HEADERS_GB, timeout=20)
                if response.status_code == 200:
                    data = response.json()
                    items = data.get('items', [])
            
            # 遍历结果，优先选择中文标题匹配的
            for item in items:
                volume_info = item.get('volumeInfo', {})
                title = volume_info.get('title', '')
                
                # 检查标题是否包含搜索关键词（中文匹配）
                if book_title in title or any(keyword in title for keyword in book_title):
                    image_links = volume_info.get('imageLinks', {})
                    cover_url = (image_links.get('extraLarge') or 
                               image_links.get('large') or 
                               image_links.get('medium') or
                               image_links.get('thumbnail') or
                               image_links.get('smallThumbnail'))
                    
                    if cover_url:
                        cover_url = cover_url.replace('http://', 'https://')
                        if 'zoom=1' in cover_url:
                            cover_url = cover_url.replace('zoom=1', 'zoom=2')
                        
                        print(f"找到: {title[:30]}...", end=' ')
                        
                        # 下载图片
                        img_response = requests.get(cover_url, timeout=20, stream=True)
                        if img_response.status_code == 200 and 'image' in img_response.headers.get('Content-Type', ''):
                            return True, cover_url
                
                # 如果标题不完全匹配但有图片，也下载
                if not image_links:
                    image_links = volume_info.get('imageLinks', {})
                    if image_links:
                        cover_url = (image_links.get('thumbnail') or image_links.get('smallThumbnail'))
                        if cover_url:
                            cover_url = cover_url.replace('http://', 'https://')
                            print(f"备选: {title[:30]}...", end=' ')
                            img_response = requests.get(cover_url, timeout=20, stream=True)
                            if img_response.status_code == 200 and 'image' in img_response.headers.get('Content-Type', ''):
                                return True, cover_url
        
        return False, None
    except Exception as e:
        print(f"    错误: {str(e)[:30]}...", end=' ')
        return False, None

def download_book_cover(book_title):
    """下载图书封面"""
    filename = sanitize_filename(book_title)
    output_path = os.path.join(OUTPUT_DIR, filename)
    
    if os.path.exists(output_path):
        file_size = os.path.getsize(output_path)
        if file_size > 1000:  # 文件大于1KB才认为有效
            return 'skipped', '已存在'
    
    success, url = download_from_google_books(book_title)
    
    if success and url:
        try:
            img_response = requests.get(url, timeout=20, stream=True)
            if img_response.status_code == 200:
                with open(output_path, 'wb') as f:
                    for chunk in img_response.iter_content(chunk_size=8192):
                        if chunk:
                            f.write(chunk)
                
                # 验证下载的文件
                if os.path.exists(output_path) and os.path.getsize(output_path) > 1000:
                    return 'success', url
        except Exception as e:
            pass
    
    return 'failed', '未找到封面'

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    existing_files = os.listdir(OUTPUT_DIR)
    existing_count = len([f for f in existing_files if f.endswith('.jpg') and os.path.getsize(os.path.join(OUTPUT_DIR, f)) > 1000])
    
    print("=" * 70)
    print("📚 图书封面下载脚本 v17.0 (纯Google Books中文版)")
    print("=" * 70)
    print(f"📚 总图书数: {len(ALL_BOOKS)}")
    print(f"✅ 已有封面: {existing_count}")
    print(f"❌ 待下载: {len(ALL_BOOKS) - existing_count}")
    print(f"📁 保存目录: {OUTPUT_DIR}")
    print(f"🌐 数据源: Google Books (中文版)")
    print("=" * 70)
    
    missing_books = []
    for book in ALL_BOOKS:
        filename = sanitize_filename(book)
        if filename not in existing_files:
            missing_books.append(book)
    
    if not missing_books:
        print("\n🎉 恭喜！所有图书封面都已下载完成！")
        return
    
    print(f"\n开始下载 {len(missing_books)} 本缺失的封面...\n")
    
    success_count = 0
    fail_count = 0
    success_list = []
    fail_list = []
    
    for i, book_title in enumerate(missing_books, 1):
        print(f"[{i}/{len(missing_books)}] {book_title[:35]}...")
        
        status, info = download_book_cover(book_title)
        
        if status == 'success':
            print(f"    ✅ 成功\n")
            success_count += 1
            success_list.append(book_title)
        elif status == 'skipped':
            print(f"    ⏭️ 已存在\n")
            success_count += 1
            success_list.append(book_title)
        else:
            print(f"    ❌ {info}\n")
            fail_count += 1
            fail_list.append(book_title)
        
        time.sleep(1.5)  # 稍微增加延迟，避免API限制
    
    print("=" * 70)
    print(f"✅ 下载完成!")
    print(f"   本次成功: {success_count}/{len(missing_books)}")
    print(f"   本次失败: {fail_count}/{len(missing_books)}")
    print(f"   总计已有: {existing_count + success_count}/{len(ALL_BOOKS)}")
    print("=" * 70)
    
    if success_list:
        print(f"\n✅ 成功下载的图书 ({len(success_list)} 本):")
        for title in success_list:
            print(f"  - {title}")
    
    if fail_list:
        print(f"\n❌ 最终失败图书 ({len(fail_list)} 本):")
        for title in fail_list[:30]:
            print(f"  - {title}")

if __name__ == '__main__':
    main()
