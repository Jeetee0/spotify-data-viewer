<template>
    <div style="color: black; padding: 5px 15px;">
        <div style="display: flex; flex-direction: row;">
            <div style="width: 30%;">
                <h1 style="font-weight: bold;">About this website</h1>
                <p id="infoText" v-html="formattedInfoText"></p>
            </div>
            <div style="padding: 0px 45px; width: 70%;">
                <h1 style="font-weight: bold;">DJ showcase</h1>
                <h2 style="padding-top: 30px; padding-bottom: 10px;">Psychedelic Trance & FullOn Mixes</h2>
                <iframe width="100%" height="350" scrolling="no" frameborder="no" allow="autoplay"
                    src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/1117029487&color=%23ff5500&auto_play=false&hide_related=false&show_comments=false&show_user=true&show_reposts=false&show_teaser=true"></iframe>
                <div
                    style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;">
                    <a href="https://soundcloud.com/kineticenergyberlin" title="Kinetic Energy" target="_blank"
                        style="color: #cccccc; text-decoration: none;">Kinetic Energy</a> · <a
                        href="https://soundcloud.com/kineticenergyberlin/sets/psytrance"
                        title="Psychedelic Trance &amp; FullOn-Psy [~145]" target="_blank"
                        style="color: #cccccc; text-decoration: none;">Psychedelic Trance &amp; FullOn-Psy [~145]</a>
                </div>

                <h2 style="padding-top: 30px; padding-bottom: 10px;">Happy Hard Trance, Techno Rave Playlist</h2>
                <iframe width="100%" height="350" scrolling="no" frameborder="no" allow="autoplay"
                    src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/1639749280&color=%23ff5500&auto_play=false&hide_related=false&show_comments=false&show_user=true&show_reposts=false&show_teaser=true"></iframe>
                <div
                    style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;">
                    <a href="https://soundcloud.com/kineticenergyberlin" title="Kinetic Energy" target="_blank"
                        style="color: #cccccc; text-decoration: none;">Kinetic Energy</a> · <a
                        href="https://soundcloud.com/kineticenergyberlin/sets/summer-trance-happy-fast"
                        title="Summer Trance (Happy & Fast)" target="_blank"
                        style="color: #cccccc; text-decoration: none;">Summer
                        Trance (Happy & Fast)</a>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { infoText } from "@/assets/infoText.js";

export default {
    data() {
        return {
            infoTextContent: infoText,
        }
    },
    computed: {
        formattedInfoText() {
            return this.infoTextContent.replace(/\n/g, '<br>');
        },

    }
}
</script>

<style>
#infoText {
    font-size: 18px;
    background-color: #eeeeee;
    border-radius: 15px;
    padding: 15px 15px;
    display: inline-block;
}
</style>