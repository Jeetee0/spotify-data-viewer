<template>
    <!-- <div style="background-color: #bababa;border-radius: 15px;padding: 5px 10px; display: inline-block;"> -->
    <div>
        <h2>Track features</h2>
        <div class="row-div" style="margin-bottom: 7px;">
            <div style="padding-left: 0px">
                <p style="font-weight: bold;">ID:</p>
                <p style="font-weight: bold;">Length:</p>
            </div>
            <div style="padding-left: 5px;">
                <p>{{ trackFeatures.id }}</p>
                <p>{{ this.millisToMinutesAndSeconds(trackFeatures.duration_ms) }} mins</p>
            </div>
        </div>

        <div class="row-div" style="min-width: 375px;">
            <div>
                <p style="font-weight: bold;">Key:</p>
                <p style="font-weight: bold;">Loudness:</p>
                <p style="font-weight: bold;">BPM:</p>
                <p style="font-weight: bold;">Danceability:</p>
                <p style="font-weight: bold;">Energy:</p>
            </div>
            <div style="padding-left: 5px;">
                <p>{{ convertTrackFeatureInfosIntoKeyString(trackFeatures.key) }} {{ trackFeatures.mode === 0 ? 'minor' : 'major' }}</p>
                <p>{{ trackFeatures.loudness }}</p>
                <p>{{ Math.round(trackFeatures.tempo) }}</p>
                <p>{{ Math.round(trackFeatures.danceability*100 * 10) / 10 }} %</p>
                <p>{{ Math.round(trackFeatures.energy*100 * 10) / 10 }} %</p>
            </div>
            <div style="padding-left: 20px;">
                <p style="font-weight: bold;">Acousticness:</p>
                <p style="font-weight: bold;">Instrumentalness:</p>
                <p style="font-weight: bold;">Liveness:</p>
                <p style="font-weight: bold;">Speechiness:</p>
                <p style="font-weight: bold;">Valence:</p>
            </div>
            <div style="padding-left: 5px;">
                <p>{{ Math.round(trackFeatures.acousticness*100 * 10) / 10 }} %</p>
                <p>{{ Math.round(trackFeatures.instrumentalness*100 * 10) / 10 }} %</p>
                <p>{{ Math.round(trackFeatures.liveness*100 * 10) / 10 }} %</p>
                <p>{{ Math.round(trackFeatures.speechiness*100 * 10) / 10 }} %</p>
                <p>{{ Math.round(trackFeatures.valence*100 * 10) / 10 }} %</p>
            </div>


        </div>
    </div>

</template>

<script>
export default {
    props: {
    trackFeatures: Object,
  },
  methods: {
    millisToMinutesAndSeconds(millis) {
        var minutes = Math.floor(millis / 60000);
        var seconds = ((millis % 60000) / 1000).toFixed(0);
        return minutes + ":" + (seconds < 10 ? '0' : '') + seconds;
    },
    convertTrackFeatureInfosIntoKeyString(key) {
        let modeString = "";
        switch (key) {
            case 0:
                modeString = 'C';
                break;
            case 1:
                modeString = 'C#';
                break;
            case 2:
                modeString = 'D';
                break;
            case 3:
                modeString = 'D#';
                break;
            case 4:
                modeString = 'E';
                break;
            case 5:
                modeString = 'F';
                break;
            case 6:
                modeString = 'F#';
                break;
            case 7:
                modeString = 'G';
                break;
            case 8:
                modeString = 'G#';
                break;
            case 9:
                modeString = 'A';
                break;
            case 10:
                modeString = 'A#';
                break;
            case 11:
                modeString = 'B';
                break;
            default:
                modeString = '?';
            }
        return modeString;
    },
  }
}
</script>

<style>
.row-div {
    display: flex;
    flex-direction: row;
}
</style>