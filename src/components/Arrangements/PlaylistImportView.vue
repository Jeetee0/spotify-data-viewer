<template>
    <div id="import-playlist-arrangement-div" style="display: flex; flex-direction: row;">
        <div class="import-playlist-div" v-for="playlist in this.playlists" :key="playlist.id"
            style="padding: 10px 20px; justify-content: center; display: flex; flex-direction: column;">
            <div>
                <a :href="playlist.external_urls.spotify" target="_blank"><img class="playlist-image"
                        :src="playlist.images[0].url" alt="Playlist Cover" @mouseover="handlePlaylistMouseOver(true)"
                        @mouseout="handlePlaylistMouseOver(false)"></a>
                <h2 style="font-weight: bold">{{ playlist.name }} </h2>
                <p><span style="font-weight: bold;">ID:</span> {{ playlist.id }}</p>
                <p><span style="font-weight: bold;">Owner:</span> {{ playlist.owner.display_name }}</p>
                <p><span style="font-weight: bold;">Amount of tracks:</span> {{ playlist.tracks.total }}</p>
                <p><span style="font-weight: bold; text-align: justify;">Description:</span> {{
                    sliceString(playlist.description) }}</p>
            </div>

            <button id="importButton" @click="importPlaylist(playlist.id)">Import</button>
        </div>
    </div>

    <popup :showPopup="showPlaylistInfoPopup" :infoText="popupInfoText"></popup>
</template>
  
<script>
import Popup from '@/components/Popup.vue'

export default {
    components: { Popup },
    props: {
        playlists: Object,
        importButton: {
            type: Boolean,
            required: false,
            default: false
        },
        popupInfoText: {
            type: String,
            required: false,
            default: "Open Playlist in Spotify"
        }
    },
    data() {
        return {
            showPlaylistInfoPopup: false,
        }
    },
    methods: {
        sliceString(input) {
            if (input.length <= 200)
                return input
            else
                return input.slice(0, 200) + '...'
        },
        importPlaylist(playlistId) {
            this.$emit('import-playlist-clicked', playlistId)
        },
        handlePlaylistMouseOver(value) {
            if (this.popupInfoText !== "") {
                if (value) {
                    document.body.style.cursor = "pointer";
                }
                else {
                    document.body.style.cursor = "auto";
                }
                this.showPlaylistInfoPopup = value;
            }
        },
    }
}
</script>
  
<style>
#import-playlist-arrangement-div {
    display: flex;
    flex-direction: row;
    overflow-x: auto;
}

#importButton {
    width: 80px;
    height: 30px;
    margin-top: auto;
}

.import-playlist-div {
    width: 250px;
    margin: 5px 0px;
    padding: 0px 15px;

    font-size: 12px;
}

.playlist-image {
    transition: transform 0.3s ease-in-out;
    height: 200px;
    width: 200px;
    border-radius: 15px
}

.playlist-image:hover {
    transform: scale(1.15);
    z-index: 1;
}
</style>