"""
测试 Hardcover API 连接 - 多种认证方式测试
"""

import requests
import json

# Hardcover.app API Key
HARDCOPY_API_KEY = "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJIYXJkY292ZXIiLCJ2ZXJzaW9uIjoiOCIsImp0aSI6IjE3ZTU4YzkyLTg0NWQtNGQ0Mi04Y2M0LTQ2YWNjYzEwZmNlNCIsImFwcGxpY2F0aW9uSWQiOjIsInN1YiI6Ijk2ODMxIiwiYXVkIjoiMSIsImlkIjoiOTY4MzEiLCJsb2dnZWRJbiI6dHJ1ZSwiaWF0IjoxNzc4MDYwMTY5LCJleHAiOjE4MDk1OTYxNjksImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS1yb2xlIjoidXNlciIsIlgtaGFzdXJhLXVzZXItaWQiOiI5NjgzMSJ9LCJ1c2VyIjp7ImlkIjo5NjgzMX19.NGF4bvlCCA9oy1wlji-Z6Yf_OmQOqYNn2D9T0eekdy0"

GRAPHQL_ENDPOINT = 'https://api.hardcover.app/v1/graphql'

query_me = """
query {
  me {
    id
    username
  }
}
"""

# 测试不同的认证方式
auth_methods = [
    ("Bearer 前缀", f"Bearer {HARDCOPY_API_KEY}"),
    ("无前缀（直接token）", HARDCOPY_API_KEY),
]

print("测试 Hardcover API - 多种认证方式")
print("=" * 70)

for method_name, auth_value in auth_methods:
    print(f"\n{'='*70}")
    print(f"测试方式: {method_name}")
    print(f"=" * 70)
    
    headers = {
        'User-Agent': 'BookMallDownloader/1.0',
        'Content-Type': 'application/json',
        'Authorization': auth_value,
    }
    
    try:
        response = requests.post(GRAPHQL_ENDPOINT, headers=headers, json={"query": query_me}, timeout=20)
        print(f"状态码: {response.status_code}")
        print(f"响应:\n{json.dumps(response.json(), indent=2, ensure_ascii=False)}")
    except Exception as e:
        print(f"请求失败: {e}")
    
    print()

print("=" * 70)
print("测试完成")
