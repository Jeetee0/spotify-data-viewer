<template>
  <div style="color: black;">
    <div id="input-container-div">
      <div id="left-side-div" style="padding: 5px 15px">
        <h1>{{ title }}</h1>
        <div style="display: flex; flex-direction: row; align-content: center; ">
          <p style="font-size: 14px">Choose latest state:</p>
          <input type="number" id="quantity" v-model="stateAmount" min="1" max="100"
            style="margin-bottom: 15px; max-width: 50px; margin-left: 20px; margin-right: 20px">
          <p style="font-size: 14px">Export date:</p>
          <input disabled="true" id="user-data-export-date" v-model="exportDate"
            style="margin-bottom: 15px; max-width: 100px; margin-left: 20px; margin-right: 20px; pointer-events: none;" />
        </div>
        <div id="term-separation-div">
          <button id="shortTermButton" @click="showShortTerm" :disabled="shortTerm">Short term</button>
          <button id="midTermButton" @click="showMidTerm" :disabled="midTerm">Mid term</button>
          <button id="longTermButton" @click="showLongTerm" :disabled="longTerm">Long term</button>
        </div>
      </div>
      <div id="right-side-div" style="display: flex; flex-direction: row; align-items: center;">
        <div ref="spotifyPlayer" style="margin-top: 15px; margin-bottom: 10px;"></div>
        <track-features style="padding: 15px 25px;" :trackFeatures="this.trackFeatures"></track-features>
      </div>

    </div>

    <div class="bottom-line-div"></div>

    <div class="results-div">
      <h2 style="padding-bottom: 10px; font-weight: bold;">Top 10 Favorite Tracks</h2>
      <track-arrangement-view :tracks="this.termData.fav_tracks" :discoverMode="false"
        @track-clicked="playTrack"></track-arrangement-view>
    </div>
    <div class="bottom-line-div"></div>
    <div class="results-div">
      <h2 style="padding-bottom: 10px; font-weight: bold;">Top 10 Favorite Artists</h2>
      <artist-arrangement-view :artists="this.termData.fav_artists"></artist-arrangement-view>
    </div>

    <div class="bottom-line-div"></div>

    <div>
      <h1 style="padding: 5px 15px;">Followed artists</h1>
      <artist-arrangement-view style="padding: 5px 15px;" :artists="this.followedArtists"
        @open-artist-view="selectArtist"></artist-arrangement-view>
    </div>

  </div>
</template>

<script>
import TrackArrangementView from "@/components/Arrangements/TrackArrangementView.vue";
import ArtistArrangementView from "@/components/Arrangements/ArtistArrangementView.vue";
import TrackFeatures from "./TrackFeatures.vue";

export default {
  components: { ArtistArrangementView, TrackArrangementView, TrackFeatures },
  data() {
    return {
      title: 'Spotify user data',
      stateAmount: 1,
      userData: {},
      termData: {},
      followedArtists: [],

      exportDate: "",
      shortTerm: true,
      midTerm: false,
      longTerm: false,
      trackFeatures: {},

      backendHost: import.meta.env.VITE_BACKEND_HOST,
      backendPort: import.meta.env.VITE_BACKEND_PORT,
    };
  },
  async created() {
    await this.requestUserData()
    this.followedArtists = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/followed_artists`)
    this.playTrack(this.termData.fav_tracks[0]);

  },
  watch: {
    stateAmount() {
      this.requestUserData();
    },
  },
  methods: {
    async playTrack(track) {
      const spotifyPlayerContainer = this.$refs.spotifyPlayer;
      spotifyPlayerContainer.innerHTML = `<iframe src="https://open.spotify.com/embed/track/${track.id}" width="600" height="155" frameborder="0" allowtransparency="true" allow="encrypted-media"></iframe>`;
      const url = `${this.backendHost}:${this.backendPort}/spotify/track_features?track_id=${track.id}`
      this.trackFeatures = await this.fetchData(url);
    },
    async requestUserData() {
      const index = this.stateAmount - 1;
      const response = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/latest_user_data_states?amount=${this.stateAmount}`)
      this.exportDate = response[index]['created_at']['$date'].substring(0, 10)
      this.userData = response[index]['data']

      if (this.shortTerm) {
        this.termData = this.userData['short_term']
      } else if (this.midTerm) {
        this.termData = this.userData['mid_term']
      } else if (this.longTerm) {
        this.termData = this.userData['long_term']
      } else {
        alert("Error in evaluating user data response from backend...")
        console.log(response)
      }
    },
    async showShortTerm() {
      this.shortTerm = true;
      this.midTerm = false;
      this.longTerm = false;
      await this.requestUserData()
    },
    async showMidTerm() {
      this.shortTerm = false;
      this.midTerm = true;
      this.longTerm = false;
      await this.requestUserData()
    },
    async showLongTerm() {
      this.shortTerm = false;
      this.midTerm = false;
      this.longTerm = true;
      await this.requestUserData()
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
};
</script>

<style scoped>
#input-container-div {

  display: flex;
  flex-direction: row;
}

#left-side-div {
  padding-right: 15px;
  margin-right: 25px;
  border-right-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

#term-separation-div {
  display: flex;
  flex-direction: row;
}

.results-div {
  padding: 5px 15px;

}

.bottom-line-div {
  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}

button {
  height: 50px;
  width: 150px;
  font-size: 18px;
  display: block;
  margin: 5px 5px;
}
</style>