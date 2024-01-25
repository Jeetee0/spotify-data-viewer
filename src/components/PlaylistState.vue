<template>
  <div style="color: black;">
    <div id="info-selector-div">
      <h1>{{ title }}</h1>
      <div style="display: flex; flex-direction: row; align-content: center; ">
        <p>Choose latest state:</p>
        <input type="number" id="quantity" v-model="stateAmount" min="1" max="10" width="100px" style="margin: 5px 15px; max-width: 50px;">
      </div>
      <p>Showing last 10 tracks added to playlist</p>
    </div>
    <div id="playlist-view-div">
      <playlist-view :data="playlistData" :renderExtendedDiv="true" @open-playlist-detail-component="openPlaylistDetail"/>
    </div>
  </div>
</template>

<script>
import PlaylistView from "@/components/Arrangements/PlaylistArrangementView.vue";

export default {
  components: {PlaylistView},
  data() {
    return {
      title: 'Playlist state - Exported playlist state from spotify',
      stateAmount: 1,
      playlists: [],
      playlistData: {},
    };
  },
  async created() {
    await this.getLatestPlaylistStates()
  },
  watch: {
    stateAmount(newValue) {
      this.getLatestPlaylistStates(newValue);
    },
  },
  methods: {
    async getLatestPlaylistStates() {
      const backendHost = import.meta.env.VITE_BACKEND_HOST;
      const backendPort = import.meta.env.VITE_BACKEND_PORT;
      const response = await this.fetchData(`http://${backendHost}:${backendPort}/spotify/latest_playlist_states?amount=${this.stateAmount}`)
      let newPlaylistData = {};
      const playlists = response[this.stateAmount-1]['playlists']
      this.playlists = playlists

      for (const playlistId in playlists) {
        const name = playlists[playlistId]['name']
        const trackString = playlists[playlistId]['track_ids'].join(",")
        newPlaylistData[name] = await this.getSpotifyTracksByIdList(trackString);
      }

      this.playlistData = newPlaylistData;
    },
    openPlaylistDetail(playlistName) {
      for (const playlistId in this.playlists) {
        if (this.playlists[playlistId]['name'] === playlistName) {
          this.$emit('open-playlist-detail-component-in-app', playlistId);
          break
        }
      }

    },
    async fetchData(url) {
      try {
        const response = await fetch(url);
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }

        return await response.json();
      } catch (error) {
        console.error('Error fetching data:', error.message);
        throw error;
      }
    },
    async getSpotifyTracksByIdList(track_ids) {
      const backendHost = import.meta.env.VITE_BACKEND_HOST;
      const backendPort = import.meta.env.VITE_BACKEND_PORT;
      return await this.fetchData(`http://${backendHost}:${backendPort}/spotify/tracks_by_ids?ids=${track_ids}`)
    },
  },
};
</script>

<style scoped>
#info-selector-div {
  margin: 5px 15px;
}

#playlist-view-div {
  border-top-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}
</style>