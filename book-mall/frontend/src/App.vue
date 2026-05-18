<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>
export default {
  name: "App",
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html,
body {
  height: 100%;
  width: 100%;
  overflow-y: auto;
  overflow-x: hidden;
}

/* 自定义滚动条样式 */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}
::-webkit-scrollbar-track {
  background: #f5f7fa;
  border-radius: 4px;
}
::-webkit-scrollbar-thumb {
  background: #c0c4cc;
  border-radius: 4px;
}
::-webkit-scrollbar-thumb:hover {
  background: #909399;
}

/* 覆盖 Element UI 日期范围选择器的分隔符样式 */
.el-date-editor .el-range-separator {
  width: 28px !important;
  padding: 0 6px !important;
  text-align: center !important;
}

/* 全局表格样式 - 所有表格列内容居中，表格本身靠左 */
.el-table {
  margin-left: 0 !important;
  margin-right: auto;
}

.el-table .cell {
  text-align: center;
}

.el-table th {
  text-align: center !important;
}

.el-table td {
  text-align: center;
}

.el-table__header-wrapper,
.el-table__body-wrapper {
  margin-left: 0;
}
</style>
