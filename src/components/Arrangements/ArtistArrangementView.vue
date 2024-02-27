<template>
  <div id="artist-arrangement-div">
    <div class="artist-div" v-for="artist in this.artists" :key="artist.id">
      <div>
        <img class="artist-image" :src="artist.image_url" @click="selectArtist(artist)" alt="Album Cover"
          @mouseover="handleArtistMouseHover(true)" @mouseout="handleArtistMouseHover(false)">
        <h2 style="font-weight: bold">{{ artist.name }}</h2>
        <h3><span style="font-weight: bold;">Popularity:</span> {{ artist.popularity }}/100</h3>
        <h3><span style="font-weight: bold;">Followers:</span> {{
          (artist.followers).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") }}</h3>
        <h4><span style="font-weight: bold;">Genres:</span> {{ artist.genres }}</h4>
      </div>

      <button id="importButton" v-if="importButton" @click="importArtist(artist)">Import</button>
    </div>
  </div>

  <popup :showPopup="showArtistInfoPopup" :infoText="popupInfoText"></popup>
</template>

<script>
import Popup from '@/components/Popup.vue'

export default {
  components: { Popup },
  props: {
    artists: Object,
    importButton: {
      type: Boolean,
      required: false,
      default: false
    },
    popupInfoText: {
      type: String,
      required: false,
      default: "Get artist info"
    }
  },
  data() {
    return {
      showArtistInfoPopup: false,
    }
  },
  methods: {
    selectArtist(artist) {
      this.$emit('artist-clicked', artist)
    },
    sliceString(input) {
      if (input.length <= 50)
        return input
      else
        return input.slice(0, 50) + '...'
    },
    importArtist(artist) {
      this.$emit('import-artist-clicked', artist)
    },
    handleArtistMouseHover(value) {
      this.showArtistInfoPopup = value;
    },
  }
}
</script>

<style>
#artist-arrangement-div {
  display: flex;
  flex-direction: row;
  overflow-x: auto;
}

#importButton {
  margin-top: 10px;
  width: 80px;
  height: 30px;
  margin-top: auto;
}

.artist-div {
  width: 200px;
  margin: 5px 0px;
  padding: 10px 15px;

  font-size: 12px;
  display: flex;
  flex-direction: column;
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