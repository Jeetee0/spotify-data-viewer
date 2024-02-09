<template>
  <div style="color: black;">
    <div style="padding: 5px 15px;">
      <h1>{{ title }}</h1>
      <div style="display: flex; flex-direction: row; align-content: center; ">
        <p style="font-size: 14px">Amount of latest states combined:</p>
        <input type="number" id="quantity" v-model="diffAmount" min="1" max="25" width="100px"
               style="max-width: 50px; margin-left: 20px">
      </div>
    </div>
    <div class="bottom-line-div"></div>
    <div id="playlist-view-div">
      <playlist-folder-arrangement :playlistsWithFolders="playlistData" :renderExtendedDiv="true"
                                   @open-playlist-detail-component="openPlaylistDetail"/>
    </div>
  </div>
</template>

<script>
import PlaylistFolderArrangement from "@/components/Arrangements/PlaylistFolderArrangement.vue";

export default {
  components: {
    PlaylistFolderArrangement
  },
  props: {
    latestPlaylistState: Object,
  },
  data() {
    return {
      title: 'Playlist diff - Newly fetched tracks from Spotify state',
      playlistData: {},
      diffAmount: 5,

      backendHost: import.meta.env.VITE_BACKEND_HOST,
      backendPort: import.meta.env.VITE_BACKEND_PORT,
    };
  },
  async created() {
    await this.getLatestDiffs()
  },
  watch: {
    diffAmount(newValue) {
      this.getLatestDiffs(newValue);
    },
  },
  methods: {
    async getLatestDiffs() {
      const response = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/latest_diff_states?amount=${this.diffAmount}`)
      // combine newTracks and playlists
      let result = {}
      for (const diffStateId in response) {
        const diffState = response[diffStateId]["new_tracks"]
        for (const playlistName in diffState) {
          if (!(playlistName in result)) {
            result[playlistName] = diffState[playlistName]
          } else {
            result[playlistName] = result[playlistName].concat(diffState[playlistName])
          }
        }
      }

      let newPlaylistData = {};

      let playlistNameFolderNameMatchingDict = {};
      for (const folderName in this.latestPlaylistState) {
        for (const playlistName in this.latestPlaylistState[folderName]) {
          playlistNameFolderNameMatchingDict[playlistName] = folderName
        }
      }

      for (const playlistName in result) {
        if (result.hasOwnProperty(playlistName)) {
          const trackIdsInPlaylist = result[playlistName];
          let trackString = "";
          for (const spot_id in trackIdsInPlaylist) {
            trackString += trackIdsInPlaylist[spot_id] + ","
          }
          trackString = trackString.slice(0, -1);
          const folderName = playlistNameFolderNameMatchingDict[playlistName]

          if (!newPlaylistData.hasOwnProperty(folderName)) {
            newPlaylistData[folderName] = {}
          }
          newPlaylistData[folderName][playlistName] = await this.getSpotifyTracksByIdList(trackString);
        }
      }
      this.playlistData = newPlaylistData;
      console.log(this.playlistData)
    },
    async openPlaylistDetail(playlistName) {
      const response = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/latest_playlist_states?amount=${1}`)
      const playlists = response[0]['playlists']
      for (const playlistId in playlists) {
        if (playlists[playlistId]['name'] === playlistName) {
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
      return await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/tracks_by_ids?ids=${track_ids}`)
    },
  },
};
</script>

<style scoped>
.bottom-line-div {
  padding: 5px 0px;
  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}
</style>