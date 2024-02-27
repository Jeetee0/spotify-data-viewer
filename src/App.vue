<template>
  <div id="wrapper">
    <div id="body">
      <div id="navigation-bar-div">
        <div id="small-title-div">
          <a href="https://soundcloud.com/kineticenergyberlin" title="Kinetic Energy @ Soundcloud" target="_blank">
            <img src="./assets/KELogo.png" alt="KE Logo" style="height: 200px; width: 200px; border-radius: 15px;">
          </a>

          <h2 style="font-weight: bold;">Spotify Library Management</h2>
        </div>
        <button v-if="showLoginButton" @click="login">Login
        </button>
        <div v-if="!showLoginButton" id="navigation-buttons-div" :class="{ 'disabled': isContentDisabled }">
          <h3 style="font-weight: bold; padding-left: 6px;">General</h3>
          <button @click="showArtistAndGenreComponent" :disabled="showArtistAndGenre">Lookup</button>
          <button @click="showDiscoverComponent" :disabled="showDiscover">Discover</button>
          <button @click="showImportComponent" :disabled="showImport">Import</button>
          <button @click="showSpotifyUserData" :disabled="showUserData">Spotify user data</button>

          <div style="height: 50px;"></div>

          <h3 style="font-weight: bold; padding-left: 6px;">KE Spotify Data</h3>
          <div :class="{ 'disabled': isNotOwner }">
            <button @click="showDiffComponent" :disabled="showDiff">Playlist Diff</button>
            <button @click="showLatestPlaylistState" :disabled="showPlaylistState">Playlist State</button>
            <button @click="showPlaylistDetailComponent" :disabled="showPlaylistDetail">Playlist Detail</button>
            <button @click="exportSpotifyState" :disabled="disabledExport">Export current State</button>
          </div>




        </div>

      </div>
      <main>
        <EntryPage v-if="showInfoText"></EntryPage>

        <Lookup v-if="showArtistAndGenre" :tracks="tracks" :artists="artists" :genres="genres"></Lookup>
        <Discover v-if="showDiscover" :tracks="tracks" :artists="artists" :genres="genres"></Discover>
        <Import v-if="showImport"></Import>
        <UserData v-if="showUserData" :accessToken="accessToken"></UserData>

        <DiffState v-if="showDiff" @open-playlist-detail-component-in-app="showPlaylistDetailComponent"
          :accessToken="accessToken"></DiffState>
        <PlaylistState v-if="showPlaylistState" @open-playlist-detail-component-in-app="showPlaylistDetailComponent"
          :accessToken="accessToken"></PlaylistState>
        <PlaylistDetail v-if="showPlaylistDetail" :playlistIdInit=this.selectedPlaylistId></PlaylistDetail>

      </main>
    </div>
  </div>
</template>

<script>
import DiffState from "@/components/DiffState.vue";
import PlaylistState from "@/components/PlaylistState.vue";
import UserData from "@/components/UserData.vue";
import PlaylistDetail from "@/components/PlaylistDetail.vue";
import Lookup from "@/components/Lookup.vue"
import Discover from "@/components/Discover.vue"
import Import from "@/components/Import.vue"
import EntryPage from "@/components/EntryPage.vue"

export default {
  name: "App",
  data() {
    return {
      accessToken: "",
      isContentDisabled: true,
      isNotOwner: true,

      showInfoText: true,
      showDiff: false,
      showPlaylistState: false,
      showUserData: false,
      disabledExport: false,
      showPlaylistDetail: false,
      showArtistAndGenre: false,
      showDiscover: false,
      showImport: false,
      selectedPlaylistId: "",
      showLoginButton: true,

      tracks: [],
      artists: [],
      genres: [],
      latestPlaylistState: {},

      backendHost: import.meta.env.VITE_BACKEND_HOST,
      backendPort: import.meta.env.VITE_BACKEND_PORT,
    };
  },
  components: {
    Lookup,
    PlaylistDetail,
    DiffState,
    PlaylistState,
    UserData,
    Discover,
    Import,
    EntryPage,
    EntryPage
  },
  async mounted() {
  },
  async created() {
    const params = (new URL(document.location)).searchParams;
    const token = params.get('token');
    const userId = params.get('user_id');
    if (token !== null && this.tokenIsStillValid(params)) {
      this.requestInitialData();
      this.showLoginButton = false;
      this.accessToken = token;
      if (userId === "jeetee0") {
        this.isNotOwner = false;
      }
    }
  },
  methods: {
    tokenIsStillValid(queryParams) {
      const expiryDateString = queryParams.get('expiry_date');
      if (expiryDateString == null || expiryDateString == "")
        return false;
      const expiryDate = new Date(Date.parse(expiryDateString));
      if (expiryDate > new Date()) {
        return true;
      } else {
        return false;
      }
    },
    async requestInitialData() {
      this.tracks = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/tracks`)
      const response = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/artists_and_genres`)
      this.genres = response.genres;
      this.artists = response.artists;
      this.isContentDisabled = false;
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
    enableNavigationButtons() {
      this.showInfoText = false;
      this.showDiff = true;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
      this.showImport = false;
    },
    showDiffComponent() {
      this.showInfoText = false;
      this.showDiff = true;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
      this.showImport = false;
    },
    showLatestPlaylistState() {
      this.showInfoText = false;
      this.showDiff = false;
      this.showPlaylistState = true;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
      this.showImport = false;
    },
    showSpotifyUserData() {
      this.showInfoText = false;
      this.showDiff = false;
      this.showPlaylistState = false;
      this.showUserData = true;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
      this.showImport = false;
    },
    showPlaylistDetailComponent(playlistId = "") {
      this.showInfoText = false;
      this.selectedPlaylistId = playlistId
      this.showDiff = false;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = true;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
      this.showImport = false;
    },
    showArtistAndGenreComponent() {
      this.showInfoText = false;
      this.showDiff = false;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = true;
      this.showDiscover = false;
      this.showImport = false;
    },
    showDiscoverComponent() {
      this.showInfoText = false;
      this.showDiff = false;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = true;
      this.showImport = false;
    },
    showImportComponent() {
      this.showInfoText = false;
      this.showDiff = false;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
      this.showImport = true;
    },
    async exportSpotifyState() {
      this.disabledExport = true;
      const response = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/trigger_complete_data_retrieval`)
      alert(`Export Status: ${response.status}\nAmount of playlists: '${response.amount_of_playlists}'\nTotal amount of tracks in all playlists: '${response.total_amount_of_tracks_in_playlists}'`)
    },
    login() {
      try {
        window.location.href = `${this.backendHost}:${this.backendPort}/spotify/request_access_token?source=frontend`;
      } catch (error) {
        console.error("Error during the OAuth process:", error);
      }
    }
  }
}
</script>

<style scoped>
#wrapper {
  display: flex;
  flex-direction: column;
  width: 100vw;
  height: 100vh;
  overflow: hidden;
}

#title-div {
  display: flex;
  align-items: center;
  color: black;
  padding-bottom: 15px;

  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

#body {
  width: 100vw;
  height: 100vw;
  display: flex;
  flex-direction: row;
  overflow: hidden;
}

#navigation-bar-div {
  width: 240px;
  padding: 10px 10px;
  color: black;
}

* {
  box-sizing: border-box;
}

main {
  flex: 1;
  overflow-y: auto;

  border-left-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

button {
  height: 50px;
  width: 200px;
  font-size: 18px;
  display: block;
  margin: 6px 5px;
}

.disabled {
  pointer-events: none;
  opacity: 0.5;
}

#small-title-div {
  display: flex;
  flex-direction: column;
  font-weight: bold;
  justify-content: center;
  align-items: center;
  text-align: center;
  padding-bottom: 35px;
}
</style>