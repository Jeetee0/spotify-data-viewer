

<template>
  <div id="wrapper">
    <div id="header" >
      <img src="./assets/spotify.svg" alt="Spotify Logo" style="height: 50px; width: 50px; border-radius: 15px; margin-right: 15px">
      <h1 style="font-weight: bold; font-size: 42px">Spotify Library Management</h1>
      <img src="./assets/KELogo.png" alt="KE Logo" style="height: 50px; width: 50px; border-radius: 15px; margin-right: 15px; margin-left: 15px">
    </div>
    <div id="body">
      <div id="navigation-bar-div">

        <button @click="showDiffComponent" :disabled="showDiff">Playlist Diff</button>
        <button @click="showLatestPlaylistState" :disabled="showPlaylistState">Playlist State</button>
        <button @click="showPlaylistDetailComponent" :disabled="showPlaylistDetail">Playlist Detail</button>
        <button @click="showSpotifyUserData" :disabled="showUserData">Spotify user data</button>
        <button @click="showArtistAndGenreComponent" :disabled="showArtistAndGenre">Artist & Genre</button>
        <button @click="showDiscoverComponent" :disabled="showDiscover">Discover</button>
        <button @click="exportSpotifyState" :disabled="disabledExport" style="position: absolute; bottom: 0; margin: 15px 5px">Export current State</button>
      </div>
      <main>
        <DiffState v-if="showDiff" @open-playlist-detail-component-in-app="showPlaylistDetailComponent"></DiffState>
        <PlaylistState v-if="showPlaylistState" @open-playlist-detail-component-in-app="showPlaylistDetailComponent"></PlaylistState>
        <UserData v-if="showUserData"></UserData>
        <PlaylistDetail v-if="showPlaylistDetail" :playlistIdInit=this.selectedPlaylistId></PlaylistDetail>
        <ArtistAndGenre v-if="showArtistAndGenre"></ArtistAndGenre>
        <Discover v-if="showDiscover"></Discover>
      </main>
    </div>
  </div>


</template>

<script>
import DiffState from "@/components/DiffState.vue";
import PlaylistState from "@/components/PlaylistState.vue";
import UserData from "@/components/UserData.vue";
import PlaylistDetail from "@/components/PlaylistDetail.vue";
import ArtistAndGenre from "@/components/ArtistAndGenre.vue"
import Discover from "@/components/Discover.vue"

export default {
  name: "App",
  data() {
    return {
      showDiff: true,
      showPlaylistState: false,
      showUserData: false,
      disabledExport: false,
      showPlaylistDetail: false,
      showArtistAndGenre: false,
      showDiscover: false,
      selectedPlaylistId: "",
    };
  },
  components: {
    ArtistAndGenre,
    PlaylistDetail,
    DiffState,
    PlaylistState,
    UserData,
    Discover
  },
  methods: {
    showDiffComponent() {
      this.showDiff = true;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
    },
    showLatestPlaylistState() {
      this.showDiff = false;
      this.showPlaylistState = true;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
    },
    showSpotifyUserData() {
      this.showDiff = false;
      this.showPlaylistState = false;
      this.showUserData = true;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
    },
    showPlaylistDetailComponent(playlistId="") {
      this.selectedPlaylistId = playlistId
      this.showDiff = false;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = true;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
    },
    showArtistAndGenreComponent() {
      this.showDiff = false;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = true;
      this.showDiscover = false;
    },
    showDiscoverComponent() {
      this.showDiff = false;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = true;
    },
    exportSpotifyState() {
      this.disabledExport = true;
      const backendHost = import.meta.env.VITE_BACKEND_HOST;
      const backendPort = import.meta.env.VITE_BACKEND_PORT;
      try {
        fetch(`http://${backendHost}:${backendPort}/spotify/trigger_complete_data_retrieval`, {
          method: 'GET',
          headers: {
          }
        })
            .then(response => {
              response.json().then(res => alert(res));
            })
            .catch(err => {
              console.error(err);
            });
      } catch (error) {
        console.error("Error during exporting spotify state", error)
      }
    },
  },

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
#header {
  display: flex;
  height: 100px;
  justify-content: center;
  align-items: center;
  color: black;
  padding: 15px 0;

  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}
#body {
  flex: 1;
  display: flex;
  flex-direction: row;
  overflow: hidden;
}

#navigation-bar-div {
  width: 240px;
  padding: 10px 10px;
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
</style>