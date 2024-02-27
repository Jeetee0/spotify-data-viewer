<template>
  <div id="track-arrangement-div">
    <div class="track-div" v-for="track in this.tracks" :key="track.id">
      <div>
        <img class="track-image" :src="track.image_url" @click="trackClicked(track)" alt="Album Cover"
          style="height: 150px; width: 150px; border-radius: 15px; margin-bottom: 0px;"
          @mouseover="handleTrackMouseOver(true)" @mouseout="handleTrackMouseOver(false)">
        <div v-if="discoverMode" style="display: flex; justify-content: center; margin-bottom: 5px;">
          <button @click="addToPlaylist1(track.id)" style="font-size: 10px; display: flex; align-items: center; ">
            <img src="../icons/plus.png" alt="+" style="width: 10px; height: 10px; margin-right: 5px;" />
            uptempo
          </button>
          <button @click="addToPlaylist2(track.id)"
            style="font-size: 10px; display: flex; align-items: center; margin-left: 5px">
            <img src="../icons/plus.png" alt="+" style="width: 10px; height: 10px; margin-right: 5px;" />
            downtempo
          </button>
        </div>
        <h2><span style="font-weight: bold;">{{ sliceString(track.name) }}</span></h2>
        <h3>{{ sliceString(track.artists.map(artist => artist.name).join(', ')) }}</h3>
        <div v-if="additionalInfo">
          <h4 style="margin-top: 5px;">Popularity: {{ track.popularity }}</h4>
          <h4>Duration: {{ this.millisToMinutesAndSeconds(track.duration_ms) }}</h4>
        </div>

      </div>

      <button id="importButton" v-if="importButton" @click="importTrack(track)">Import</button>
    </div>
  </div>

  <popup :showPopup="showTrackInfoPopup" :infoText="popupInfoText"></popup>
</template>

<script>
import Popup from '@/components/Popup.vue'

export default {
  components: { Popup },
  props: {
    tracks: Object,
    discoverMode: {
      type: Boolean,
      required: false,
      default: false
    },
    importButton: {
      type: Boolean,
      required: false,
      default: false
    },
    popupInfoText: {
      type: String,
      required: false,
      default: "Play track"
    },
    additionalInfo: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  data() {
    return {
      showTrackInfoPopup: false,
    }
  },
  methods: {
    millisToMinutesAndSeconds(millis) {
      var minutes = Math.floor(millis / 60000);
      var seconds = ((millis % 60000) / 1000).toFixed(0);
      return minutes + ":" + (seconds < 10 ? '0' : '') + seconds;
    },
    sliceString(input) {
      if (input.length <= 50)
        return input
      else
        return input.slice(0, 50) + '...'
    },
    handleTrackMouseOver(value) {
      if (this.popupInfoText !== "") {
        if (value) {
          document.body.style.cursor = "pointer";
        }
        else {
          document.body.style.cursor = "auto";
        }
        this.showTrackInfoPopup = value;
      }
    },
    trackClicked(track) {
      this.$emit('track-clicked', track)
    },
    importTrack(track) {
      this.$emit('import-track-clicked', track)
    },
    addToPlaylist1(trackId) {
      this.sendRequestToAdd(1, trackId)
    },
    addToPlaylist2(trackId) {
      this.sendRequestToAdd(2, trackId)
    },
    async sendRequestToAdd(playlistIndex, trackId) {
      const backendHost = import.meta.env.VITE_BACKEND_HOST;
      const backendPort = import.meta.env.VITE_BACKEND_PORT;
      const url = `${backendHost}:${backendPort}/spotify/add_to_default_playlists?playlist_index=${playlistIndex}&track_id=${trackId}`;

      try {
        const response = await fetch(url, { method: 'POST', });
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        const responseData = await response.json();
        const message = `Track with id '${responseData.track_id}' was added to playlist with id '${responseData.playlist_id}'`
        console.log(message);
      } catch (error) {
        console.error('Error:', error);
      }
    }
  }
}
</script>

<style scoped>
#track-arrangement-div {
  display: flex;
  flex-direction: row;
  overflow-x: auto;
}

.track-div {
  width: 200px;
  margin: 5px 0px;
  padding: 10px 10px;
  font-size: 12px;
  display: flex;
  flex-direction: column;
}

#importButton {
  margin-top: 10px;
  width: 80px;
  height: 30px;
  margin-top: auto;
  margin-bottom: 5px;
}

.track-image {
  transition: transform 0.3s ease-in-out;
}

.track-image:hover {
  transform: scale(1.15);
  z-index: 1;
}
</style>