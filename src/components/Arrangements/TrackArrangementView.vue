<template>
  <div id="track-arrangement-div">
    <div class="track-div" v-for="track in this.tracks" :key="track.id">
      <a v-if="!discoverMode" :href="track.spotify_url" target="_blank"><img :src="track.image_url" alt="Album Cover"
                                                       style="height: 150px; width: 150px; border-radius: 15px"></a>

      <img v-if="discoverMode" class="track-image" :src="track.image_url" @click="playTrack(track.id)" alt="Album Cover" style="height: 150px; width: 150px; border-radius: 15px; margin-bottom: 8px;" @mouseover="handleTrackMouseOver" @mouseout="handleTrackMouseOut">
      <div v-if="discoverMode" style="display: flex; justify-content: center; margin-bottom: 5px;">
        <button @click="addToPlaylist1(track.id)" style="font-size: 10px; display: flex; align-items: center; ">
          <img src="../icons/plus.png" alt="+" style="width: 10px; height: 10px; margin-right: 5px;" />
          uptempo
        </button>
        <button @click="addToPlaylist2(track.id)" style="font-size: 10px; display: flex; align-items: center; margin-left: 5px">
          <img src="../icons/plus.png" alt="+" style="width: 10px; height: 10px; margin-right: 5px;" />
          downtempo
        </button>
      </div>
      <h3><span style="font-weight: bold;">{{ track.name }}</span></h3>
      <h4 style="margin-bottom: 15px">{{ track.artists.map(artist => artist.name).join(', ') }}</h4>
    </div>
  </div>

</template>

<script>

export default {
  props: {
    tracks: Object,
    discoverMode: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  methods: {
    handleTrackMouseOver(){
      if (this.discoverMode)
        document.body.style.cursor = "pointer";
    },
    handleTrackMouseOut() {
      if (this.discoverMode)
        document.body.style.cursor = "auto";
    },
    playTrack(trackId) {
      this.$emit('play-track', trackId)
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
      const url = `http://${backendHost}:${backendPort}/spotify/add_to_default_playlists?playlist_index=${playlistIndex}&track_id=${trackId}`;

      try {
        const response = await fetch(url, {method: 'POST',});
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        const responseData = await response.json();
        const message = `Track with id '${responseData.track_id}' was added to playlist with id '${responseData.playlist_id}'`
        console.log(message)
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
  flex-wrap: wrap;
  width: 100%;
  max-width: 2000px;
}
.track-div {
  /*flex: 0 0 calc(9.5% - 5px); /* Adjust the width as needed*/
  width: 170px;
  box-sizing: border-box;
  margin: 5px;
  text-align: center;
  font-size: 12px;
}

.track-image {
  transition: transform 0.3s ease-in-out;
}

.track-image:hover {
    transform: scale(1.15);
    z-index: 1;
}
</style>