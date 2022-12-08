<template>
  <v-app style="background-color: #eee">
    <router-view></router-view>
  </v-app>
</template>

<script>
export default {
  name: "App",

  components: {},

  data() {
    return {
      user: null
    };
  },

  methods: {
    loginOk(user) {
      this.user = user;
    }
  }
};
</script>