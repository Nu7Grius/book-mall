/**
 * 微信小程序 lazyCodeLoading 修复脚本
 * 
 * uni-app 编译会覆盖 app.json 和 project.config.json 中的 lazyCodeLoading 配置
 * 此脚本在每次编译后自动修复这些问题
 * 
 * 使用方式：
 *   node fix-app.js
 *   或双击 fix-lazyCodeLoading.bat
 */
const fs = require('fs');
const path = require('path');

const distDir = path.join(__dirname, 'unpackage', 'dist', 'dev', 'mp-weixin');
const appJsonPath = path.join(distDir, 'app.json');
const projectConfigPath = path.join(distDir, 'project.config.json');

function fixAppJson() {
  if (!fs.existsSync(appJsonPath)) {
    console.log('⚠️  app.json 不存在，请先编译项目');
    return false;
  }

  let content = fs.readFileSync(appJsonPath, 'utf8');
  
  if (!content.includes('"lazyCodeLoading"')) {
    content = content.replace('"subPackages"', '"lazyCodeLoading": "requiredComponents",\n  "subPackages"');
    fs.writeFileSync(appJsonPath, content, 'utf8');
    console.log('✅ app.json 已添加 lazyCodeLoading');
    return true;
  } else {
    console.log('✅ app.json 已有 lazyCodeLoading');
    return true;
  }
}

function fixProjectConfig() {
  if (!fs.existsSync(projectConfigPath)) {
    console.log('⚠️  project.config.json 不存在，跳过');
    return false;
  }

  try {
    let content = fs.readFileSync(projectConfigPath, 'utf8');
    let config = JSON.parse(content);
    
    if (!config.setting) {
      config.setting = {};
    }
    
    if (config.setting.lazyCodeLoading !== 'requiredComponents') {
      config.setting.lazyCodeLoading = 'requiredComponents';
      fs.writeFileSync(projectConfigPath, JSON.stringify(config, null, 2), 'utf8');
      console.log('✅ project.config.json 已添加 lazyCodeLoading');
      return true;
    } else {
      console.log('✅ project.config.json 已有 lazyCodeLoading');
      return true;
    }
  } catch (e) {
    console.log('⚠️  project.config.json 解析失败:', e.message);
    return false;
  }
}

console.log('========================================');
console.log('  微信小程序 lazyCodeLoading 修复工具');
console.log('========================================');
console.log('');

let success = true;

if (fixAppJson()) {
  if (fixProjectConfig()) {
    console.log('');
    console.log('========================================');
    console.log('  修复完成！');
    console.log('  请在微信开发者工具中点击"编译"刷新');
    console.log('========================================');
  }
} else {
  success = false;
}

process.exit(success ? 0 : 1);
