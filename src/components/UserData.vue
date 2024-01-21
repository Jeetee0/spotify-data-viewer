

<template>
  <div style="color: black; margin-left: 15px">
    <h1>{{ title }}</h1>
    <div style="display: flex; flex-direction: row; align-content: center; ">
      <p style="font-size: 14px">Choose latest state:</p>
      <input type="number" id="quantity" v-model="stateAmount" min="1" max="100" style="margin-bottom: 15px; max-width: 50px; margin-left: 20px; margin-right: 20px">
    </div>
    <div style="display: flex; flex-direction: row; align-content: center; ">
      <p style="font-size: 14px">Export date:</p>
      <input id="user-data-export-date" v-model="exportDate" style="margin-bottom: 15px; max-width: 100px; margin-left: 20px; margin-right: 20px; pointer-events: none;"/>
    </div>
    <div id="term-separation-div">
      <button id="shortTermButton" @click="showShortTerm" :disabled="shortTerm">Short term</button>
      <button id="midTermButton" @click="showMidTerm" :disabled="midTerm">Mid term</button>
      <button id="longTermButton" @click="showLongTerm" :disabled="longTerm">Long term</button>
    </div>
    <user-data-term :json-data="termData" />
  </div>
</template>

<script>
import UserDataTerm from "@/components/UserDataTerm.vue";

export default {
  components: {UserDataTerm},
  data() {
    return {
      title: 'Spotify user data',
      stateAmount: 1,
      userData: {},
      termData: {},

      exportDate: "",
      shortTerm: true,
      midTerm: false,
      longTerm: false,
    };
  },
  async created() {
    await this.requestUserData()
  },
  watch: {
    stateAmount() {
      this.requestUserData();
    },
  },
  methods: {
    async requestUserData() {
      const index = this.stateAmount - 1;
      const backendHost = import.meta.env.VITE_BACKEND_HOST;
      const backendPort = import.meta.env.VITE_BACKEND_PORT;
      const response = await this.fetchData(`http://${backendHost}:${backendPort}/spotify/latest_user_data_states?amount=${this.stateAmount}`)
      console.log(response[index]['created_at']['$date'].substring(0, 10))
      this.exportDate = response[index]['created_at']['$date'].substring(0, 10)
      this.userData = response[index]['data']
      console.log(this.userData)

      if (this.shortTerm) {
        this.termData = this.userData['short_term']
      }
      else if (this.midTerm) {
        this.termData = this.userData['mid_term']
      }
      else if (this.longTerm) {
        this.termData = this.userData['long_term']
      }
      else {
        alert("Error in evaluating user data response from backend...")
        console.log(response)
      }
    },
    async showShortTerm() {
      this.shortTerm = true;
      this.midTerm = false;
      this.longTerm= false;
      await this.requestUserData()
    },
    async showMidTerm() {
      this.shortTerm = false;
      this.midTerm = true;
      this.longTerm= false;
      await this.requestUserData()
    },
    async showLongTerm() {
      this.shortTerm = false;
      this.midTerm = false;
      this.longTerm= true;
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
#term-separation-div {
  width: 100%;
  display: flex;
  flex-direction: row;
  margin-bottom: 10px;

  border-bottom-style: solid;
  border-width: 2px;
  border-color: #2c3e50;
}
button {
  height: 50px;
  width: 250px;
  font-size: 18px;
  display: block;
  margin: 5px 5px;
}
</style>