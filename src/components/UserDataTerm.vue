<template>
  <div id="favorite-splitter-div">
    <div>
      <h2 style="font-weight: bold">Favorite Artists</h2>
      <ul id="favorite-artists-enum">
        <li id="favorite-artist-li" v-for="artist in jsonData.fav_artists" :key="artist.id">
          <a :href="artist.spotify_url" target="_blank"><img :src="artist.image_url" alt="Album Cover" style="height: 200px; width: 200px; border-radius: 15px"></a>
          <p style="font-size: 20px; font-weight: bold">{{ artist.name }}</p>
          <p>Popularity: {{ artist.popularity }}</p>
          <p>Genres: {{ artist.genres.join(', ') }}</p>


        </li>
      </ul>
    </div>
    <div>
      <h2 style="font-weight: bold">Favorite Tracks</h2>
      <ul id="favorite-tracks-enum">
        <li id="favorite-track-li" v-for="track in jsonData.fav_tracks" :key="track.id">
          <a :href="track.spotify_url" target="_blank"><img :src="track.image_url" alt="Album Cover" style="height: 200px; width: 200px; border-radius: 15px"></a>
          <p style="font-size: 20px; font-weight: bold">{{ track.name }}</p>
          <p>Artists: {{ track.artists.join(', ') }}</p>
          <p>Album: {{ track.album_name }}</p>
          <p>Popularity: {{ track.popularity }}</p>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    jsonData: Object,
  },
};
</script>

<style scoped>
#favorite-splitter-div {
  display: flex;
  flex-direction: column;
}
#favorite-artists-enum {
  display: flex;
  flex-direction: row;
  list-style-type: decimal;

  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}
#favorite-tracks-enum {
  display: flex;
  flex-direction: row;
  list-style-type: decimal
}
#favorite-artist-li {
  font-weight: bold;
  font-size: 18px;
  width: 220px;
  height: 380px;
  margin-top: 10px;
  margin-left: 25px;
}
#favorite-track-li {
  font-weight: bold;
  font-size: 18px;
  width: 220px;
  height: 4320px;
  margin-top: 10px;
  margin-left: 25px;
}
</style>