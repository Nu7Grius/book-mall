<template>
  <div class="book-add">
    <el-card>
      <div slot="header">
        <span>➕ 添加图书</span>
        <el-button size="small" style="float: right" @click="$router.back()">
          <i class="el-icon-arrow-left"></i> 返回
        </el-button>
      </div>

      <el-form
        ref="bookForm"
        :model="bookForm"
        :rules="rules"
        label-width="120px"
        style="max-width: 800px"
      >
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="书名" prop="name">
              <el-input
                v-model="bookForm.name"
                placeholder="请输入书名"
              ></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="作者" prop="author">
              <el-input
                v-model="bookForm.author"
                placeholder="请输入作者"
              ></el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="分类" prop="category">
              <el-select
                v-model="bookForm.category"
                placeholder="请选择分类"
                style="width: 100%"
              >
                <el-option label="编程" value="编程"></el-option>
                <el-option label="文学" value="文学"></el-option>
                <el-option label="历史" value="历史"></el-option>
                <el-option label="科技" value="科技"></el-option>
                <el-option label="哲学" value="哲学"></el-option>
                <el-option label="艺术" value="艺术"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="ISBN" prop="isbn">
              <el-input
                v-model="bookForm.isbn"
                placeholder="请输入ISBN"
              ></el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="价格" prop="price">
              <el-input-number
                v-model="bookForm.price"
                :min="0"
                :precision="2"
                :controls="false"
                style="width: 100%"
              >
              </el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="库存" prop="stock">
              <el-input-number
                v-model="bookForm.stock"
                :min="0"
                :controls="false"
                style="width: 100%"
              >
              </el-input-number>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="封面图片" prop="cover">
          <el-upload
            class="cover-uploader"
            action="#"
            :show-file-list="false"
            :before-upload="beforeCoverUpload"
          >
            <img
              v-if="bookForm.cover"
              :src="getImageUrl(bookForm.cover)"
              class="cover"
            />
            <i v-else class="el-icon-plus cover-uploader-icon"></i>
          </el-upload>
          <div class="upload-tip">建议尺寸：200x280，支持 JPG、PNG 格式</div>
        </el-form-item>

        <el-form-item label="出版社" prop="publisher">
          <el-input
            v-model="bookForm.publisher"
            placeholder="请输入出版社"
          ></el-input>
        </el-form-item>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="出版日期" prop="publishDate">
              <el-date-picker
                v-model="bookForm.publishDate"
                type="date"
                placeholder="选择日期"
                style="width: 100%"
                format="yyyy-MM-dd"
                value-format="yyyy-MM-dd"
              >
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="页数" prop="pages">
              <el-input-number
                v-model="bookForm.pages"
                :min="0"
                :controls="false"
                style="width: 100%"
              >
              </el-input-number>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="装帧" prop="binding">
              <el-select
                v-model="bookForm.binding"
                placeholder="请选择装帧"
                style="width: 100%"
              >
                <el-option label="平装" value="平装"></el-option>
                <el-option label="精装" value="精装"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="语言" prop="language">
              <el-select
                v-model="bookForm.language"
                placeholder="请选择语言"
                style="width: 100%"
              >
                <el-option label="中文" value="中文"></el-option>
                <el-option label="英文" value="英文"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="商品描述" prop="description">
          <div ref="editor" class="editor-container"></div>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="handleSubmit" :loading="loading">
            <i class="el-icon-check"></i> 提交
          </el-button>
          <el-button @click="$router.back()">
            <i class="el-icon-close"></i> 取消
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import E from "wangeditor";

export default {
  name: "MerchantBookAdd",
  data() {
    return {
      editor: null,
      bookForm: {
        name: "",
        author: "",
        category: "",
        isbn: "",
        price: 0,
        stock: 0,
        cover: "",
        publisher: "",
        publishDate: "",
        pages: 0,
        binding: "",
        language: "",
        description: "",
      },
      loading: false,
      rules: {
        name: [{ required: true, message: "请输入书名", trigger: "blur" }],
        author: [{ required: true, message: "请输入作者", trigger: "blur" }],
        category: [
          { required: true, message: "请选择分类", trigger: "change" },
        ],
        price: [{ required: true, message: "请输入价格", trigger: "blur" }],
        stock: [{ required: true, message: "请输入库存", trigger: "blur" }],
      },
    };
  },
  mounted() {
    this.initEditor();
  },
  beforeDestroy() {
    if (this.editor) {
      this.editor.destroy();
      this.editor = null;
    }
  },
  methods: {
    initEditor() {
      this.editor = new E(this.$refs.editor);
      this.editor.config.uploadImgServer = "/api/upload";
      this.editor.config.uploadImgMaxSize = 2 * 1024 * 1024;
      this.editor.config.uploadImgAccept = ["jpg", "jpeg", "png", "gif", "bmp"];
      this.editor.create();
    },
    beforeCoverUpload(file) {
      const isJPG = file.type === "image/jpeg" || file.type === "image/png";
      const isLt2M = file.size / 1024 / 1024 < 2;

      if (!isJPG) {
        this.$message.error("上传封面图片只能是 JPG/PNG 格式!");
        return false;
      }
      if (!isLt2M) {
        this.$message.error("上传封面图片大小不能超过 2MB!");
        return false;
      }

      const formData = new FormData();
      formData.append("file", file);

      this.$http
        .post("/upload/image", formData, {
          headers: {
            "Content-Type": "multipart/form-data",
          },
        })
        .then((res) => {
          if (res.code === 200) {
            this.bookForm.cover = res.data;
            this.$message.success("封面上传成功");
          } else {
            this.$message.error(res.message || "封面上传失败");
          }
        })
        .catch(() => {
          this.$message.error("封面上传失败，请重试");
        });

      return false;
    },
    handleSubmit() {
      this.$refs.bookForm.validate((valid) => {
        if (valid) {
          this.loading = true;
          this.bookForm.description = this.editor.txt.html();
          this.$http
            .post("/merchant/book/add", this.bookForm)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("添加成功");
                this.$router.push("/merchant/book-list");
              }
            })
            .finally(() => {
              this.loading = false;
            });
        }
      });
    },
    getImageUrl(url) {
      if (!url) return "";
      if (url.startsWith("data:")) {
        return url;
      }
      if (url.startsWith("http://") || url.startsWith("https://")) {
        return url;
      }
      return this.$http.defaults.baseURL + url;
    },
  },
};
</script>

<style scoped>
.book-add {
  padding: 20px;
}

.editor-container {
  min-height: 300px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
}

.cover-uploader {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  width: 200px;
  height: 280px;
}

.cover-uploader:hover {
  border-color: #409eff;
}

.cover-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 200px;
  height: 280px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cover {
  width: 200px;
  height: 280px;
  display: block;
  object-fit: cover;
}

.upload-tip {
  color: #909399;
  font-size: 12px;
  margin-top: 8px;
}
</style>
