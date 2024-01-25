<template>
  <div>
    <div class="playlist-div" v-for="(tracks, playlistName) in data" :key="playlistName">
      <div style="padding: 5px 15px;" @click="openPlaylistDetail(playlistName, $event)" @mouseover="handlePlaylistNameMouseOver" @mouseout="handlePlaylistNameMouseOut">
        <h2 style="font-weight: bold; display: inline-block; text-decoration: underline;">{{ playlistName }}</h2>
        <img src="../icons/link-icon.png" alt="Link Icon" class="link-icon" style="width: 12px; height: 12px; margin-left: 5px">
      </div>
      <track-arrangement-view :tracks="Object.fromEntries(Object.entries(tracks).slice(0, 10))" :discoverMode="false"></track-arrangement-view>
<!--       <div class="more-track-div" v-if="renderExtendedDiv" @click="openPlaylistDetail(playlistName, $event)" @mouseover="handlePlaylistNameMouseOver" @mouseout="handlePlaylistNameMouseOut">. . .
      </div> -->

    </div>
  </div>
</template>

<script>
import TrackArrangementView from "@/components/Arrangements/TrackArrangementView.vue";

export default {
  components: {TrackArrangementView},
  props: {
    data: Object,
    renderExtendedDiv: {
      type: Boolean,
      required: false,
    }
  },
  created() {
    console.log(this.renderExtendedDiv)
  },
  methods: {
    openPlaylistDetail: function(playlistName, event) {
      this.$emit('open-playlist-detail-component', playlistName);
    },
    handlePlaylistNameMouseOver(){
      document.body.style.cursor = "pointer";
    },
    handlePlaylistNameMouseOut() {
      document.body.style.cursor = "auto";
    }
  },
};
</script>

<style scoped>
.playlist-div {
  margin-bottom: 10px 0px;

  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}
.more-track-div {
  flex: 0 0 calc(9.5% - 5px); /* Adjust the width as needed*/
  box-sizing: border-box;
  margin: 5px;
  text-align: center;
  font-size: 12px;

  width: 150px;
  height: 150px;
  border-radius: 15px;

  background-color: lightslategray;
  line-height: 150px
}

</style>