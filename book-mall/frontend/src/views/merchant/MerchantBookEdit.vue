<template>
  <div class="book-edit">
    <el-card>
      <div slot="header">
        <span>✏️ 编辑图书</span>
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
            <el-form-item label="书名" prop="bookName">
              <el-input
                v-model="bookForm.bookName"
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
            <el-form-item label="一级分类" prop="firstCategoryId">
              <el-select
                v-model="bookForm.firstCategoryId"
                placeholder="请选择一级分类"
                style="width: 100%"
                @change="handleFirstCategoryChange"
              >
                <el-option
                  v-for="cat in firstCategoryList"
                  :key="cat.id"
                  :label="cat.categoryName"
                  :value="cat.id"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="二级分类" prop="secondCategoryId">
              <el-select
                v-model="bookForm.secondCategoryId"
                placeholder="请选择二级分类"
                style="width: 100%"
                :disabled="!bookForm.firstCategoryId"
              >
                <el-option
                  v-for="cat in filteredSecondCategoryList"
                  :key="cat.id"
                  :label="cat.categoryName"
                  :value="cat.id"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
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

        <el-form-item label="封面图片" prop="coverImage">
          <el-upload
            class="cover-uploader"
            action="#"
            :show-file-list="false"
            :before-upload="beforeCoverUpload"
          >
            <div class="cover-wrapper">
              <img
                v-if="bookForm.coverImage"
                :src="getImageUrl(bookForm.coverImage)"
                class="cover"
              />
              <i v-else class="el-icon-plus cover-uploader-icon"></i>
              <i
                v-if="bookForm.coverImage"
                class="el-icon-circle-close cover-delete-btn"
                @click.stop="removeCoverImage"
              ></i>
            </div>
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
            <i class="el-icon-check"></i> 保存修改
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
  name: "MerchantBookEdit",
  data() {
    return {
      editor: null,
      bookId: null,
      categoryList: [],
      firstCategoryList: [],
      secondCategoryList: [],
      filteredSecondCategoryList: [],
      bookForm: {
        id: null,
        bookName: "",
        author: "",
        isbn: "",
        price: 0,
        stock: 0,
        coverImage: "",
        publisher: "",
        publishDate: "",
        pages: 0,
        binding: "",
        language: "",
        description: "",
        firstCategoryId: "",
        secondCategoryId: "",
      },
      loading: false,
      rules: {
        bookName: [{ required: true, message: "请输入书名", trigger: "blur" }],
        author: [{ required: true, message: "请输入作者", trigger: "blur" }],
        firstCategoryId: [
          { required: true, message: "请选择一级分类", trigger: "change" },
        ],
        secondCategoryId: [
          { required: true, message: "请选择二级分类", trigger: "change" },
        ],
        price: [{ required: true, message: "请输入价格", trigger: "blur" }],
        stock: [{ required: true, message: "请输入库存", trigger: "blur" }],
      },
    };
  },
  mounted() {
    this.bookId = this.$route.params.id;
    if (this.bookId) {
      this.loadCategoryList().then(() => {
        this.loadBookDetail();
      });
      this.initEditor();
    }
  },
  beforeDestroy() {
    if (this.editor) {
      this.editor.destroy();
      this.editor = null;
    }
  },
  methods: {
    loadCategoryList() {
      return this.$http.get("/category/list").then((res) => {
        if (res.code === 200) {
          this.categoryList = res.data || [];
          this.firstCategoryList = this.categoryList.filter(
            (cat) => cat.categoryLevel === 1
          );
          this.secondCategoryList = this.categoryList.filter(
            (cat) => cat.categoryLevel === 2
          );
        }
      });
    },
    handleFirstCategoryChange(categoryId) {
      this.bookForm.secondCategoryId = "";
      if (categoryId) {
        this.filteredSecondCategoryList = this.secondCategoryList.filter(
          (cat) => cat.parentId === categoryId
        );
      } else {
        this.filteredSecondCategoryList = [...this.secondCategoryList];
      }
    },
    initEditor() {
      this.$nextTick(() => {
        if (this.editor) {
          this.editor.destroy();
        }
        this.editor = new E(this.$refs.editor);
        this.editor.config.uploadImgServer = "/api/upload";
        this.editor.config.uploadImgMaxSize = 2 * 1024 * 1024;
        this.editor.config.uploadImgAccept = [
          "jpg",
          "jpeg",
          "png",
          "gif",
          "bmp",
        ];
        this.editor.create();
        if (this.bookForm.description) {
          this.editor.txt.html(this.bookForm.description);
        }
      });
    },
    loadBookDetail() {
      this.loading = true;
      this.$http
        .get(`/book/${this.bookId}`)
        .then((res) => {
          if (res.code === 200) {
            const book = res.data;
            this.bookForm = {
              id: book.id,
              bookName: book.bookName || "",
              author: book.author || "",
              isbn: book.isbn || "",
              price: book.price || 0,
              stock: book.stock || 0,
              coverImage: book.coverImage || "",
              publisher: book.publisher || "",
              publishDate: book.publishDate || "",
              pages: book.pages || 0,
              binding: book.binding || "",
              language: book.language || "",
              description: book.description || "",
              merchantId: book.merchantId || null,
              status: book.status,
              auditStatus: book.auditStatus,
              sales: book.sales || 0,
              createTime: book.createTime,
              firstCategoryId: "",
              secondCategoryId: book.categoryId || "",
            };

            if (book.categoryId) {
              const category = this.categoryList.find(
                (cat) => cat.id === book.categoryId
              );
              if (category && category.parentId) {
                this.bookForm.firstCategoryId = category.parentId;
                this.filteredSecondCategoryList =
                  this.secondCategoryList.filter(
                    (cat) => cat.parentId === category.parentId
                  );
              }
            }

            if (this.editor) {
              this.editor.txt.html(this.bookForm.description);
            }
          } else {
            this.$message.error("加载图书详情失败");
          }
        })
        .catch(() => {
          this.$message.error("加载图书详情失败");
        })
        .finally(() => {
          this.loading = false;
        });
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
            this.bookForm.coverImage = res.data;
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
    removeCoverImage() {
      this.bookForm.coverImage = "";
    },
    handleSubmit() {
      this.$refs.bookForm.validate((valid) => {
        if (valid) {
          this.loading = true;
          this.bookForm.description = this.editor ? this.editor.txt.html() : "";

          const formData = {
            id: this.bookForm.id,
            bookName: this.bookForm.bookName,
            author: this.bookForm.author,
            isbn: this.bookForm.isbn,
            price: this.bookForm.price,
            stock: this.bookForm.stock,
            coverImage: this.bookForm.coverImage,
            publisher: this.bookForm.publisher,
            publishDate: this.bookForm.publishDate,
            pages: this.bookForm.pages,
            binding: this.bookForm.binding,
            language: this.bookForm.language,
            description: this.bookForm.description,
            categoryId:
              this.bookForm.secondCategoryId || this.bookForm.firstCategoryId,
            merchantId: this.bookForm.merchantId,
            status: this.bookForm.status,
            auditStatus: this.bookForm.auditStatus,
            sales: this.bookForm.sales || 0,
          };

          this.$http
            .put("/book/update", formData)
            .then((res) => {
              if (res.code === 200) {
                this.$message.success("修改成功");
                window.dispatchEvent(new Event("book-updated"));
                this.$router.push("/merchant/book-list");
              } else {
                this.$message.error(res.message || "修改失败");
              }
            })
            .catch(() => {
              this.$message.error("修改失败，请稍后重试");
            })
            .finally(() => {
              this.loading = false;
            });
        }
      });
    },
  },
};
</script>

<style scoped>
.book-edit {
  padding: 20px;
  position: relative;
  z-index: 100;
}

.book-edit ::v-deep .el-form {
  position: relative;
  z-index: 100;
}

.book-edit ::v-deep .el-select {
  z-index: 100 !important;
}

.book-edit ::v-deep .el-select-dropdown {
  z-index: 10000 !important;
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

.cover-wrapper {
  position: relative;
  width: 200px;
  height: 280px;
}

.cover-delete-btn {
  position: absolute;
  top: 5px;
  right: 5px;
  font-size: 20px;
  color: #fff;
  background-color: rgba(0, 0, 0, 0.6);
  border-radius: 50%;
  padding: 5px;
  cursor: pointer;
  transition: all 0.3s;
}

.cover-delete-btn:hover {
  background-color: rgba(245, 108, 108, 0.9);
  transform: scale(1.1);
}

.upload-tip {
  color: #909399;
  font-size: 12px;
  margin-top: 8px;
}

.editor-container ::v-deep .w-e-text-container {
  z-index: 1 !important;
}

.editor-container ::v-deep .w-e-menu {
  z-index: 2 !important;
}
</style>
