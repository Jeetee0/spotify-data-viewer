<template>
  <div id="wrapper">
    <div id="header">
      <img src="./assets/spotify.svg" alt="Spotify Logo"
           style="height: 50px; width: 50px; border-radius: 15px; margin-right: 15px">
      <h1 style="font-weight: bold; font-size: 42px">Spotify Library Management</h1>
      <img src="./assets/KELogo.png" alt="KE Logo"
           style="height: 50px; width: 50px; border-radius: 15px; margin-right: 15px; margin-left: 15px">
    </div>
    <div id="body">
      <div id="navigation-bar-div">
        <h3 style="font-weight: bold; padding-left: 6px;">General</h3>
        <button @click="showArtistAndGenreComponent" :disabled="showArtistAndGenre">Lookup</button>
        <button @click="showDiscoverComponent" :disabled="showDiscover">Discover</button>

        <div style="height: 50px;"></div>

        <h3 style="font-weight: bold; padding-left: 6px;">KE Spotify Data</h3>
        <button @click="showDiffComponent" :disabled="showDiff">Playlist Diff</button>
        <button @click="showLatestPlaylistState" :disabled="showPlaylistState">Playlist State</button>
        <button @click="showPlaylistDetailComponent" :disabled="showPlaylistDetail">Playlist Detail</button>
        <button @click="showSpotifyUserData" :disabled="showUserData">Spotify user data</button>

        <button @click="exportSpotifyState" :disabled="disabledExport"
                style="position: absolute; bottom: 0; margin: 15px 5px">Export current State
        </button>
      </div>
      <main>
        <div v-if="showInfoText" style="color: black; padding: 5px 15px;">
          <div style="display: flex; flex-direction: row;">
            <div style="width: 30%;">
              <h1 style="font-weight: bold;">Info</h1>
              <p id="infoText" v-html="formattedInfoText"></p>
            </div>
            <div style="padding: 0px 45px; width: 70%;">
              <h1 style="font-weight: bold;">DJ showcase</h1>
              <h2 style="padding-top: 30px; padding-bottom: 10px;">Psychedelic Trance & FullOn Mixes</h2>
              <iframe width="100%" height="350" scrolling="no" frameborder="no" allow="autoplay"
                      src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/1117029487&color=%23ff5500&auto_play=false&hide_related=false&show_comments=false&show_user=true&show_reposts=false&show_teaser=true"></iframe>
              <div
                  style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;">
                <a href="https://soundcloud.com/kineticenergyberlin" title="Kinetic Energy" target="_blank"
                   style="color: #cccccc; text-decoration: none;">Kinetic Energy</a> · <a
                  href="https://soundcloud.com/kineticenergyberlin/sets/psytrance"
                  title="Psychedelic Trance &amp; FullOn-Psy [~145]" target="_blank"
                  style="color: #cccccc; text-decoration: none;">Psychedelic Trance &amp; FullOn-Psy [~145]</a></div>

              <h2 style="padding-top: 30px; padding-bottom: 10px;">Happy Hard Trance, Techno Rave Playlist</h2>
              <iframe width="100%" height="350" scrolling="no" frameborder="no" allow="autoplay"
                      src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/1639749280&color=%23ff5500&auto_play=false&hide_related=false&show_comments=false&show_user=true&show_reposts=false&show_teaser=true"></iframe>
              <div
                  style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;">
                <a href="https://soundcloud.com/kineticenergyberlin" title="Kinetic Energy" target="_blank"
                   style="color: #cccccc; text-decoration: none;">Kinetic Energy</a> · <a
                  href="https://soundcloud.com/kineticenergyberlin/sets/summer-trance-happy-fast"
                  title="Summer Trance (Happy & Fast)" target="_blank" style="color: #cccccc; text-decoration: none;">Summer
                Trance (Happy & Fast)</a></div>
            </div>
          </div>


        </div>
        <DiffState v-if="showDiff" @open-playlist-detail-component-in-app="showPlaylistDetailComponent"></DiffState>
        <PlaylistState v-if="showPlaylistState"
                       @open-playlist-detail-component-in-app="showPlaylistDetailComponent"></PlaylistState>
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
import {infoText} from "@/assets/infoText.js";

export default {
  name: "App",
  data() {
    return {
      infoTextContent: infoText,
      showInfoText: true,
      showDiff: false,
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
      this.showInfoText = false;
      this.showDiff = true;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
    },
    showLatestPlaylistState() {
      this.showInfoText = false;
      this.showDiff = false;
      this.showPlaylistState = true;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
    },
    showSpotifyUserData() {
      this.showInfoText = false;
      this.showDiff = false;
      this.showPlaylistState = false;
      this.showUserData = true;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = false;
      this.showDiscover = false;
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
    },
    showArtistAndGenreComponent() {
      this.showInfoText = false;
      this.showDiff = false;
      this.showPlaylistState = false;
      this.showUserData = false;
      this.showPlaylistDetail = false;
      this.showArtistAndGenre = true;
      this.showDiscover = false;
    },
    showDiscoverComponent() {
      this.showInfoText = false;
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
        fetch(`${backendHost}:${backendPort}/spotify/trigger_complete_data_retrieval`, {
          method: 'GET',
          headers: {}
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
  computed: {
    formattedInfoText() {
      return this.infoTextContent.replace(/\n/g, '<br>');
    },
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

#infoText {
  font-size: 18px;
  background-color: #eeeeee;
  border-radius: 15px;
  padding: 15px 15px;
  display: inline-block;
}
</style>