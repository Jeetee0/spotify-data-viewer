<template>
  <div style="color: black;">
    <div id="info-selector-div">
      <h1>{{ title }}</h1>
      <div style="display: flex; flex-direction: row; align-content: center;align-items: center; margin-bottom: 15px;">
        <p>Choose latest state:</p>
        <input type="number" id="quantity" v-model="stateAmount" min="1" max="10" width="100px"
          style="width: 50px; height: 25px; margin-left: 10px; margin-right: 20px; ">
        <p style="font-size: 14px">Export date:</p>
        <input disabled="true" id="user-data-export-date" v-model="exportDate"
          style="width: 100px; margin-left: 20px; margin-right: 20px; pointer-events: none;" />
      </div>
    </div>
    <div id="playlist-view-div">
      <playlist-folder-arrangement :playlistsWithFolders="playlistData"
        @open-playlist-detail-component="openPlaylistDetail" />
    </div>
  </div>
</template>

<script>
import PlaylistFolderArrangement from "@/components/Arrangements/PlaylistFolderArrangement.vue";

export default {
  components: { PlaylistFolderArrangement },
  props: {
    accessToken: String
  },
  data() {
    return {
      title: 'Playlist state - Exported playlist state from spotify',
      stateAmount: 1,
      exportDate: "",

      playlists: [],
      playlistData: {},
      latestPlaylistState: {},

      backendHost: import.meta.env.VITE_BACKEND_HOST,
      backendPort: import.meta.env.VITE_BACKEND_PORT,
    };
  },
  async created() {
    this.getLatestPlaylistStates(this.stateAmount);
  },
  watch: {
    stateAmount(newValue) {
      this.getLatestPlaylistStates(newValue);
    },
  },
  methods: {
    async getLatestPlaylistStates() {
      const response = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/latest_playlist_states?amount=${this.stateAmount}`)
      let newPlaylistData = {};
      this.exportDate = response[this.stateAmount - 1]['created_at']['$date'].substring(0, 10)
      const playlists = response[this.stateAmount - 1]['playlists']
      this.playlists = playlists

      for (const playlistId in playlists) {
        const folder = playlists[playlistId]['folder']
        if (!newPlaylistData.hasOwnProperty(folder)) {
          newPlaylistData[folder] = {}
        }

        const name = playlists[playlistId]['name']
        const trackString = playlists[playlistId]['track_ids'].join(",")
        newPlaylistData[folder][name] = await this.getSpotifyTracksByIdList(trackString);
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
        const response = await fetch(url, {
          headers: {
            Authorization: `Bearer ${this.accessToken}`
          }
        });
        if (!response.ok) {
          throw new Error(`Error when requesting data. Status code: ${response.status}`);
        }
        return await response.json();
      } catch (error) {
        alert(error.message)
        throw error;
      }
    },
    async getSpotifyTracksByIdList(track_ids) {
      return await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/tracks_by_ids?ids=${track_ids}`)
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