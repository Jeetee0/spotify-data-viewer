<template>
  <div>
    <div v-if="folderName !== 'diff'" style="display: flex; flex-direction: row; padding-left: 10px;">
      <h2 style="font-weight: bold;" @click="toggleCollapse" @mouseover="collapseCursor(true)"
        @mouseout="collapseCursor(false)">{{ folderName }}</h2>
      <img v-if="!collapsed" @mouseover="collapseCursor(true)" @mouseout="collapseCursor(false)" @click="toggleCollapse"
        src="../../assets/minimize.png" alt="minimize"
        style="height: 18px; width: 18px; margin-top: 12px; margin-left: 10px;">
      <img v-if="collapsed" @mouseover="collapseCursor(true)" @mouseout="collapseCursor(false)" @click="toggleCollapse"
        src="../../assets/maximize.png" alt="maximize"
        style="height: 18px; width: 18px; margin-top: 12px; margin-left: 10px">
    </div>
    <div class="collapsible-content" v-if="!collapsed" style="padding-left: 15px;">
      <div v-for="(tracks, playlistName) in playlists" :key="playlistName"
        :class="{ 'playlist-div-last-item': index === playlists.length - 1, 'playlist-div': index !== playlists.length - 1 }">
        <div style="padding: 0px 10px; max-width: 400px;" @click="openPlaylistDetail(playlistName, $event)"
          @mouseover="handlePlaylistNameMouseOver(true)" @mouseout="handlePlaylistNameMouseOut(false)">
          <h2 style="font-weight: bold; display: inline-block; text-decoration: underline;">{{ playlistName }}</h2>
          <img src="../icons/link-icon.png" alt="Link Icon" class="link-icon"
            style="width: 12px; height: 12px; margin-left: 5px">
        </div>
        <track-arrangement-view :tracks="tracks" :discoverMode="false" popupInfoText="Open track in Spotify"
          @track-clicked="openTrackInSpotify"></track-arrangement-view>
      </div>
    </div>

  </div>
  <popup :showPopup="isHovered" infoText="Open Playlist in detail view"></popup>
  <div style="padding-bottom: 10px; "></div>
  <div class="bottom-line-div"></div>
</template>

<script>
import TrackArrangementView from "@/components/Arrangements/TrackArrangementView.vue";
import Popup from "@/components/Popup.vue"

export default {
  components: { TrackArrangementView, Popup },
  props: {
    playlists: Object,
    folderName: String,
  },
  data() {
    return {
      collapsed: true,
      isHovered: false,
    };
  },
  created() {
    if (this.folderName === "diff")
      this.collapsed = false;
  },
  unmounted() {
    document.body.style.cursor = "auto";
  },
  methods: {
    collapseCursor(value) {
      if (value)
        document.body.style.cursor = "pointer";
      else
        document.body.style.cursor = "auto";
    },
    toggleCollapse() {
      this.collapsed = !this.collapsed;
    },
    openPlaylistDetail: function (playlistName, event) {
      this.$emit('open-playlist-detail-component', playlistName);
    },
    handlePlaylistNameMouseOver(value) {
      document.body.style.cursor = "pointer";
      this.isHovered = value;
    },
    handlePlaylistNameMouseOut(value) {
      document.body.style.cursor = "auto";
      this.isHovered = value;
    },
    openTrackInSpotify(track) {
      window.open(track.spotify_url)
    }
  },
};
</script>

<style scoped>
.folder-div {
  padding: 5px 15px;
}

.dotted-border-line-div {
  padding: 5px 0px;
  border-bottom-style: dotted;
  border-width: 2px;
  border-color: #2c3e50;
}

.collapsible-content {
  display: block;
  /* Initially visible */
}

.collapsed {
  display: none;
  /* Hidden when collapsed */
}

.playlist-div {
  margin: 5px 0px;

  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

.playlist-div-last-item {
  margin: 5px 0px;
}

.bottom-line-div {
  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
  margin: 0px 0px
}
</style>