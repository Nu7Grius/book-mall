"""
测试 Hardcover API - 检查 editions 表的字段
"""

import requests
import json

# Hardcover.app API Key
HARDCOPY_API_KEY = "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJIYXJkY292ZXIiLCJ2ZXJzaW9uIjoiOCIsImp0aSI6IjE3ZTU4YzkyLTg0NWQtNGQ0Mi04Y2M0LTQ2YWNjYzEwZmNlNCIsImFwcGxpY2F0aW9uSWQiOjIsInN1YiI6Ijk2ODMxIiwiYXVkIjoiMSIsImlkIjoiOTY4MzEiLCJsb2dnZWRJbiI6dHJ1ZSwiaWF0IjoxNzc4MDYwMTY5LCJleHAiOjE4MDk1OTYxNjksImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS1yb2xlIjoidXNlciIsIlgtaGFzdXJhLXVzZXItaWQiOiI5NjgzMSJ9LCJ1c2VyIjp7ImlkIjo5NjgzMX19.NGF4bvlCCA9oy1wlji-Z6Yf_OmQOqYNn2D9T0eekdy0"

GRAPHQL_ENDPOINT = 'https://api.hardcover.app/v1/graphql'

HEADERS = {
    'User-Agent': 'BookMallDownloader/1.0',
    'Content-Type': 'application/json',
    'Authorization': f'Bearer {HARDCOPY_API_KEY}',
}

print("测试 Hardcover API - editions 表的正确字段")
print("=" * 70)

# 测试 editions 表的基本字段
print("\n1. 测试 editions 表的基本字段:")
print("-" * 70)

query1 = """
query {
  editions(limit: 1) {
    id
    title
  }
}
"""

response1 = requests.post(GRAPHQL_ENDPOINT, headers=HEADERS, json={"query": query1}, timeout=20)
result1 = response1.json()

if 'errors' in result1:
    print(f"错误: {result1['errors']}")
else:
    print("✅ editions 表可用!")
    if result1['data']['editions']:
        edition = result1['data']['editions'][0]
        print(f"示例: {edition}")

# 测试图片字段
print("\n\n2. 测试 editions 表的图片字段:")
print("-" * 70)

image_fields = [
    'smallImage',
    'mediumImage',
    'largeImage',
    'coverImage',
    'imageUrl',
    'image',
    'thumbnail',
]

for field in image_fields:
    query = f"""
    query {{
      editions(limit: 1) {{
        id
        title
        {field}
      }}
    }}
    """
    
    response = requests.post(GRAPHQL_ENDPOINT, headers=HEADERS, json={"query": query}, timeout=20)
    result = response.json()
    
    if 'errors' in result:
        print(f"❌ {field}: 不可用")
    else:
        print(f"✅ {field}: 可用!")
        if result['data']['editions']:
            value = result['data']['editions'][0].get(field)
            if value:
                print(f"   值: {str(value)[:80]}")
        break

# 测试通过 ISBN 关联
print("\n\n3. 测试通过 ISBN 搜索 editions:")
print("-" * 70)

query3 = """
query {
  editions(
    where: {isbn: {_eq: "9780062315007"}}
    limit: 1
  ) {
    id
    title
    smallImage
    mediumImage
    largeImage
    isbn
    isbn13
  }
}
"""

response3 = requests.post(GRAPHQL_ENDPOINT, headers=HEADERS, json={"query": query3}, timeout=20)
result3 = response3.json()

if 'errors' in result3:
    print(f"❌ 通过 ISBN 搜索失败")
    print(f"   错误: {result3['errors'][0]['message'][:60]}")
else:
    print("✅ 通过 ISBN 搜索成功!")
    if result3['data']['editions']:
        edition = result3['data']['editions'][0]
        print(f"   书名: {edition.get('title')}")
        print(f"   小图: {edition.get('smallImage', 'N/A')}")
        print(f"   中图: {edition.get('mediumImage', 'N/A')}")
        print(f"   大图: {edition.get('largeImage', 'N/A')}")

print("\n" + "=" * 70)
