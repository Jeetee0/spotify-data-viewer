<template>
  <div class="playlist-detail" style="color: black; margin-left: 15px">
    <div id="info-selector-div">
      <h1>{{ title }}</h1>
      <label for="playlistId" style="margin-right: 15px">Spotify playlist ID:</label>
      <input v-model="playlistId" id="playlistId" placeholder="Enter playlist ID" style="margin-right: 15px; min-width: 220px"/>
      <button @click="fetchPlaylistData" style="margin-bottom: 15px">Fetch Playlist</button>
    </div>

    <div v-if="playlist">
      <h2 style="font-weight: bold">Playlist '{{ playlist.name }}'</h2>
      <div id="playlist-overview-div">
        <div style="margin: 10px; ">
          <a :href="playlist.spotify_url" target="_blank"><img :src="playlist.image_url" alt="Playlist Cover"
                                                               style="height: 200px; width: 200px; border-radius: 15px"></a>
        </div>
        <div style="margin: 10px; max-width: 400px">
          <p><span style="font-weight: bold;">Owner:</span> {{ playlist.owner_id }}</p>
          <p><span style="font-weight: bold;">Number of Tracks:</span> {{ playlist.amount_of_tracks }}</p>
          <p><span style="font-weight: bold;">Folder:</span> {{ playlist.folder }}</p>
          <p><span style="font-weight: bold;">Unique Artists:</span> {{ playlist.genre_classification.unique_artists }}</p>
          <p><span style="font-weight: bold;">Unique Genres:</span> {{ playlist.genre_classification.unique_genres }}</p>
          <p><span style="font-weight: bold;">Description:</span> {{ playlist.description }}</p>
        </div>
        <div style="margin: 10px;">
          <h2>Genre Classification</h2>
          <ol class="bold-numbering">
            <li v-for="(count, genre) in Object.fromEntries(Object.entries(playlist.genre_classification.genres).slice(0, 5))"
                :key="genre">
              {{ genre }}: {{ count }}
            </li>
          </ol>
        </div>
        <div style="margin: 10px">
          <h2>Top Artists</h2>
          <ol class="bold-numbering">
            <li v-for="(artist, id) in Object.fromEntries(Object.entries(playlist.genre_classification.artists).slice(0, 5))"
                :key="id">
              {{ artist.name }} - {{ artist.amount }}
            </li>
          </ol>
        </div>
      </div>


    </div>
    <div>
      <h2 style="font-weight: bold">Tracks</h2>
      <track-arrangement-view :tracks="this.trackList"></track-arrangement-view>

    </div>

    <!-- Display an error message if there is an issue with the fetch -->
    <p v-if="error">{{ error }}</p>
  </div>
</template>

<script>
import PlaylistView from "@/components/TrackView.vue";
import TrackArrangementView from "@/components/TrackArrangementView.vue";

export default {
  components: {
    TrackArrangementView,
    PlaylistView
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
      playlist: null,
      trackList: null,
      error: null,
    };
  },
  async created() {
    if (this.playlistIdInit !== "") {
      this.playlistId = this.playlistIdInit
      this.fetchPlaylistData()
    }

  },
  methods: {
    async fetchPlaylistData() {
      this.playlist = null;
      this.error = null;

      try {
        const backendHost = import.meta.env.VITE_BACKEND_HOST;
        const backendPort = import.meta.env.VITE_BACKEND_PORT;
        const response = await this.fetchData(`http://${backendHost}:${backendPort}/spotify/playlists_by_ids?ids=${this.playlistId}`);

        // Update the component's data with the fetched playlist
        this.playlist = response[0];
        console.log(this.playlist['track_ids'])

        // create track view component
        this.trackList = {};
        const trackIdsInPlaylist = this.playlist['track_ids'];
        let trackString = "";
        for (const spot_id in trackIdsInPlaylist) {
          trackString += trackIdsInPlaylist[spot_id] + ","
        }
        trackString = trackString.slice(0, -1);
        this.trackList = await this.getSpotifyTracksByIdList(trackString);
        console.log(this.trackList)
      } catch (error) {
        // Handle any fetch errors
        this.error = 'Error fetching playlist data. Please check the ID and try again.';
        console.log(error)
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
    getArtistsNames(artists) {
      return artists.map(artist => artist.name).join(', ');
    },
  }
}
</script>


<style scoped>
#info-selector-div {
  margin-bottom: 15px;
  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

#playlist-overview-div {
  display: flex;
  flex-direction: row;

  margin-bottom: 15px;
  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

.bold-numbering {
  list-style-type: none; /* Remove default list styling */
  counter-reset: my-counter; /* Reset the counter for custom numbering */
}

.bold-numbering li {
  counter-increment: my-counter;
}
.bold-numbering li::before {
  content: counter(my-counter); /* Use the counter value as content */
  font-weight: bold; /* Make the numbering bold */
  margin-right: 5px; /* Optional: Add some spacing between the numbering and text */
}
</style>