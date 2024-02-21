<template>
  <div id="container">
    <div id="track-lookup-div" style="padding: 10px 15px;">
      <h1>Get track info</h1>
      <label for="trackSelect" style="padding-top: 6px">Select track ({{ Object.keys(tracks).length }}):</label>
      <input v-model="trackFilter" placeholder="Type to filter tracks" style="width: 250px;" />
      <select v-model="trackSelected" id="trackSelect" name="track"
        style="height: 30px; width: 250px; resize: none; margin-bottom: 15px;">
        <option v-for="track in filteredTracks" :key="track.id" :value="track">
          {{ track.name }} -
          {{ track.artists.map(artist => artist.name).join(', ') }}
        </option>
      </select>

      <div id="selected-track-div" v-if="trackSelected">
        <div id="track-basic-info-div" style="padding: 10px 15px">
          <a :href="trackSelected.spotify_url" target="_blank"><img :src="trackSelected.image_url" alt="Album Cover"
              style="height: 150px; width: 150px; border-radius: 15px"></a>
          <h3><span style="font-weight: bold;">{{ trackSelected.name }}</span></h3>
          <h4 style="margin-bottom: 15px">{{ trackSelected.artists.map(artist => artist.name).join(', ') }}</h4>
        </div>
        <div style="padding: 15px 15px">
          <track-features :trackFeatures="trackFeatures"></track-features>
        </div>
        <div style="padding: 15px 15px">
          <h2>Artists for track:</h2>
          <artist-arrangement-view style="padding: 5px 15px;" :artists="this.artistsForTrack"
            @open-artist-view="selectArtist"></artist-arrangement-view>
        </div>
      </div>
    </div>

    <div class="bottom-line-div"></div>

    <div id="artist-view-div" style="padding: 10px 15px; display: flex; flex-direction: row;">
      <div>
        <h1>Get artist info</h1>
        <h4>Select an artist ({{ Object.keys(artists).length }}):</h4>
        <input v-model="artistFilter" placeholder="Type to filter artists" style="width: 250px;" /><br>
        <select v-model="chosenArtist" id="artistSelect" name="artist" style="width: 250px; height: 30px;">
          <option v-for="artist in filteredArtists" :key="artist.id" :value="artist">{{ artist.name }}</option>
        </select>

        <div v-if="showSingleArtist" style="width: 320px; padding-top: 15px;">
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
      </div>
      <div v-if="chosenArtist" style="padding-left: 15px;">
        <h2 style="">Artist Top Tracks</h2>
        <track-arrangement-view :tracks="Object.fromEntries(Object.entries(artistTracks).slice(0, 5))"
          @track-clicked="trackClicked"></track-arrangement-view>
        <h2 style="">Similar Artists</h2>
        <artist-arrangement-view :artists="Object.fromEntries(Object.entries(relatedArtists).slice(0, 5))"
          @open-artist-view="selectArtist"></artist-arrangement-view>
      </div>

      <br>

    </div>

    <div class="bottom-line-div"></div>

    <div id="genre-view-div" style="padding: 10px 15px;">
      <h1>Find artists by genre</h1>
      <div id="genre-selector-div" style="padding-bottom: 15px;">
        <h4>Select a spotify genre ({{ genres.length }}):</h4>
        <input v-model="genreFilter" placeholder="Type to filter genre" style="width: 250px;" /><br>
        <select v-model="selectedGenre" id="genreSelect" name="genre" style="width: 250px; height: 30px;">
          <option v-for="genre in filteredGenres" :key="genre" :value="genre">{{ genre }}</option>
        </select>
      </div>

      <artist-arrangement-view :artists="artistsForGenre" @open-artist-view="selectArtist"></artist-arrangement-view>

    </div>

    <div class="bottom-line-div"></div>

    <div style="padding: 10px 15px;">
      <h1>Artists with highest popularity</h1>
      <artist-arrangement-view :artists="highestPopularityArtists"
        @open-artist-view="selectArtist"></artist-arrangement-view>
    </div>

    <div class="bottom-line-div"></div>

    <div style="padding: 10px 15px;">
      <h1>Artists with most followers</h1>
      <artist-arrangement-view :artists="mostFollowersArtists" @open-artist-view="selectArtist"></artist-arrangement-view>
    </div>


  </div>
</template>

<script>
import ArtistArrangementView from "@/components/Arrangements/ArtistArrangementView.vue";
import TrackArrangementView from '@/components/Arrangements/TrackArrangementView.vue';
import TrackFeatures from "@/components/TrackFeatures.vue";

export default {
  components: { TrackFeatures, ArtistArrangementView, TrackArrangementView, ArtistArrangementView },
  props: {
    tracks: Object,
    genres: Object,
    artists: Object,
  },
  data() {
    return {
      trackFilter: "",
      trackSelected: "",
      trackFeatures: {},
      artistsForTrack: [],

      artistFilter: "",
      artistTracks: [],
      relatedArtists: [],
      highestPopularityArtists: [],
      mostFollowersArtists: [],

      genreFilter: "",
      artistsForGenre: [],
      selectedGenre: "",

      showSingleArtist: false,
      chosenArtist: null,
      selectedArtist: null,

      backendHost: import.meta.env.VITE_BACKEND_HOST,
      backendPort: import.meta.env.VITE_BACKEND_PORT,
    };
  },
  async created() {
    const result = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/highest_artist_stats`);
    this.highestPopularityArtists = result.highest_popularity
    this.mostFollowersArtists = result.most_followers
  },
  computed: {
    filteredGenres() {
      if (this.genreFilter === "")
        return this.genres;
      return this.genres.filter(genre => genre.toLowerCase().includes(this.genreFilter.toLowerCase()));
    },
    filteredTracks() {
      if (this.trackFilter === "")
        return this.tracks;
      return this.tracks.filter(track => track.name.toLowerCase().includes(this.trackFilter.toLowerCase()) ||
        track.artists.map(artist => artist.name).join(', ').toLowerCase().includes(this.trackFilter.toLowerCase()));
    },
    filteredArtists() {
      if (this.artistFilter === "")
        return this.artists;
      return this.artists.filter(artist => artist.name.toLowerCase().includes(this.artistFilter.toLowerCase()));
    }
  },
  watch: {
    selectedGenre(newValue) {
      this.getArtistsForGenre(newValue);
    },
    async trackSelected(chosenTrack) {
      this.trackFeatures = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/track_features?track_id=${chosenTrack.id}`);
      this.artistsForTrack = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/artists_by_ids?artist_ids=${chosenTrack.artists.map(artist => artist.id).join(',')}`)
    },
    async chosenArtist(selectedArtist) {
      this.artistTracks = [];
      this.relatedArtists = [];
      if (selectedArtist === null || selectedArtist.name === "") {
        this.showSingleArtist = false;
        this.selectedArtist = null;
      } else {
        this.selectedArtist = selectedArtist
        this.showSingleArtist = true
        this.artistTracks = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/artist_top_tracks?artist_id=${selectedArtist.id}`)
        this.relatedArtists = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/related_artists?artist_id=${selectedArtist.id}`)
      }
    },
  },
  methods: {
    selectArtist(selectedArtist) {
      this.chosenArtist = selectedArtist;
    },
    trackClicked(track) {
      this.trackSelected = track;
    },
    async getArtistsForGenre(genre) {
      let matched_artists = []
      for (const artistId in this.artists) {
        const artist = this.artists[artistId]
        if (artist.hasOwnProperty('genres') && artist.genres.includes(genre)) {
          matched_artists.push(artist)
        }
      }
      this.artistsForGenre = matched_artists.sort((a, b) => b.popularity - a.popularity)


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
  }
}
</script>

<style scoped>
#container {
  color: black;
}

#track-lookup-div {
  display: flex;
  flex-direction: column;

  padding: 10px 15px;
}

#selected-track-div {
  display: flex;
  flex-direction: row;
}

.bottom-line-div {
  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}
</style>