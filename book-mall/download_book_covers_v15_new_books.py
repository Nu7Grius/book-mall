"""
图书封面下载脚本 v15.0 - 新书单版
综合使用 Hardcover API（获取ISBN） + Open Library（下载封面）
保存到 2026-05-07 文件夹
"""

import os
import time
import requests
from urllib.parse import quote
import json

# Hardcover.app API Key
HARDCOPY_API_KEY = "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJIYXJkY292ZXIiLCJ2ZXJzaW9uIjoiOCIsImp0aSI6IjE3ZTU4YzkyLTg0NWQtNGQ0Mi04Y2M0LTQ2YWNjYzEwZmNlNCIsImFwcGxpY2F0aW9uSWQiOjIsInN1YiI6Ijk2ODMxIiwiYXVkIjoiMSIsImlkIjoiOTY4MzEiLCJsb2dnZWRJbiI6dHJ1ZSwiaWF0IjoxNzc4MDYwMTY5LCJleHAiOjE4MDk1OTYxNjksImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS1yb2xlIjoidXNlciIsIlgtaGFzdXJhLXVzZXItaWQiOiI5NjgzMX19LCJ1c2VyIjp7ImlkIjo5NjgzMX19.NGF4bvlCCA9oy1wlji-Z6Yf_OmQOqYNn2D9T0eekdy0"

# 新的76本图书列表（精选容易下载到封面的书）
ALL_BOOKS = [
    # 编程与开发（20本）
    'Python Crash Course',
    'Clean Code',
    'The Pragmatic Programmer',
    'Design Patterns',
    'Code Complete',
    'Refactoring',
    'The Clean Coder',
    'Soft Skills',
    'Head First Java',
    'Head First Python',
    'Learning Python',
    'Fluent Python',
    'Effective Java',
    'Java Concurrency in Practice',
    'Thinking in Java',
    'JavaScript: The Good Parts',
    'You Don\'t Know JS',
    'Eloquent JavaScript',
    'The Node.js Handbook',
    'Pro Git',
    
    # 文学小说（15本）
    'To Kill a Mockingbird',
    '1984',
    'Animal Farm',
    'Brave New World',
    'The Great Gatsby',
    'The Catcher in the Rye',
    'Lord of the Flies',
    'Of Mice and Men',
    'The Alchemist',
    'The Kite Runner',
    'A Thousand Splendid Suns',
    'And Then There Were None',
    'Murder on the Orient Express',
    'The Da Vinci Code',
    'Gone Girl',
    
    # 历史与社会（10本）
    'Sapiens',
    'Homo Deus',
    'The Silk Roads',
    'Guns Germs and Steel',
    'The History of the Ancient World',
    'SPQR',
    'The Rise and Fall of the Third Reich',
    'The Diary of a Young Girl',
    'Steve Jobs',
    'Einstein',
    
    # 经济与管理（8本）
    'The Intelligent Investor',
    'A Random Walk Down Wall Street',
    'Thinking Fast and Slow',
    'Freakonomics',
    'Outliers',
    'The Black Swan',
    'Nudge',
    'Thinking Strategically',
    
    # 心理学与哲学（8本）
    'Man\'s Search for Meaning',
    'The Art of War',
    'Meditations',
    'The 48 Laws of Power',
    'How to Win Friends and Influence People',
    'The Power of Habit',
    'Atomic Habits',
    'Emotional Intelligence',
    
    # 科技与未来（5本）
    'The Innovators',
    'Zero to One',
    'The Lean Startup',
    'Good to Great',
    'Blue Ocean Strategy',
    
    # 儿童与教育（5本）
    'The Very Hungry Caterpillar',
    'Where the Wild Things Are',
    'Goodnight Moon',
    'The Giving Tree',
    'Charlotte\'s Web',
    
    # 艺术与设计（5本）
    'The Design of Everyday Things',
    'Steal Like an Artist',
    'Creative Confidence',
    'Typography That Works',
    'Color Theory',
]

OUTPUT_DIR = r'd:\CommonDataAndInformation\永远期待\永远期待2.0\AI时代\全栈学习计划——书魂管理系统及微信小程序读者端\week10-12（4.27开始）\project\book-mall\uploads\2026-05-07'

GRAPHQL_ENDPOINT = 'https://api.hardcover.app/v1/graphql'

HEADERS_HARDCOPY = {
    'User-Agent': 'BookMallDownloader/1.0',
    'Content-Type': 'application/json',
    'Authorization': f'Bearer {HARDCOPY_API_KEY}',
}

HEADERS_OL = {
    'User-Agent': 'BookMallDownloader/1.0',
    'Accept': 'application/json',
}

def sanitize_filename(name):
    invalid_chars = '<>:"/\\|?*'
    for char in invalid_chars:
        name = name.replace(char, '_')
    if len(name) > 80:
        name = name[:80]
    return name.strip() + '.jpg'

def get_isbn_from_hardcover(book_title):
    """从 Hardcover 获取 ISBN"""
    try:
        query = f'''
        query {{
          books(
            where: {{title: {{_eq: "{book_title}"}}}}
            limit: 1
          ) {{
            id
            title
            isbn
            isbn13
          }}
        }}
        '''
        
        response = requests.post(GRAPHQL_ENDPOINT, headers=HEADERS_HARDCOPY, json={"query": query}, timeout=20)
        
        if response.status_code == 200:
            data = response.json()
            if 'data' in data and data['data'] and data['data']['books']:
                book = data['data']['books'][0]
                isbn = book.get('isbn13') or book.get('isbn')
                if isbn:
                    return isbn
        return None
    except:
        return None

def download_from_openlibrary(isbn, output_path):
    """从 Open Library 通过 ISBN 下载封面"""
    try:
        urls = [
            f'https://covers.openlibrary.org/b/isbn/{isbn}-L.jpg',
            f'https://covers.openlibrary.org/b/isbn/{isbn}-M.jpg',
            f'https://covers.openlibrary.org/b/isbn/{isbn}-S.jpg',
        ]
        
        for url in urls:
            try:
                response = requests.get(url, headers=HEADERS_OL, timeout=20, stream=True)
                if response.status_code == 200 and 'image' in response.headers.get('Content-Type', ''):
                    with open(output_path, 'wb') as f:
                        for chunk in response.iter_content(chunk_size=8192):
                            if chunk:
                                f.write(chunk)
                    return True
            except:
                continue
        return False
    except:
        return False

def download_from_google_books(book_title, output_path):
    """从 Google Books 下载封面"""
    try:
        encoded_title = quote(book_title)
        search_url = f'https://www.googleapis.com/books/v1/volumes?q={encoded_title}&maxResults=1'
        
        response = requests.get(search_url, headers=HEADERS_OL, timeout=15)
        
        if response.status_code == 200:
            data = response.json()
            items = data.get('items', [])
            if items:
                volume_info = items[0].get('volumeInfo', {})
                image_links = volume_info.get('imageLinks', {})
                cover_url = (image_links.get('extraLarge') or 
                           image_links.get('large') or 
                           image_links.get('medium') or
                           image_links.get('thumbnail'))
                if cover_url:
                    cover_url = cover_url.replace('http://', 'https://').replace('zoom=1', 'zoom=2')
                    img_response = requests.get(cover_url, timeout=20, stream=True)
                    if img_response.status_code == 200 and 'image' in img_response.headers.get('Content-Type', ''):
                        with open(output_path, 'wb') as f:
                            for chunk in img_response.iter_content(chunk_size=8192):
                                if chunk:
                                    f.write(chunk)
                        return True
        return False
    except:
        return False

def download_book_cover(book_title):
    """下载图书封面"""
    filename = sanitize_filename(book_title)
    output_path = os.path.join(OUTPUT_DIR, filename)
    
    if os.path.exists(output_path):
        return 'skipped', '已存在'
    
    isbn = get_isbn_from_hardcover(book_title)
    if isbn:
        print(f"    ISBN: {isbn}", end=' ')
        if download_from_openlibrary(isbn, output_path):
            return 'success', 'Hardcover+OpenLibrary'
    
    print(f"    尝试 Google Books...", end=' ')
    if download_from_google_books(book_title, output_path):
        return 'success', 'Google Books'
    
    return 'failed', '未找到封面'

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    existing_files = os.listdir(OUTPUT_DIR)
    existing_count = len([f for f in existing_files if f.endswith('.jpg')])
    
    print("=" * 70)
    print("📚 图书封面下载脚本 v15.0 (新书单版)")
    print("=" * 70)
    print(f"📚 总图书数: {len(ALL_BOOKS)}")
    print(f"✅ 已有封面: {existing_count}")
    print(f"❌ 待下载: {len(ALL_BOOKS) - existing_count}")
    print(f"📁 保存目录: {OUTPUT_DIR}")
    print(f"🌐 数据源: Hardcover + Open Library + Google Books")
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
        print(f"[{i}/{len(missing_books)}] {book_title[:40]}...")
        
        status, info = download_book_cover(book_title)
        
        if status == 'success':
            print(f"    ✅ {info}\n")
            success_count += 1
            success_list.append(book_title)
        else:
            print(f"    ❌ {info}\n")
            fail_count += 1
            fail_list.append(book_title)
        
        time.sleep(1.2)
    
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
        for title in fail_list[:20]:
            print(f"  - {title}")

if __name__ == '__main__':
    main()
