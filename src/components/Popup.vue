<!-- Popup.vue -->
<template>
  <div v-if="showPopup" class="popup">
    <p>{{ infoText }}</p>
  </div>
</template>

<script>
export default {
  props: {
    showPopup: Boolean,
    infoText: String,
  },
};
</script>

<style scoped>
.popup {
  border-radius: 10px;
  position: absolute;
  top: 0;
  left: 0;
  background-color: #fff;
  padding: 10px;
  border: 1px solid #ccc;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  z-index: 1000;
}
</style>
