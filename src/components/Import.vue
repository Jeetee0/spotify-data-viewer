<!-- Import.vue -->
<template>
    <div style="font-weight: bold; color: black; padding-left: 15px; padding-bottom: 10px;">
        <h1>Search for spotify data and import into the local library</h1>
        <input v-model="searchTerm" placeholder="Search for artist, track or playlist name" @keyup.enter="searchInSpotify"
            style="width: 290px; height: 40px; font-size: 16px; border-radius: 4px; padding: 2px 7px; margin-top: 10px;" />
        <button style="width: 80px; height: 40px; margin-left: 10px; font-size: 18px;"
            @click="searchInSpotify">Search</button>
        <div id="search-type-div" style="margin-top: 15px;">
            <button class="search-type-button" @click="trackTypeClicked" :disabled="typeTrackSelected">Track</button>
            <button class="search-type-button" @click="artistTypeClicked" :disabled="typeArtistSelected">Artist</button>
            <button class="search-type-button" @click="playlistTypeClicked"
                :disabled="typePlaylistSelected">Playlist</button>
        </div>
    </div>

    <div class="bottom-line-div"></div>

    <div id="results-div">
        <h2 style="font-weight: bold;">Results</h2>
        <track-arrangement-view v-if="typeTrackSelected" :tracks="this.tracks" :importButton="true"
            @import-track-clicked="importTrackClicked" @track-clicked="trackClicked"></track-arrangement-view>
        <artist-arrangement-view v-if="typeArtistSelected" :artists="this.artists" :importButton="true"
            @import-artist-clicked="importArtistClicked" @open-artist-view="selectArtist"></artist-arrangement-view>
        <playlist-import-view v-if="typePlaylistSelected" :playlists="this.playlists" :importButton="true"
            @import-playlist-clicked="importPlaylistClicked">
        </playlist-import-view>

    </div>

    <popup :showPopup="showPopup" :infoText="popupInfoText"></popup>
</template>
  
<script>
import ArtistArrangementView from "@/components/Arrangements/ArtistArrangementView.vue";
import TrackArrangementView from '@/components/Arrangements/TrackArrangementView.vue';
import TrackFeatures from "@/components/TrackFeatures.vue";
import PlaylistImportView from "@/components/Arrangements/PlaylistImportView.vue";
import Popup from "@/components/Popup.vue"

export default {
    components: { TrackFeatures, ArtistArrangementView, TrackArrangementView, PlaylistImportView, Popup },
    data() {
        return {
            searchTerm: "",
            artists: {},
            tracks: {},
            playlists: {},

            typeTrackSelected: true,
            typeArtistSelected: false,
            typePlaylistSelected: false,

            popupInfoText: "",
            showPopup: false,

            backendHost: import.meta.env.VITE_BACKEND_HOST,
            backendPort: import.meta.env.VITE_BACKEND_PORT,
        }
    },
    methods: {
        async searchInSpotify() {
            if (this.searchTerm === "")
                return;

            let type = ""
            if (this.typeTrackSelected) type = "track"
            else if (this.typeArtistSelected) type = "artist"
            else type = "playlist"

            const results = await this.fetchData(`${this.backendHost}:${this.backendPort}/spotify/general_search?term=${this.searchTerm}&type=${type}`)

            if (this.typeTrackSelected) this.tracks = results
            else if (this.typeArtistSelected) this.artists = results
            else if (this.typePlaylistSelected) this.playlists = results

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
        async fetchDataPost(url) {
            try {
                const response = await fetch(url, {
                    method: 'POST'
                });

                if (!response.ok) {
                    throw new Error(`Error when requesting data. Status code: ${response.status}`);
                }
                return await response.json();
            } catch (error) {
                alert(error.message)
                throw error;
            }
        },
        trackTypeClicked() {
            this.typeTrackSelected = true
            this.typeArtistSelected = false
            this.typePlaylistSelected = false
        },
        artistTypeClicked() {
            this.typeTrackSelected = false;
            this.typeArtistSelected = true;
            this.typePlaylistSelected = false;
        },
        playlistTypeClicked() {
            this.typeTrackSelected = false
            this.typeArtistSelected = false
            this.typePlaylistSelected = true
        },
        async importTrackClicked(track) {
            const url = `${this.backendHost}:${this.backendPort}/spotify/import_item?id=${track.id}&type=track`
            const response = await this.fetchDataPost(url)
            this.triggerPopup(response.detail)
        },
        async importArtistClicked(artist) {
            const url = `${this.backendHost}:${this.backendPort}/spotify/import_item?id=${artist.id}&type=artist`
            const response = await this.fetchDataPost(url)
            this.triggerPopup(response.detail)
        },
        async importPlaylistClicked(playlistId) {
            const url = `${this.backendHost}:${this.backendPort}/spotify/import_item?id=${playlistId}&type=playlist`
            const response = await this.fetchDataPost(url)
            this.triggerPopup(response.detail)
        },
        triggerPopup(infoText) {
            this.popupInfoText = infoText;
            this.showPopup = true;
            setTimeout(() => {
                this.showPopup = false;
            }, 5000);
        }
    }
};
</script>
  
<style scoped>
#results-div {
    padding: 10px 15px;
    color: black;
}

.bottom-line-div {
    border-bottom-style: solid;
    border-width: 2px;
    border-color: #2c3e50;
    margin: 0px 0px
}

.search-type-button {
    height: 40px;
    width: 90px;
    font-size: 18px;
    margin-right: 10px;
}
</style>
  