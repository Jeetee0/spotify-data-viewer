<template>
  <div id="container">
    <h1>Check your artist ({{ Object.keys(artists).length }})</h1>
    <div style="margin-bottom: 10px; padding-bottom: 10px; border-bottom-style: solid; border-width: 2px; border-color: #2c3e50;">
      <select v-model="chosenArtist" id="artistSelect" name="artist">
        <option v-for="artist in artists" :key="artist.id" :value="artist">{{ artist.name }}</option>
      </select>
      <br>
      <div v-if="showSingleArtist" style="margin: 15px">
        <a :href="selectedArtist.spotify_url" target="_blank"><img :src="selectedArtist.image_url" alt="Album Cover"
                                                                   style="height: 150px; width: 150px; border-radius: 15px"></a>
        <h2 style="font-weight: bold">{{ selectedArtist.name }}</h2>
        <p><span style="font-weight: bold;">Popularity:</span> {{ selectedArtist.popularity }} / 100</p>
        <p><span style="font-weight: bold;">Followers:</span> {{ (selectedArtist.followers).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") }}</p>
        <p><span style="font-weight: bold;">Genres:</span> {{ selectedArtist.genres }}</p>
      </div>

    </div>

    <h1>Find artists by genre</h1>
    <div id="genre-selector-div">
      <h4>Select a spotify genre ({{ genres.length }}):</h4>
      <select v-model="selectedGenre" id="genreSelect" name="genre">
        <option v-for="genre in genres" :key="genre" :value="genre">{{ genre }}</option>
      </select>
    </div>
    <div>
      <div id="artist-arrangement-div">
        <div class="artist-div" v-for="artist in this.artistsForGenre" :key="artist.id">

          <a :href="artist.spotify_url" target="_blank"><img :src="artist.image_url" alt="Album Cover"
                                                             style="height: 150px; width: 150px; border-radius: 15px"></a>
          <h2 style="font-weight: bold">{{ artist.name }}</h2>
          <p><span style="font-weight: bold;">Popularity:</span> {{ artist.popularity }}/100</p>
          <p><span style="font-weight: bold;">Followers:</span> {{ (artist.followers).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") }}</p>
          <p><span style="font-weight: bold; font-size: 10px">ID:</span> {{ artist.id }}</p>
        </div>
      </div>
    </div>
  </div>

</template>

<script>

export default {
  components: {},
  data() {
    return {
      artists: [],
      genres: [],
      artistsForGenre: [],
      selectedGenre: "",

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
  margin-left: 15px;
  width: 100%;
}

#genre-selector-div {
  width: 100%;

  margin-bottom: 10px;
  padding-bottom: 10px;

  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

#artist-arrangement-div {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  width: 100%;
  max-width: 2000px;

  margin-top: 10px;
}

.artist-div {
  flex: 0 0 calc(9.5% - 5px); /* Adjust the width as needed*/
  box-sizing: border-box;
  margin: 5px;
  text-align: center;
  font-size: 12px;
}
</style>