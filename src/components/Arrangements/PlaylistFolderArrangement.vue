<template>
    <div>
      <playlist-arrangement-view v-for="(playlists, key) in playlistsWithFolders" 
        :key="key" :folderName="key" :playlists="playlists" @open-playlist-detail-component="openPlaylistDetail">
      </playlist-arrangement-view>
    </div>
  </template>
  
  <script>
    import PlaylistArrangementView from '@/components/Arrangements/PlaylistArrangementView.vue';
  
  export default {
    components: {PlaylistArrangementView},
    props: {
      playlistsWithFolders: Object,
    },
    methods: {
    openPlaylistDetail: function(playlistName, event) {
      this.$emit('open-playlist-detail-component', playlistName);
    },
    }
  };

  </script>
  
  <style scoped>
  .folder-div {
    padding: 5px 15px;
  }
  
  .collapsible-content {
    display: block; /* Initially visible */
  }
  
  .collapsed {
    display: none; /* Hidden when collapsed */
  }
  
  .playlist-div {
    margin: 5px 0px;
  
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