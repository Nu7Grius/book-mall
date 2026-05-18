<template>
  <div
    class="notice-container"
    v-loading="loading"
    element-loading-text="加载中..."
  >
    <el-card class="header-card">
      <div class="header-content">
        <div class="header-left">
          <h2 class="header-title">
            <i class="el-icon-bell"></i>
            公告管理
          </h2>
          <p class="header-subtitle">管理系统公告和通知</p>
        </div>
        <div class="header-right">
          <el-button
            type="primary"
            size="medium"
            @click="handleAdd"
            class="add-btn"
          >
            <i class="el-icon-plus"></i> 发布公告
          </el-button>
        </div>
      </div>
    </el-card>

    <el-card class="search-card">
      <el-form :inline="true" :model="queryForm" class="query-form">
        <el-form-item label="标题" class="search-item">
          <el-input
            v-model="queryForm.title"
            placeholder="请输入公告标题"
            clearable
            prefix-icon="el-icon-search"
          ></el-input>
        </el-form-item>
        <el-form-item label="类型" class="search-item">
          <el-select
            v-model="queryForm.noticeType"
            placeholder="请选择类型"
            clearable
            style="width: 140px"
          >
            <el-option label="促销活动" value="promotion"></el-option>
            <el-option label="精彩活动" value="activity"></el-option>
            <el-option label="行业资讯" value="news"></el-option>
            <el-option label="通知公告" value="notice"></el-option>
            <el-option label="系统消息" value="system"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="状态" class="search-item">
          <el-select
            v-model="queryForm.status"
            placeholder="请选择状态"
            clearable
            style="width: 120px"
          >
            <el-option label="上架" :value="1"></el-option>
            <el-option label="下架" :value="0"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item class="search-actions">
          <el-button type="primary" icon="el-icon-search" @click="handleQuery">
            查询
          </el-button>
          <el-button icon="el-icon-refresh" @click="handleReset">
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <el-table :data="noticeList" border stripe v-loading="loading">
        <el-table-column
          type="index"
          label="序号"
          width="70"
          align="center"
          :index="getRowIndex"
        ></el-table-column>
        <el-table-column
          prop="title"
          label="标题"
          width="200"
        ></el-table-column>
        <el-table-column
          prop="content"
          label="公告内容"
          min-width="200"
          show-overflow-tooltip
        >
          <template slot-scope="scope">
            <span>{{ stripHtml(scope.row.content) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="noticeType" label="类型" width="120">
          <template slot-scope="scope">
            <el-tag
              v-if="scope.row.noticeType === 'promotion'"
              type="danger"
              style="
                background: linear-gradient(135deg, #ff6b6b 0%, #ff8e53 100%);
                border: none;
                color: #fff;
              "
            >
              🔥 促销活动
            </el-tag>
            <el-tag
              v-else-if="scope.row.noticeType === 'activity'"
              type="success"
              style="
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                border: none;
                color: #fff;
              "
            >
              🎉 精彩活动
            </el-tag>
            <el-tag
              v-else-if="scope.row.noticeType === 'news'"
              type="primary"
              style="
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                color: #fff;
              "
            >
              📰 行业资讯
            </el-tag>
            <el-tag
              v-else-if="scope.row.noticeType === 'notice'"
              style="
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                border: none;
                color: #fff;
              "
            >
              📢 通知公告
            </el-tag>
            <el-tag
              v-else
              style="
                background: linear-gradient(135deg, #909399 0%, #707070 100%);
                border: none;
                color: #fff;
              "
            >
              ⚙️ 系统消息
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.status === 1" type="success">上架</el-tag>
            <el-tag v-else type="info">下架</el-tag>
          </template>
        </el-table-column>
        <el-table-column
          prop="viewCount"
          label="浏览量"
          width="80"
        ></el-table-column>
        <el-table-column
          prop="publishTime"
          label="发布时间"
          width="160"
        ></el-table-column>
        <el-table-column
          prop="publisherName"
          label="发布人"
          width="120"
        ></el-table-column>
        <el-table-column label="操作" width="200" align="center">
          <template slot-scope="scope">
            <el-button size="mini" type="primary" @click="handleEdit(scope.row)"
              >编辑</el-button
            >
            <el-button
              size="mini"
              type="danger"
              @click="handleDelete(scope.row.id)"
              >删除</el-button
            >
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="pagination.page"
        :page-sizes="[10, 20, 50, 100]"
        :page-size="pagination.pageSize"
        :total="pagination.total"
        layout="total, sizes, prev, pager, next, jumper"
        style="margin-top: 20px; text-align: right"
      >
      </el-pagination>
    </el-card>

    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      width="600px"
      class="notice-dialog"
    >
      <el-form
        :model="noticeForm"
        :rules="rules"
        ref="noticeForm"
        label-width="100px"
      >
        <el-form-item label="标题" prop="title">
          <el-input
            v-model="noticeForm.title"
            placeholder="请输入公告标题"
          ></el-input>
        </el-form-item>
        <el-form-item label="类型" prop="noticeType">
          <el-select
            v-model="noticeForm.noticeType"
            placeholder="请选择类型"
            style="width: 100%"
          >
            <el-option label="🔥 促销活动" value="promotion"></el-option>
            <el-option label="🎉 精彩活动" value="activity"></el-option>
            <el-option label="📰 行业资讯" value="news"></el-option>
            <el-option label="📢 通知公告" value="notice"></el-option>
            <el-option label="⚙️ 系统消息" value="system"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="封面图片" prop="coverImage">
          <el-upload
            class="notice-cover-uploader"
            :action="uploadUrl"
            :headers="uploadHeaders"
            :show-file-list="false"
            :on-success="handleCoverSuccess"
            :on-error="handleCoverError"
            :before-upload="beforeCoverUpload"
          >
            <img
              v-if="noticeForm.coverImage"
              :src="getImageUrl(noticeForm.coverImage)"
              class="cover-preview"
            />
            <i v-else class="el-icon-plus cover-uploader-icon"></i>
          </el-upload>
          <div class="cover-tip">
            建议尺寸：1920×600 像素，支持 JPG、PNG 格式
          </div>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <RichEditor ref="editor" v-model="noticeForm.content" :height="250" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="noticeForm.status">
            <el-radio :label="1">上架</el-radio>
            <el-radio :label="0">下架</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {
  getNoticePage,
  addNotice,
  updateNotice,
  deleteNotice,
} from "@/api/notice";
import RichEditor from "@/components/RichEditor.vue";
import { getImageUrl } from "@/utils/img";

export default {
  name: "NoticeList",
  components: {
    RichEditor,
  },
  data() {
    return {
      noticeList: [],
      loading: false,
      queryForm: {
        title: "",
        noticeType: "",
        status: null,
      },
      pagination: {
        page: 1,
        pageSize: 10,
        total: 0,
      },
      dialogVisible: false,
      dialogTitle: "发布公告",
      uploadUrl: "/upload/image",
      uploadHeaders: {
        Authorization: localStorage.getItem("token") || "",
      },
      noticeForm: {
        id: null,
        title: "",
        content: "",
        noticeType: "system",
        coverImage: "",
        status: 1,
      },
      rules: {
        title: [
          { required: true, message: "请输入公告标题", trigger: "blur" },
          {
            min: 2,
            max: 100,
            message: "标题长度在 2 到 100 个字符",
            trigger: "blur",
          },
        ],
        content: [
          { required: true, message: "请输入公告内容", trigger: "blur" },
        ],
        noticeType: [
          { required: true, message: "请选择公告类型", trigger: "change" },
        ],
      },
    };
  },
  mounted() {
    this.loadNoticeList();
  },
  methods: {
    getRowIndex(index) {
      return (this.pagination.page - 1) * this.pagination.pageSize + index + 1;
    },
    stripHtml(html) {
      if (!html) return "";
      return html.replace(/<[^>]*>/g, "");
    },
    handleCoverSuccess(res) {
      if (res.code === 200) {
        this.noticeForm.coverImage = res.data;
        this.$message.success("封面上传成功");
      }
    },
    handleCoverError(err) {
      this.$message.error("图片上传失败，请重试");
    },
    beforeCoverUpload(file) {
      const isImage =
        file.type === "image/jpeg" ||
        file.type === "image/png" ||
        file.type === "image/jpg";
      const isLt5M = file.size / 1024 / 1024 < 5;

      if (!isImage) {
        this.$message.error("封面只能上传 JPG/PNG 格式的图片!");
        return false;
      }
      if (!isLt5M) {
        this.$message.error("封面图片大小不能超过 5MB!");
        return false;
      }
      return true;
    },
    loadNoticeList() {
      this.loading = true;
      const params = {
        page: this.pagination.page,
        pageSize: this.pagination.pageSize,
      };
      if (this.queryForm.title) {
        params.title = this.queryForm.title;
      }
      if (this.queryForm.noticeType) {
        params.noticeType = this.queryForm.noticeType;
      }
      if (this.queryForm.status !== null && this.queryForm.status !== "") {
        params.status = this.queryForm.status;
      }

      getNoticePage(params)
        .then((res) => {
          if (res.code === 200) {
            this.noticeList = res.data.records || [];
            this.pagination.total = res.data.total || 0;
          }
        })
        .finally(() => {
          this.loading = false;
        });
    },
    handleQuery() {
      this.pagination.page = 1;
      this.loadNoticeList();
    },
    handleReset() {
      this.queryForm = {
        title: "",
        noticeType: "",
        status: null,
      };
      this.pagination.page = 1;
      this.loadNoticeList();
    },
    handleSizeChange(size) {
      this.pagination.pageSize = size;
      this.pagination.page = 1;
      this.loadNoticeList();
    },
    handleCurrentChange(page) {
      this.pagination.page = page;
      this.loadNoticeList();
    },
    handleAdd() {
      this.dialogTitle = "发布公告";
      const userInfo = JSON.parse(localStorage.getItem("userInfo") || "{}");
      this.noticeForm = {
        id: null,
        title: "",
        content: "",
        noticeType: "system",
        coverImage: "",
        status: 1,
        publisherId: userInfo.id || null,
        publisherName: userInfo.realName || userInfo.username || "",
        publishTime: new Date().toISOString(),
      };
      this.dialogVisible = true;
    },
    handleEdit(row) {
      this.dialogTitle = "编辑公告";
      this.noticeForm = { ...row };
      this.dialogVisible = true;
      this.$nextTick(() => {
        if (this.$refs.editor) {
          this.$refs.editor.setContent(row.content || "");
        }
      });
    },
    async handleDelete(id) {
      try {
        await this.$confirm("确定要删除这条公告吗？", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning",
        });
        const res = await deleteNotice(id);
        if (res.code === 200) {
          this.$message.success("删除成功");
          this.loadNoticeList();
        }
      } catch (e) {
        return Promise.resolve();
      }
    },
    submitForm() {
      this.$refs.noticeForm.validate((valid) => {
        if (valid) {
          const action = this.noticeForm.id ? updateNotice : addNotice;
          action(this.noticeForm).then((res) => {
            if (res.code === 200) {
              this.$message.success("操作成功");
              this.dialogVisible = false;
              this.loadNoticeList();
            }
          });
        }
      });
    },
  },
};
</script>

<style scoped>
.notice-container {
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
  min-height: calc(100vh - 60px);
}

.header-card {
  margin-bottom: 20px;
  border: none;
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  color: white;
}

.header-card ::v-deep .el-card__body {
  padding: 20px 25px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  flex: 1;
}

.header-title {
  margin: 0 0 5px 0;
  font-size: 24px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-subtitle {
  margin: 0;
  font-size: 14px;
  opacity: 0.9;
}

.add-btn {
  background: white;
  border: none;
  color: #1e3c72;
  font-weight: 500;
  transition: all 0.3s;
}

.add-btn:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.search-card {
  margin-bottom: 20px;
  border: none;
  border-radius: 12px;
}

.query-form {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  align-items: flex-end;
}

.search-item {
  margin-bottom: 0;
}

.search-actions {
  margin-bottom: 0;
}

.table-card {
  border: none;
  border-radius: 12px;
}

.query-form {
  margin-bottom: 18px;
}

.notice-cover-uploader {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  width: 320px;
  height: 180px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  background-color: #fafafa;
}

.notice-cover-uploader:hover {
  border-color: #409eff;
  background-color: #f0f7ff;
}

.notice-cover-uploader:active {
  transform: scale(0.98);
}

.cover-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  transition: all 0.3s;
}

.notice-cover-uploader:hover .cover-uploader-icon {
  color: #409eff;
  transform: scale(1.1);
}

.cover-preview {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.cover-tip {
  margin-top: 8px;
  font-size: 12px;
  color: #999;
}

.notice-dialog ::v-deep .el-dialog__header {
  background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
  color: white;
  padding: 15px 20px;
  margin-right: 0;
}

.notice-dialog ::v-deep .el-dialog__title {
  color: white;
  font-weight: 600;
}

.notice-dialog ::v-deep .el-dialog__headerbtn .el-dialog__close {
  color: white;
}

.notice-dialog ::v-deep .el-dialog__body {
  padding: 25px;
}
</style>
