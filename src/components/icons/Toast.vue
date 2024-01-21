<template>
  <div v-if="show" class="toast" :class="{'success': type === 'success', 'error': type === 'error'}">
    {{ message }}
  </div>
</template>

<script>
export default {
  props: {
    message: String,
    type: {
      type: String,
      default: 'info', // Default type is 'info'
    },
  },
  data() {
    return {
      show: false,
    };
  },
  watch: {
    message() {
      this.show = true;
      // Auto-hide the toast after 3 seconds (adjust as needed)
      setTimeout(() => {
        this.show = false;
      }, 3000);
    },
  },
};
</script>

<style scoped>
.toast {
  position: fixed;
  top: 20px;
  right: 20px;
  padding: 10px 20px;
  border-radius: 5px;
  color: #fff;
  font-size: 16px;
  z-index: 1000;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.toast.success {
  background-color: #4CAF50;
}

.toast.error {
  background-color: #FF5722;
}
</style>
