<template>
  <div>
    <playlist-arrangement-view v-for="(playlists, key) in playlistsWithFolders" :key="key" :folderName="key"
      :playlists="playlists" @open-playlist-detail-component="openPlaylistDetail">
    </playlist-arrangement-view>
  </div>
</template>
  
<script>
import PlaylistArrangementView from '@/components/Arrangements/PlaylistArrangementView.vue';

export default {
  components: { PlaylistArrangementView },
  props: {
    playlistsWithFolders: Object,
  },
  methods: {
    openPlaylistDetail: function (playlistName, event) {
      this.$emit('open-playlist-detail-component', playlistName);
    },
  }
};

</script>
  
<style scoped></style>