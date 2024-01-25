<template>
  <div id="container">
    <div id="artist-view-div">
      <h1>Get artist info </h1>
      <h4>Select an artist ({{ Object.keys(artists).length }}):</h4>
      <select v-model="chosenArtist" id="artistSelect" name="artist" style="width: 225px">
        <option v-for="artist in artists" :key="artist.id" :value="artist">{{ artist.name }}</option>
      </select>
      <br>
      <div v-if="showSingleArtist" style="padding-top: 15px">
        <a :href="selectedArtist.spotify_url" target="_blank"><img :src="selectedArtist.image_url" alt="Album Cover"
                                                                   style="height: 150px; width: 150px; border-radius: 15px"></a>
        <h2 style="font-weight: bold">{{ selectedArtist.name }}</h2>
        <p><span style="font-weight: bold;">Popularity:</span> {{ selectedArtist.popularity }} / 100</p>
        <p><span style="font-weight: bold;">Followers:</span> {{ (selectedArtist.followers).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") }}</p>
        <p><span style="font-weight: bold;">Genres:</span> {{ selectedArtist.genres }}</p>
        <p><span style="font-weight: bold;">ID: </span>{{ selectedArtist.id }}</p>
      </div>

    </div>
    <div id="genre-view-div">
      <h1>Find artists by genre</h1>
      <div id="genre-selector-div" style="padding-bottom: 15px;">
        <h4>Select a spotify genre ({{ genres.length }}):</h4>
        <input v-model="genreFilter" placeholder="Type to filter genre" /><br>
        <select v-model="selectedGenre" id="genreSelect" name="genre" style="width: 250px;">
          <option v-for="genre in filteredGenres" :key="genre" :value="genre">{{ genre }}</option>
        </select>
      </div>
      <artist-arrangement-view :artistsForGenre="this.artistsForGenre"></artist-arrangement-view>
    </div>


  </div>

</template>

<script>
import ArtistArrangementView from "@/components/Arrangements/ArtistArrangementView.vue";

export default {
  components: {ArtistArrangementView},
  data() {
    return {
      artists: [],
      genres: [],
      artistsForGenre: [],
      selectedGenre: "",
      genreFilter: "",

      showSingleArtist: false,
      chosenArtist: null,
      selectedArtist: null,
    };
  },
  async created() {
    const backendHost = import.meta.env.VITE_BACKEND_HOST;
    const backendPort = import.meta.env.VITE_BACKEND_PORT;
    this.genres = await this.fetchData(`http://${backendHost}:${backendPort}/spotify/genres`)
    this.artists = await this.fetchData(`http://${backendHost}:${backendPort}/spotify/artists`)

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
    chosenArtist(selectedArtist) {
      console.log(selectedArtist)
      if (selectedArtist === null || selectedArtist.name === "") {
        this.showSingleArtist = false;
      }
      else {
        this.getArtist(selectedArtist.name);
      }

    },
  },
  methods: {
    selectArtist(selectedArtist) {
      this.chosenArtist = selectedArtist;
    },
    async getArtistsForGenre(genre) {
      const backendHost = import.meta.env.VITE_BACKEND_HOST;
      const backendPort = import.meta.env.VITE_BACKEND_PORT;
      this.artistsForGenre = await this.fetchData(`http://${backendHost}:${backendPort}/spotify/artists_for_genre?genre=${genre}`)
    },
    async getArtist(artistName) {
        const backendHost = import.meta.env.VITE_BACKEND_HOST;
        const backendPort = import.meta.env.VITE_BACKEND_PORT;
        const response = await this.fetchData(`http://${backendHost}:${backendPort}/spotify/artists_by_name?names=${artistName}`)
        this.selectedArtist = response[0]
        this.showSingleArtist = true
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
</style>