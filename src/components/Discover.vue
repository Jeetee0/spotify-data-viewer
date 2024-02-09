<template>
  <div style="color: black;">
    <div id="header-div">
      <h1>Discover new tracks through spotify recommendations</h1>
      <a href="https://developer.spotify.com/documentation/web-api/reference/get-recommendations" target="_blank">More
        info here!</a>
    </div>
    <div id="discover-div" style="display: flex; flex-direction: row;">
      <div id="discover-left-side-div">
        <div id="prepare-request-div" style="display: flex; flex-direction: row;">
          <div id="seed-div">
            <h2 style="font-weight: bold;">Select seeds</h2>
            <p>You can select up to five seeds from the three categories (genres, artists and tracks):</p>
            <div style="display: flex; flex-direction: row; padding-top: 10px">
              <div id="seed-selection-div">
                <label for="genreSelect">Select genre:</label>
                <input v-model="genreFilter" placeholder="Type to filter genres"/>
                <select v-model="genreSelected" id="genreSelect" name="genre" :disabled="disableSeedInputs"
                        style="height: 30px; width: 250px; resize: none">
                  <option v-for="genreName in filteredGenres" :key="genreName" :value="genreName">{{
                      genreName
                    }}
                  </option>
                </select>

                <label for="artistSelect" style="padding-top: 6px">Select artist:</label>
                <input v-model="artistFilter" placeholder="Type to filter artists"/>
                <select v-model="artistSelected" id="artistSelect" name="artist" :disabled="disableSeedInputs"
                        style="height: 30px; width: 250px; resize: none">
                  <option v-for="artist in filteredArtists" :key="artist.id" :value="artist">{{ artist.name }}</option>
                </select>

                <label for="trackSelect" style="padding-top: 6px">Select track:</label>
                <input v-model="trackFilter" placeholder="Type to filter tracks"/>
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
                <textarea disabled="true" rows="1" cols="1" style="height: 40px; width: 225px; resize: none"
                          v-model="chosenGenres"
                          id="chosenGenres"/>
                  <button @click="resetChosenGenres" style="margin-left: 15px; width: 70px; font-weight: bold">Reset
                  </button>
                </div>

                <label for="chosenArtists">Selected artists:</label>
                <div style="display: flex; flex-direction: row; padding-bottom: 18px">
                <textarea disabled="true" rows="1" cols="1" style="height: 40px; width: 225px; resize: none"
                          v-model="chosenArtists[1]"
                          id="chosenArtists"/>
                  <button @click="resetChosenArtists" style="margin-left: 15px; width: 70px; font-weight: bold">Reset
                  </button>
                </div>

                <label for="chosenTracks">Selected tracks:</label>
                <div style="display: flex; flex-direction: row;">
                <textarea disabled="true" rows="1" cols="1" style="height: 40px; width: 225px; resize: none"
                          v-model="chosenTracks[1]"
                          id="chosenTracks"/>
                  <button @click="resetChosenTracks" style="margin-left: 15px; width: 70px; font-weight: bold">Reset
                  </button>
                </div>

              </div>
            </div>
          </div>
          <div id="optional-parameter-div">
            <div id="optional-1-div" style="padding-right: 20px">
              <h2 style="font-weight: bold">Optional parameters</h2>
              <div class="single-parameter-div">
                <label style="font-weight: bold" for="limit">Limit:</label>
                <input class="parameter-input" v-model="limit" id="limit" type="number" min="1" max="100"
                       @input="handleLimitInput('limit', 1, 100)"/>
                <p style="font-size: 12px; width: 200px; margin-top: 4px;">Select the amount of recommended tracks for
                  the response (1-100):</p>
              </div>
              <div class="single-parameter-div">
                <label for="market" style="font-weight: bold">Market:</label>
                <input class="parameter-input" v-model="market" id="market" type="text"/>
                <p style="font-size: 12px; width: 200px;">You can specify a market with an 'ISO 3166-1 alpha-2' country
                  code (eg. DE, EN, IN etc.):</p>
              </div>
            </div>
            <div id="optional-2-div" style="margin-left: 5px; display: flex; flex-direction: column; min-width: 160px;">
              <div class="single-parameter-div">
                <label for="min_tempo">Min Tempo (bpm):</label>
                <input class="parameter-input" v-model="min_tempo" id="min_tempo" type="number" min="50" max="300"
                       @input="handleLimitInput('min_tempo', 1, 300)"/>
                <label for="max_tempo">Max Tempo (bpm):</label>
                <input class="parameter-input" v-model="max_tempo" id="max_tempo" type="number" min="50" max="300"
                       @input="handleLimitInput('max_tempo', 1, 300)"/>
                <label for="target_tempo">Target Tempo (bpm):</label>
                <input class="parameter-input" v-model="target_tempo" id="target_tempo" type="number" min="50" max="300"
                       @input="handleLimitInput('target_tempo', 1, 300)"/>
              </div>
              <div class="single-parameter-div">
                <label for="min_energy">Min Energy (0 - 1):</label>
                <input class="parameter-input" v-model="min_energy" id="min_energy" type="number" step="0.01" min="0"
                       max="1"
                       @input="handleLimitInput('min_energy', 0, 1)"/>
                <label for="max_energy">Max Energy (0 - 1):</label>
                <input class="parameter-input" v-model="max_energy" id="max_energy" type="number" step="0.01" min="0"
                       max="1"
                       @input="handleLimitInput('max_energy', 0, 1)"/>
                <label for="target_energy">Target Energy (0 - 1):</label>
                <input class="parameter-input" v-model="target_energy" id="target_energy" type="number" min="0"
                       step="0.01"
                       max="1" @input="handleLimitInput('target_energy', 0, 1)"/>
              </div>

            </div>
            <div id="optional-3-div" style="margin-left: 5px; display: flex; flex-direction: column; min-width: 150px;">
              <div class="single-parameter-div">
                <label for="min_key">Min Key (0 - 11):</label>
                <input class="parameter-input" v-model="min_key" id="min_key" type="number" min="0" max="100"
                       @input="handleLimitInput('min_key', 0, 11)"/>
                <label for="max_key">Max Key (0 - 11):</label>
                <input class="parameter-input" v-model="max_key" id="max_key" type="number" min="0" max="100"
                       @input="handleLimitInput('max_key', 0, 11)"/>
                <label for="target_key">Target Key (0 - 11):</label>
                <input class="parameter-input" v-model="target_key" id="target_key" type="number" min="0"
                       max="100" @input="handleLimitInput('target_key', 0, 11)"/>
              </div>
              <div class="single-parameter-div">
                <label for="min_mode">Min Mode (0 - 1):</label>
                <input class="parameter-input" v-model="min_mode" id="min_mode" type="number" min="0" max="1"
                       @input="handleLimitInput('min_mode', 0, 1)"/>
                <label for="max_mode">Max Mode (0 - 1):</label>
                <input class="parameter-input" v-model="max_mode" id="max_mode" type="number" min="0" max="1"
                       @input="handleLimitInput('max_mode', 0, 1)"/>
                <label for="target_mode">Target Mode (0 - 1):</label>
                <input class="parameter-input" v-model="target_mode" id="target_mode" type="number" min="0"
                       max="1" @input="handleLimitInput('target_mode', 0, 1)"/>
              </div>
            </div>
            <div id="optional-4-div" style="margin-left: 5px; display: flex; flex-direction: column; min-width: 200px;">
              <div class="single-parameter-div">
                <label for="min_popularity">Min Popularity (0 - 100):</label>
                <input class="parameter-input" v-model="min_popularity" id="min_popularity" type="number" min="0"
                       max="100"
                       @input="handleLimitInput('min_popularity', 0, 100)"/>
                <label for="max_popularity">Max Popularity (0 - 100):</label>
                <input class="parameter-input" v-model="max_popularity" id="max_popularity" type="number" min="0"
                       max="100"
                       @input="handleLimitInput('max_popularity', 0, 100)"/>
                <label for="target_popularity">Target Popularity (0 - 100):</label>
                <input class="parameter-input" v-model="target_popularity" id="target_popularity" type="number" min="0"
                       max="100" @input="handleLimitInput('target_popularity', 0, 100)"/>
              </div>
              <div class="single-parameter-div">
                <label for="min_danceability">Min Danceability (0 - 1):</label>
                <input class="parameter-input" v-model="min_danceability" id="min_danceability" type="number"
                       step="0.01" min="0" max="1"
                       @input="handleLimitInput('min_danceability', 0, 1)"/>
                <label for="max_danceability">Max Danceability (0 - 1):</label>
                <input class="parameter-input" v-model="max_danceability" id="max_danceability" type="number"
                       step="0.01" min="0" max="1"
                       @input="handleLimitInput('max_danceability', 0, 1)"/>
                <label for="target_danceability">Target Danceability (0 - 1):</label>
                <input class="parameter-input" v-model="target_danceability" id="target_danceability" type="number"
                       step="0.01" min="0"
                       max="1" @input="handleLimitInput('target_danceability', 0, 1)"/>
              </div>
            </div>
          </div>
        </div>

        <div id="track-view-div" style="">
          <div style="display: flex; flex-direction: column; margin: 0px 20px;">
            <button
                style="font-size: 22px; height: 50px; width: 200px;"
                @click="findTracks">Find tracks
            </button>
            <button
                style="font-size: 16px; margin-top: 10px; height: 28px; width: 200px"
                @click="resetAllParameters">Reset all parameters
            </button>
          </div>

          <div v-if="showSelectedTrack"
               style="display: flex; flex-direction: column; padding-top: 25px; padding-bottom: 20px; padding-left: 15px; border-left-style: solid; border-width: 2px; border-color: #2c3e50;">
            <div ref="spotifyPlayer" style=""></div>
            <div style="display: flex; flex-direction: row; margin: auto">
              <button
                  style="font-size: 14px; margin-right: 10px; height: 28px; width: 120px"
                  @click="addToPlaylist(1)"><img src="./icons/plus.png" alt="+"
                                                 style="width: 10px; height: 10px; margin-right: 5px;"/> uptempo
              </button>
              <button
                  style="font-size: 14px; height: 28px; width: 120px"
                  @click="addToPlaylist(2)"><img src="./icons/plus.png" alt="+"
                                                 style="width: 10px; height: 10px; margin-right: 5px;"/> downtempo
              </button>
            </div>
          </div>

          <div v-if="selectedTrack" id="selected-track-detail-div">
            <track-features :trackFeatures="this.trackFeatures"></track-features>
          </div>
          <div v-if="selectedTrack" id="similar-parameters-buttons-div">
            <p>Quick actions for new search:</p>
            <div style="display: flex; flex-direction: row;">
              <div style="width: 100px;">
                <button @click="setSameArtists" class="set-parameter-button">Set artists</button>
                <button @click="setTrack" class="set-parameter-button">Set track</button>
              </div>
              <div style="width: 100px;">
                <button @click="setSameKey" class="set-parameter-button">Set same <br>key</button>
                <button @click="setSimilarBpm" class="set-parameter-button">Set similar bpm</button>
              </div>
              <div style="width: 100px;">
                <button @click="setSimilarEnergy" class="set-parameter-button">Set similar energy</button>
                <button @click="setSimilarPopularity" class="set-parameter-button">Set similar popularity</button>
                <button @click="setSimilarDanceability" class="set-parameter-button">Set similar danceability</button>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div id="key-info-div">
        <div style="display: flex; flex-direction: row;">
          <div style="margin-right: 15px;">
            <h2 style="font-weight: bold;">Tonality info</h2>
            <h3 style="width: 220px; text-align: justify;">The tonality is a combination of the two parameters 'key' and
              'mode'.
              'Mode' can either be 0 or 1 and defines minor or major. The 'key' parameter ranges from 0 - 11 and is in
              pitch class notation. You can check the image to the left to translate it into the key.
              The camelot wheel shows how to mix tracks harmonously. Adjacent keys should in general be a good choice
              for mixing together.</h3>
          </div>

          <img src="../assets/pitch_class.png" alt="camelot-wheel"
               style="height: 452px; width: 214px; border-radius: 15px; margin: 25px 20px;">
          <img src="../assets/camelot-wheel.png" alt="camelot-wheel"
               style="height: 500px; width: 500px; border-radius: 15px; margin: 0px 0px">


        </div>
      </div>
    </div>

    <div id="track-results-div">
      <h2 style="font-weight: bold; padding-bottom: 10px;">Results</h2>
      <track-arrangement-view :tracks="this.recommendedTracks" :discoverMode="true"
                              @play-track="playTrack"></track-arrangement-view>


    </div>
  </div>


</template>

<script>
import TrackArrangementView from "@/components/Arrangements/TrackArrangementView.vue";
import TrackFeatures from "./TrackFeatures.vue";

export default {
  components: {
    TrackArrangementView, TrackFeatures
  },
  props: {
    tracks: Object,
    genres: Object,
    artists: Object,
  },
  data() {
    return {
      selectedTrack: null,
      showSelectedTrack: false,
      trackFeatures: {},

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
      min_energy: null,
      max_energy: null,
      target_energy: null,
      min_key: null,
      max_key: null,
      target_key: null,
      min_mode: null,
      max_mode: null,
      target_mode: null,

      min_danceability: null,
      max_danceability: null,
      target_danceability: null,

      recommendedTracks: [],
    };
  },
  async created() {
    const backendHost = import.meta.env.VITE_BACKEND_HOST;
    const backendPort = import.meta.env.VITE_BACKEND_PORT;
    const response = await this.fetchData(`${backendHost}:${backendPort}/spotify/artists_and_genres`)
    this.genres = response.genres;
    this.artists = response.artists;
    this.tracks = await this.fetchData(`${backendHost}:${backendPort}/spotify/tracks`)

    this.loadExampleTrack('6desWeNyiLDZu3lKhckawg');
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
    async loadExampleTrack(trackId) {
      const backendHost = import.meta.env.VITE_BACKEND_HOST;
      const backendPort = import.meta.env.VITE_BACKEND_PORT;
      const url = `${backendHost}:${backendPort}/spotify/tracks_by_ids?ids=${trackId}`;
      const response = await this.fetchData(url);
      this.showSelectedTrack = true;
      this.playTrack(response[0]);
    },
    async addToPlaylist(playlistIndex) {
      const backendHost = import.meta.env.VITE_BACKEND_HOST;
      const backendPort = import.meta.env.VITE_BACKEND_PORT;
      const url = `${backendHost}:${backendPort}/spotify/add_to_default_playlists?playlist_index=${playlistIndex}&track_id=${this.selectedTrack.id}`;

      try {
        const response = await fetch(url, {method: 'POST',});
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        const responseData = await response.json();
        const message = `Track with id '${responseData.track_id}' was added to playlist with id '${responseData.playlist_id}'`
        console.log(message);
      } catch (error) {
        console.error('Error:', error);
      }
    },
    async playTrack(track) {
      if (this.selectedTrack !== null && track.id === this.selectedTrack.id)
        return;
      const backendHost = import.meta.env.VITE_BACKEND_HOST;
      const backendPort = import.meta.env.VITE_BACKEND_PORT;
      const url = `${backendHost}:${backendPort}/spotify/track_features?track_id=${track.id}`
      const response = await this.fetchData(url);
      this.trackFeatures = response;
      this.selectedTrack = track;
      const spotifyPlayerContainer = this.$refs.spotifyPlayer;
      spotifyPlayerContainer.innerHTML = `<iframe src="https://open.spotify.com/embed/track/${track.id}" width="500" height="155" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>`;
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
    async findTracks() {
      const backendHost = import.meta.env.VITE_BACKEND_HOST;
      const backendPort = import.meta.env.VITE_BACKEND_PORT;
      const baseUrl = `${backendHost}:${backendPort}/spotify/discover`
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
      }

      // fine tune
      const parameterList = ['min_popularity', 'max_popularity', 'target_popularity', 'min_tempo', 'max_tempo', 'target_tempo', 'min_energy', 'max_energy', 'target_energy', 'min_key', 'max_key', 'target_key', 'min_mode', 'max_mode', 'target_mode', 'min_danceability', 'max_danceability', 'target_danceability']
      for (const index in parameterList) {
        const name = parameterList[index]
        if (this[name] === null || this[name] === undefined || this[name] === "") {
          continue;
        }
        params.append(name, this[name]);
      }

      // request
      const fullUrl = `${baseUrl}?${params.toString()}`;
      const response = await this.fetchData(fullUrl)
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
      this.chosenGenres = [];
    },
    resetChosenTracks() {
      this.chosenTracks = [];
    },
    resetChosenArtists() {
      this.chosenArtists = [];
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
      this.min_key = null;
      this.max_key = null;
      this.target_key = null;
      this.min_energy = null;
      this.max_energy = null;
      this.target_energy = null
      this.min_mode = null;
      this.max_mode = null;
      this.target_mode = null;
      this.min_danceability = null;
      this.max_danceability = null;
      this.target_danceability = null;

    },
    setSameKey() {
      this.target_key = this.trackFeatures.key;
      this.target_mode = this.trackFeatures.mode;
    },
    setSimilarBpm() {
      this.min_tempo = Math.round(this.trackFeatures.tempo) - 2;
      this.max_tempo = Math.round(this.trackFeatures.tempo) + 2;
    },
    setSimilarEnergy() {
      this.min_energy = Math.round((this.trackFeatures.energy - 0.1) * 100) / 100;
      this.max_energy = Math.round((this.trackFeatures.energy + 0.1) * 100) / 100;

    },
    setSimilarDanceability() {
      this.min_danceability = Math.round((this.trackFeatures.danceability - 0.1) * 100) / 100;
      this.max_danceability = Math.round((this.trackFeatures.danceability + 0.1) * 100) / 100;
    },
    setSimilarPopularity() {
      this.min_popularity = Math.round(this.trackFeatures.popularity - 5);
      this.max_popularity = Math.round(this.trackFeatures.popularity + 5);
    },
    setSameArtists() {
      for (const artistIndex in this.selectedTrack.artists) {
        const currentArtist = this.selectedTrack.artists[artistIndex];
        this.updateChosenArtists(currentArtist)
      }
    },
    setTrack() {
      this.trackSelected = this.selectedTrack
    },
    sleep(ms) {
      return new Promise(resolve => setTimeout(resolve, ms));
    },
    updateChosenArtists(chosenArtist) {
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
      this.updateChosenArtists(chosenArtist)
      this.artistSelected = "";
    },
    trackSelected(chosenTrack) {
      if (chosenTrack !== "" && chosenTrack !== null) {
        if (this.chosenTracks.length === 0) {
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

  padding: 5px 0px;
}

#selected-track-detail-div {
  padding: 20px 20px;
  display: flex;
  flex-direction: row;
}

#track-results-div {
  min-height: 800px;

  padding: 10px 15px;
  border-top-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

#key-info-div {
  padding: 10px 15px;
  display: flex;
  flex-direction: column;

  border-left-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

.parameter-input {
  width: 100px
}

#similar-parameters-buttons-div {
  padding: 20px 10px;
  display: flex;
  flex-direction: column;
}

.set-parameter-button {
  padding: 5px 5px;
  margin: 2px 2px;
  width: 85px;
  height: 50px;
}

#track-view-div {
  display: flex;
  flex-direction: row;
  height: 240px;
  align-items: center;
}
</style>