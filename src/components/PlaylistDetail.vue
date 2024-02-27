<template>
  <div class="playlist-detail" style="color: black;">
    <div id="info-selector-div">
      <h1>{{ title }}</h1>
      <label for="playlistId" style="margin-right: 15px">Spotify playlist ID:</label>
      <input v-model="playlistId" id="playlistId" placeholder="Enter playlist ID"
        style="margin-right: 15px; min-width: 220px" />
      <button @click="fetchPlaylistData">Fetch Playlist</button>
    </div>
    <div class="bottom-line-div"></div>

    <div v-if="playlistFound">
      <div id="playlist-overview-div" style="padding: 5px 15px">
        <h2 style="font-weight: bold">Playlist '{{ playlist.name }}'</h2>
        <div id="columns-div">
          <div style="padding: 10px">
            <a :href="playlist.spotify_url" target="_blank"><img :src="playlist.image_url" alt="Playlist Cover"
                @mouseover="handlePlaylistMouseOver(true)" @mouseout="handlePlaylistMouseOver(false)"
                style="height: 200px; width: 200px; border-radius: 15px"></a>
          </div>
          <div style="padding: 10px; max-width: 400px">
            <p><span style="font-weight: bold;">Owner:</span> {{ playlist.owner_id }}</p>
            <p><span style="font-weight: bold;">Number of Tracks:</span> {{ playlist.amount_of_tracks }}</p>
            <p><span style="font-weight: bold;">Folder:</span> {{ playlist.folder }}</p>
            <p><span style="font-weight: bold;">Unique Artists:</span> {{
              playlist.genre_classification.unique_artists
            }}</p>
            <p><span style="font-weight: bold;">Unique Genres:</span> {{ playlist.genre_classification.unique_genres }}
            </p>
            <p><span style="font-weight: bold;">Description:</span> {{ playlist.description }}</p>
          </div>
          <div style="padding: 10px;">
            <h2>Genre Classification</h2>
            <ol class="bold-numbering">
              <li
                v-for="(count, genre) in Object.fromEntries(Object.entries(playlist.genre_classification.genres).slice(0, 5))"
                :key="genre">
                {{ genre }}: {{ count }}
              </li>
            </ol>
          </div>
          <div style="padding: 10px">
            <h2>Top Artists</h2>
            <ol class="bold-numbering">
              <li
                v-for="(artist, id) in Object.fromEntries(Object.entries(playlist.genre_classification.artists).slice(0, 5))"
                :key="id">
                {{ artist.name }} - {{ artist.amount }}
              </li>
            </ol>
          </div>
        </div>

      </div>
    </div>
    <div v-if="playlistFound" class="bottom-line-div"></div>
    <div v-if="playlistFound" style="padding: 5px 15px;">
      <h2 style="font-weight: bold; padding-bottom: 5px;">Tracks</h2>
      <track-arrangement-view :tracks="this.trackList" popupInfoText="Open track in Spotify"
        @track-clicked="openTrackInSpotify"></track-arrangement-view>
    </div>
    <p v-if="error">{{ error }}</p>
  </div>

  <popup :showPopup="showInfoPopup" :infoText="popupInfoText"></popup>
</template>

<script>
import PlaylistView from "@/components/Arrangements/PlaylistArrangementView.vue";
import TrackArrangementView from "@/components/Arrangements/TrackArrangementView.vue";
import Popup from '@/components/Popup.vue'

export default {
  components: {
    TrackArrangementView,
    PlaylistView,
    Popup
  },
  props: {
    playlistIdInit: {
      type: String,
      required: false,
    },
  },
  data() {
    return {
      title: 'Playlist Detail View',
      playlistId: "",
      playlistFound: false,
      playlist: null,
      trackList: null,
      error: null,

      showInfoPopup: false,
      popupInfoText: "Open playlist in Spotify",

      backendHost: import.meta.env.VITE_BACKEND_HOST,
      backendPort: import.meta.env.VITE_BACKEND_PORT,
    };
  },
  async created() {
    this.playlistId = "";
    if (typeof this.playlistIdInit === 'string' && this.playlistIdInit !== "") {
      this.playlistId = this.playlistIdInit
      this.fetchPlaylistData()
    }
  },
  methods: {
    async fetchPlaylistData() {
      this.playlist = null;
      this.error = null;
      if (this.playlistId === "")
        return;

      const response = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/playlists_by_ids?ids=${this.playlistId}`);
      this.playlist = response[0];

      // create track view component
      this.trackList = {};
      const trackIdsInPlaylist = this.playlist['track_ids'];
      let trackString = "";
      for (const spot_id in trackIdsInPlaylist) {
        trackString += trackIdsInPlaylist[spot_id] + ","
      }
      trackString = trackString.slice(0, -1);
      this.trackList = await this.getSpotifyTracksByIdList(trackString);
      console.log(this.trackList.length)
      this.playlistFound = true;
    },
    async fetchData(url) {
      try {
        const response = await fetch(url);
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
    getArtistsNames(artists) {
      return artists.map(artist => artist.name).join(', ');
    },
    handlePlaylistMouseOver(value) {
      this.showInfoPopup = value;
    },
    openTrackInSpotify(track) {
      window.open(track.spotify_url)
    }
  }
}
</script>


<style scoped>
#info-selector-div {
  margin: 15px 15px;
}

#columns-div {
  display: flex;
  flex-direction: row;
}

.bottom-line-div {
  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
  margin: 0px 0px
}

.bold-numbering {
  list-style-type: none;
  /* Remove default list styling */
  counter-reset: my-counter;
  /* Reset the counter for custom numbering */
}

.bold-numbering li {
  counter-increment: my-counter;
}

.bold-numbering li::before {
  content: counter(my-counter);
  /* Use the counter value as content */
  font-weight: bold;
  /* Make the numbering bold */
  margin-right: 5px;
  /* Optional: Add some spacing between the numbering and text */
}
</style>