<template>
  <div class="rich-editor">
    <div ref="editor" class="editor-container"></div>
  </div>
</template>

<script>
import E from "wangeditor";

export default {
  name: "RichEditor",
  props: {
    value: {
      type: String,
      default: "",
    },
    height: {
      type: Number,
      default: 300,
    },
  },
  data() {
    return {
      editor: null,
    };
  },
  watch: {
    value(newVal) {
      if (this.editor && newVal !== this.editor.txt.html()) {
        this.editor.txt.html(newVal);
      }
    },
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
      this.editor.config.height = this.height;
      this.editor.config.uploadImgServer = "/file/upload";
      this.editor.config.uploadImgMaxLength = 5;
      this.editor.config.uploadFileName = "file";
      this.editor.config.uploadImgHooks = {
        customInsert: (insertImg, result) => {
          if (result.code === 200) {
            insertImg(result.data);
          } else {
            this.$message.error(result.message || "图片上传失败");
          }
        },
      };
      this.editor.config.onchange = (html) => {
        this.$emit("input", html);
      };
      this.editor.create();
      if (this.value) {
        this.editor.txt.html(this.value);
      }
    },
    getContent() {
      return this.editor ? this.editor.txt.html() : "";
    },
    setContent(html) {
      if (this.editor) {
        this.editor.txt.html(html);
      }
    },
    clearContent() {
      if (this.editor) {
        this.editor.txt.clear();
      }
    },
  },
};
</script>

<style>
.rich-editor .editor-container {
  border: 1px solid #ddd;
  border-radius: 4px;
}

.rich-editor .w-e-text-container {
  height: auto !important;
  min-height: 200px;
  max-height: 500px;
  overflow-y: auto;
}
</style>
