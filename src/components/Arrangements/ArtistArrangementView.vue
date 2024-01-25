<template>
  <div id="artist-arrangement-div">
    <div class="artist-div" v-for="artist in this.artists" :key="artist.id">
      <img class="artist-image" :src="artist.image_url" @click="selectArtist(artist)" alt="Album Cover">
      <h2 style="font-weight: bold">{{ artist.name }}</h2>
      <p><span style="font-weight: bold;">Popularity:</span> {{ artist.popularity }}/100</p>
      <p><span style="font-weight: bold;">Followers:</span> {{ (artist.followers).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") }}</p>
    </div>
  </div>
</template>

<script>


export default {
    props: {
    artists: Object,
  }
}
</script>

<style>
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