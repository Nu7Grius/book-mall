const fs = require('fs');
const path = require('path');

const appJsonPath = path.join(__dirname, 'unpackage', 'dist', 'dev', 'mp-weixin', 'app.json');

try {
  let content = fs.readFileSync(appJsonPath, 'utf8');
  if (!content.includes('lazyCodeLoading')) {
    content = content.replace('"subPackages"', '"lazyCodeLoading": "requiredComponents",\n  "subPackages"');
    fs.writeFileSync(appJsonPath, content, 'utf8');
    console.log('✅ app.json 已添加 lazyCodeLoading');
  } else {
    console.log('✅ app.json 已有 lazyCodeLoading');
  }
} catch (e) {
  console.error('❌ 修复失败:', e.message);
}
