<template>
  <div style="color: black;">
    <div id="header-div">
      <h1>Discover new tracks through spotify recommendations</h1>
      <a href="https://developer.spotify.com/documentation/web-api/reference/get-recommendations" target="_blank">More
        info here!</a>
    </div>

    <div id="prepare-request-div" style="display: flex; flex-direction: row;">
      <div id="seed-div">
        <h2 style="font-weight: bold;">Select seeds</h2>
        <p>You can select up to five seeds from the three categories (genres, artists and tracks):</p>
        <div style="display: flex; flex-direction: row; padding-top: 10px">
          <div id="seed-selection-div">
            <label for="genreSelect">Select genre:</label>
            <input v-model="genreFilter" placeholder="Type to filter genres" />
            <select v-model="genreSelected" id="genreSelect" name="genre" :disabled="disableSeedInputs"
                    style="height: 30px; width: 250px; resize: none">
              <option v-for="genreName in filteredGenres" :key="genreName" :value="genreName">{{ genreName }}</option>
            </select>

            <label for="artistSelect" style="padding-top: 6px">Select artist:</label>
            <input v-model="artistFilter" placeholder="Type to filter artists" />
            <select v-model="artistSelected" id="artistSelect" name="artist" :disabled="disableSeedInputs"
                    style="height: 30px; width: 250px; resize: none">
              <option v-for="artist in filteredArtists" :key="artist.id" :value="artist">{{ artist.name }}</option>
            </select>

            <label for="trackSelect" style="padding-top: 6px">Select track:</label>
            <input v-model="trackFilter" placeholder="Type to filter tracks" />
            <select v-model="trackSelected" id="trackSelect" name="track" :disabled="disableSeedInputs"
                    style="height: 30px; width: 250px; resize: none">
              <option v-for="track in filteredTracks" :key="track.id" :value="track">
<!--                <span>{{ track.name }}</span> - <span style="text-align: right">{{ track.b }}</span>-->
                {{ track.name }} -
                {{ track.artists.map(artist => artist.name).join(', ') }}
              </option>
            </select>
          </div>
          <div id="seeds-chosen-div">
            <label for="chosenGenres">Selected genres:</label>
            <div style="display: flex; flex-direction: row; padding-bottom: 18px">
              <textarea disabled="true" rows="1" cols="1" style="height: 40px; width: 250px; resize: none" v-model="chosenGenres"
                        id="chosenGenres"/>
              <button @click="resetChosenGenres" style="margin-left: 15px; width: 70px; font-weight: bold">Reset
              </button>
            </div>

            <label for="chosenArtists">Selected artists:</label>
            <div style="display: flex; flex-direction: row; padding-bottom: 18px">
              <textarea disabled="true" rows="1" cols="1" style="height: 40px; width: 250px; resize: none" v-model="chosenArtists[1]"
                        id="chosenArtists"/>
              <button @click="resetChosenArtists" style="margin-left: 15px; width: 70px; font-weight: bold">Reset
              </button>
            </div>

            <label for="chosenTracks">Selected tracks:</label>
            <div style="display: flex; flex-direction: row;">
              <textarea disabled="true" rows="1" cols="1" style="height: 40px; width: 250px; resize: none" v-model="chosenTracks[1]"
                        id="chosenTracks"/>
              <button @click="resetChosenTracks" style="margin-left: 15px; width: 70px; font-weight: bold">Reset
              </button>
            </div>

          </div>
        </div>
      </div>

      <div id="optional-parameter-div">
        <div id="optional-1-div">
          <h2 style="font-weight: bold">Optional parameters</h2>
          <div class="single-parameter-div">
            <label style="font-weight: bold" for="limit">Limit:</label>
            <input class="parameter-input" v-model="limit" id="limit" type="number" min="1" max="100"
                   @input="handleLimitInput('limit', 1, 100)"/>
            <p style="font-size: 12px; width: 225px; margin-top: 4px;">Select the amount of recommended tracks for the response (1-100):</p>
          </div>
          <div class="single-parameter-div">
            <label for="market" style="font-weight: bold">Market:</label>
            <input class="parameter-input" v-model="market" id="market" type="text"/>
            <p style="font-size: 12px; width: 225px;">You can specify a market with an 'ISO 3166-1 alpha-2' country code (eg. DE, EN, IN etc.):</p>
          </div>
        </div>
        <div id="optional-2-div" style="margin-left: 5px; display: flex; flex-direction: column">
          <div class="single-parameter-div">
            <label for="min_popularity">Min Popularity:</label>
            <input class="parameter-input" v-model="min_popularity" id="min_popularity" type="number" min="0" max="100"
                   @input="handleLimitInput('min_popularity', 0, 100)"/>
            <label for="max_popularity">Max Popularity:</label>
            <input class="parameter-input" v-model="max_popularity" id="max_popularity" type="number" min="0" max="100"
                   @input="handleLimitInput('max_popularity', 0, 100)"/>
            <label for="target_popularity">Target Popularity:</label>
            <input class="parameter-input" v-model="target_popularity" id="target_popularity" type="number" min="0"
                   max="100" @input="handleLimitInput('target_popularity', 0, 100)"/>
          </div>
          <div class="single-parameter-div">
            <label for="min_tempo">Min Tempo:</label>
            <input class="parameter-input" v-model="min_tempo" id="min_tempo" type="number"
                   @input="handleLimitInput('min_tempo', 1, 300)"/>
            <label for="max_tempo">Max Tempo:</label>
            <input class="parameter-input" v-model="max_tempo" id="max_tempo" type="number"
                   @input="handleLimitInput('max_tempo', 1, 300)"/>
            <label for="target_tempo">Target Tempo:</label>
            <input class="parameter-input" v-model="target_tempo" id="target_tempo" type="number"
                   @input="handleLimitInput('target_tempo', 1, 300)"/>
          </div>

        </div>
        <div id="optional-3-div" style="margin-left: 25px; display: flex; flex-direction: column">
          <div class="single-parameter-div">
          </div>
        </div>
      </div>
    </div>
    <div style="display: flex; flex-direction: row; align-items: center; height: 200px;">
      <div style="display: flex; flex-direction: column; margin: 0px 60px;">
        <button
          style="font-size: 22px; height: 50px; width: 200px"
          @click="requestRecommendations">Find tracks
      </button>
      <button
          style="font-size: 16px; margin-top: 10px; height: 28px; width: 200px"
          @click="resetAllParameters">Reset all
      </button>
      </div>

      <div ref="spotifyPlayer" style="margin-top: 25px; margin-bottom: 20px;"></div>
    </div>

    <div id="results-div">
      <h2 style="font-weight: bold; padding-bottom: 10px;">Results</h2>
      <track-arrangement-view :tracks="this.recommendedTracks" :discoverMode="true" @play-track="playTrack"></track-arrangement-view>


    </div>
  </div>


</template>

<script>
import TrackArrangementView from "@/components/Arrangements/TrackArrangementView.vue";

export default {
  components: {
    TrackArrangementView
  },
  data() {
    return {
      genres: {},
      artists: {},
      tracks: {},

      genreSelected: "",
      genreFilter: "",
      artistSelected: "",
      artistFilter: "",
      trackSelected: "",
      trackFilter: "",

      chosenGenres: "",
      chosenGenresCounter: 0,
      chosenArtists: [],
      chosenArtistsCounter: 0,
      chosenTracks: [],
      chosenTracksCounter: 0,
      chosenTotalCounter: 0,

      disableSeedInputs: false,

      limit: 20,
      market: "",
      min_popularity: null,
      max_popularity: null,
      target_popularity: null,
      min_tempo: null,
      max_tempo: null,
      target_tempo: null,

      recommendedTracks: [],


    };
  },
  async created() {
    const backendHost = import.meta.env.VITE_BACKEND_HOST;
    const backendPort = import.meta.env.VITE_BACKEND_PORT;
    this.artists = await this.fetchData(`http://${backendHost}:${backendPort}/spotify/artists`)
    this.genres = await this.fetchData(`http://${backendHost}:${backendPort}/spotify/genres`)
    this.tracks = await this.fetchData(`http://${backendHost}:${backendPort}/spotify/tracks`)

    this.playTrack('6desWeNyiLDZu3lKhckawg');
  },
  computed: {
    filteredGenres() {
      if (this.genreFilter === "")
        return this.genres;
      return this.genres.filter(genre => genre.toLowerCase().includes(this.genreFilter.toLowerCase()));
    },
    filteredArtists() {
      if (this.artistFilter === "")
        return this.artists;
      return this.artists.filter(artist => artist.name.toLowerCase().includes(this.artistFilter.toLowerCase()));
    },
    filteredTracks() {
      if (this.trackFilter === "")
        return this.tracks;
      return this.tracks.filter(track => track.name.toLowerCase().includes(this.trackFilter.toLowerCase()) || 
      track.artists.map(artist => artist.name).join(', ').toLowerCase().includes(this.trackFilter.toLowerCase()));
      
    },
  },
  methods: {
    playTrack(trackId) {
      const spotifyPlayerContainer = this.$refs.spotifyPlayer;
      spotifyPlayerContainer.innerHTML = `<iframe src="https://open.spotify.com/embed/track/${trackId}" width="600" height="155" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>`;
    },
    removeUnnecessaryChars(input) {
      input = input.trimEnd()
      if (input.length > 0 && input.charAt(input.length - 1) === ',') {
        return input.slice(0, -1);
      }
      return input;
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
    async requestRecommendations() {
      const backendHost = import.meta.env.VITE_BACKEND_HOST;
      const backendPort = import.meta.env.VITE_BACKEND_PORT;
      const baseUrl = `http://${backendHost}:${backendPort}/spotify/discover`
      const params = new URLSearchParams();
      if (this.chosenGenres.length > 0)
        params.append('genres', this.removeUnnecessaryChars(this.chosenGenres));
      else
        params.append('genres', "");
      if (this.chosenArtists.length > 0)
        params.append('artists', this.removeUnnecessaryChars(this.chosenArtists[0]));
      else
        params.append('artists', "");
      if (this.chosenTracks.length > 0)
        params.append('tracks', this.removeUnnecessaryChars(this.chosenTracks[0]));
      else
        params.append('tracks', "");

      // optional
      params.append('limit', this.limit)
      if (this.market.length === 2) {
        params.append('market', this.market.toUpperCase())
        console.log("adding market")
      }

      // fine tune
      const parameterList = ['min_popularity', 'max_popularity', 'target_popularity', 'min_tempo', 'max_tempo', 'target_tempo']
      for (const index in parameterList) {
        const name = parameterList[index]
        if (this[name] === null || this[name] === undefined || this[name] === "") {
          continue;
        }
        params.append(name, this[name]);
      }

      // request
      const fullUrl = `${baseUrl}?${params.toString()}`;
      console.log(fullUrl)
      const response = await this.fetchData(fullUrl)
      console.log("recommended response")
      console.log(response)
      if (response['amount_of_tracks'] === 0) {
        alert("No tracks were found")
      } else
        this.recommendedTracks = response['tracks']
    },
    handleLimitInput(var_name, min, max) {
      if (this[var_name] < min) {
        this[var_name] = min;
      } else if (this[var_name] > max) {
        this[var_name] = max;
      }
    },
    resetChosenGenres() {
      this.chosenGenres = "";
    },
    resetChosenTracks() {
      this.chosenTracks = "";
    },
    resetChosenArtists() {
      this.chosenArtists = "";
    },
    resetAllParameters() {
      this.genreSelected = "";
      this.artistSelected = "";
      this.trackSelected = "";

      this.chosenGenres = "";
      this.chosenGenresCounter = 0;
      this.chosenArtists = [];
      this.chosenArtistsCounter = 0;
      this.chosenTracks = [];
      this.chosenTracksCounter = 0;
      this.chosenTotalCounter = 0;

      this.disableSeedInputs = false;

      this.limit = 20;
      this.market = "";
      this.min_popularity = null;
      this.max_popularity = null;
      this.target_popularity = null;
      this.min_tempo = null;
      this.max_tempo = null;
      this.target_tempo = null;
    },
  },

  watch: {
    genreSelected(newValue) {
      if (newValue !== "" && !this.chosenGenres.includes(newValue)) {
        this.chosenGenres += newValue + ","
        this.chosenGenresCounter++;
      }
      this.genreSelected = "";
    },
    artistSelected(chosenArtist) {
      if (chosenArtist !== "" && chosenArtist !== null) {
        if (this.chosenArtists.length === 0) {
          this.chosenArtists[0] = chosenArtist.id + ","
          this.chosenArtists[1] = chosenArtist.name + ", "
          this.chosenArtistsCounter++;
        } else if (!this.chosenArtists[0].includes(chosenArtist.id)) {
          this.chosenArtists[0] += chosenArtist.id + ","
          this.chosenArtists[1] += chosenArtist.name + ", "
          this.chosenArtistsCounter++;
        }
      }
      this.artistSelected = "";
    },
    trackSelected(chosenTrack) {
      console.log(chosenTrack)
      if (chosenTrack !== "" && chosenTrack !== null) {
        if (this.chosenTracks.length === 0) {
          console.log(chosenTrack)
          this.chosenTracks[0] = chosenTrack.id + ","
          this.chosenTracks[1] = chosenTrack.name + ", "
          this.chosenTracksCounter++;
        } else if (!this.chosenTracks[0].includes(chosenTrack.id)) {
          this.chosenTracks[0] += chosenTrack.id + ","
          this.chosenTracks[1] += chosenTrack.name + ", "
          this.chosenTracksCounter++;
        }
      }
      this.trackSelected = "";
    },
    chosenArtistsCounter(value) {
      this.chosenTotalCounter = this.chosenArtistsCounter + this.chosenGenresCounter + this.chosenTracksCounter
    },
    chosenGenresCounter(value) {
      this.chosenTotalCounter = this.chosenArtistsCounter + this.chosenGenresCounter + this.chosenTracksCounter
    },
    chosenTracksCounter(value) {
      this.chosenTotalCounter = this.chosenArtistsCounter + this.chosenGenresCounter + this.chosenTracksCounter
    },
    chosenTotalCounter(value) {
      if (value >= 5) {
        alert("You have reached the maximum of 5 input seeds (genres, artists & tracks)")
        this.disableSeedInputs = true;
      } else {
        this.disableSeedInputs = false;
      }
    },
    chosenGenres(input) {
      if (input === "")
        this.chosenGenresCounter = 0;
    },
    chosenTracks(input) {
      if (input === "")
        this.chosenTracksCounter = 0;
    },
    chosenArtists(input) {
      if (input === "")
        this.chosenArtistsCounter = 0;
    },

  },
};
</script>

<style>
#header-div {
  padding: 10px 15px;
  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

#prepare-request-div {
  display: flex;
  flex-direction: row;

  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

#seed-div {
  display: flex;
  flex-direction: column;
  padding: 10px 15px;
}

#seed-selection-div {
  display: flex;
  flex-direction: column;
  margin-right: 15px;
}

#seeds-chosen-div {
  padding-left: 15px;

  border-left-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

#optional-parameter-div {
  display: flex;
  flex-direction: row;
  padding: 10px 15px;

  border-left-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

.single-parameter-div {
  display: flex;
  flex-direction: column;

  padding: 5px 5px;
}

#results-div {
  min-height: 800px;

  padding: 10px 15px;
  border-top-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

.parameter-input {
  width: 100px
}
</style>
<script setup>
</script>