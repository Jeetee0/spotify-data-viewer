<template>
  <div v-if="showPopup" class="popup" :style="{ top: topPosition, left: leftPosition }">
    <p>{{ infoText }}</p>
  </div>
</template>

<script>
export default {
  props: {
    showPopup: Boolean,
    infoText: String,
  },
  data() {
    return {
      topPosition: '0px',
      leftPosition: '0px',
    };
  },
  mounted() {
    // Listen for mousemove event to update popup position
    window.addEventListener('mousemove', this.updatePopupPosition);
  },
  methods: {
    updatePopupPosition(event) {
      // Update top and left position based on mouse cursor position
      this.topPosition = `${event.clientY + 15}px`;
      this.leftPosition = `${event.clientX + 15}px`;
    },
  },
  beforeDestroy() {
    // Remove event listener when component is destroyed
    window.removeEventListener('mousemove', this.updatePopupPosition);
  },
};
</script>

<style scoped>
.popup {
  max-width: 250px;
  border-radius: 10px;
  position: fixed;
  opacity: 0.95;
  color: black;
  background-color: #fff;
  padding: 5px 10px;
  border: 1px solid #ccc;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  z-index: 1000;
}
</style>
