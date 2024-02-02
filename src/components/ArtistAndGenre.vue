<template>
  <div id="container">
    <div id="artist-view-div">
      <h1>Get artist info </h1>
      <h4>Select an artist ({{ Object.keys(artists).length }}):</h4>
      <select v-model="chosenArtist" id="artistSelect" name="artist" style="width: 225px">
        <option v-for="artist in artists" :key="artist.id" :value="artist">{{ artist.name }}</option>
      </select>
      <br>
      <div class="row-div" v-if="chosenArtist">
        <div v-if="showSingleArtist" style="width: 320px">
          <h2 style="font-weight: bold">{{ selectedArtist.name }}</h2>
          <a :href="selectedArtist.spotify_url" target="_blank"><img :src="selectedArtist.image_url" alt="Album Cover"
                                                                     style="height: 200px; width: 200px; border-radius: 15px"></a>

          <div class="row-div" style="max-width: 220px;">
            <div>
              <p style="font-weight: bold;">Popularity:</p>
              <p style="font-weight: bold;">Followers:</p>
              <p style="font-weight: bold;">ID:</p>
              <p style="font-weight: bold;">Genres:</p>
            </div>
            <div style="padding-left: 5px;">
              <p>{{ selectedArtist.popularity }} / 100</p>
              <p>{{ (selectedArtist.followers).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") }}</p>
              <p>{{ selectedArtist.id }}</p>
              <p>{{ selectedArtist.genres }}</p>
            </div>
          </div>
        </div>
        <div>
          <h2 style="">Artist Top Tracks</h2>
          <track-arrangement-view
              :tracks="Object.fromEntries(Object.entries(artistTracks).slice(0, 5))"></track-arrangement-view>
          <h2 style="">Similar Artists</h2>
          <artist-arrangement-view :artists="Object.fromEntries(Object.entries(relatedArtists).slice(0, 5))"
                                   @open-artist-view="selectArtist"></artist-arrangement-view>
        </div>
        <div>

        </div>
      </div>


    </div>
    <div id="genre-view-div">
      <h1>Find artists by genre</h1>
      <div id="genre-selector-div" style="padding-bottom: 15px;">
        <h4>Select a spotify genre ({{ genres.length }}):</h4>
        <input v-model="genreFilter" placeholder="Type to filter genre"/><br>
        <select v-model="selectedGenre" id="genreSelect" name="genre" style="width: 250px;">
          <option v-for="genre in filteredGenres" :key="genre" :value="genre">{{ genre }}</option>
        </select>
      </div>

      <artist-arrangement-view :artists="this.artistsForGenre"
                               @open-artist-view="selectArtist"></artist-arrangement-view>
    </div>
    <div>
      <h1 style="padding: 5px 15px;">Followed artists</h1>
      <artist-arrangement-view style="padding: 5px 15px;" :artists="this.followedArtists"
                               @open-artist-view="selectArtist"></artist-arrangement-view>
    </div>


  </div>

</template>

<script>
import ArtistArrangementView from "@/components/Arrangements/ArtistArrangementView.vue";
import TrackArrangementView from '@/components/Arrangements/TrackArrangementView.vue';

export default {
  components: {ArtistArrangementView, TrackArrangementView},
  data() {
    return {
      artists: [],
      genres: [],
      artistTracks: [],
      relatedArtists: [],
      followedArtists: [],

      artistsForGenre: [],
      selectedGenre: "",
      genreFilter: "",

      showSingleArtist: false,
      chosenArtist: null,
      selectedArtist: null,

      backendHost: import.meta.env.VITE_BACKEND_HOST,
      backendPort: import.meta.env.VITE_BACKEND_PORT,
    };
  },
  async created() {
    const response = await this.fetchData(`http://${this.backendHost}:${this.backendPort}/spotify/artists_and_genres`)
    this.genres = response.genres;
    this.artists = response.artists;

    this.followedArtists = await this.fetchData(`http://${this.backendHost}:${this.backendPort}/spotify/followed_artists`)

  },
  computed: {
    filteredGenres() {
      if (this.genreFilter === "")
        return this.genres;
      return this.genres.filter(genre => genre.toLowerCase().includes(this.genreFilter.toLowerCase()));
    },
  },
  watch: {
    selectedGenre(newValue) {
      this.getArtistsForGenre(newValue);
    },
    async chosenArtist(selectedArtist) {
      this.artistTracks = [];
      this.relatedArtists = [];
      if (selectedArtist === null || selectedArtist.name === "") {
        this.showSingleArtist = false;
        this.selectedArtist = null;
      } else {
        //const response = await this.fetchData(`http://${this.backendHost}:${this.backendPort}/spotify/artist_by_id?artist_id=${selectedArtist.id}`)
        this.selectedArtist = selectedArtist
        this.showSingleArtist = true
        this.artistTracks = await this.fetchData(`http://${this.backendHost}:${this.backendPort}/spotify/artist_top_tracks?artist_id=${selectedArtist.id}`)
        this.relatedArtists = await this.fetchData(`http://${this.backendHost}:${this.backendPort}/spotify/related_artists?artist_id=${selectedArtist.id}`)
      }
    },
  },
  methods: {
    selectArtist(selectedArtist) {
      this.chosenArtist = selectedArtist;
    },
    async getArtistsForGenre(genre) {
      this.artistsForGenre = await this.fetchData(`http://${this.backendHost}:${this.backendPort}/spotify/artists_for_genre?genre=${genre}`)
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
  }
}
</script>

<style scoped>
#container {
  color: black;
}

#artist-view-div {
  padding: 10px 15px;

  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

#genre-view-div {
  padding: 10px 15px;

  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

#artist-arrangement-div {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
}

.artist-div {
  width: 170px;
  box-sizing: border-box;
  margin: 5px;
  text-align: center;
  font-size: 12px;
}

.artist-image {
  transition: transform 0.3s ease-in-out;
  height: 150px;
  width: 150px;
  border-radius: 15px
}

.artist-image:hover {
  transform: scale(1.15);
  z-index: 1;
}

.row-div {
  display: flex;
  flex-direction: row;
}
</style>