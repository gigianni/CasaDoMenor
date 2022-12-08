<template>
  <div>
    <Drawer :small="small" />
    <v-app-bar app flat color="#eee">
      <v-btn fab small @click="small = !small">
        <v-icon>{{ small ? 'mdi-arrow-expand' : 'mdi-window-minimize'}}</v-icon>
      </v-btn>
      <v-spacer></v-spacer>
      <v-btn color="red" dark @click="logout" :loading="isLoggingOut">
        <v-icon>mdi-logout</v-icon>LogOut
      </v-btn>
    </v-app-bar>
    <v-main>
      <router-view />
    </v-main>
  </div>
</template>

<script>
import Drawer from "../components/Drawer";

export default {
  name: "Home",
  components: {
    Drawer
  },
  beforeMount() {
    this.$http("https://93.71.57.206:11333/token", {
      method: "post"
    })
      .then(data => {
        console.log(data);
      })
      .catch(err => {
        console.error(err.response);
        this.$router.push("/login");
      });
  },
  data: () => ({
    small: true,
    isLoggingOut: false
  }),
  methods: {
    logout() {
      this.isLoggingOut = true;
      this.$http("https://93.71.57.206:11333/logout", { method: "post" })
        .then(() => this.$router.push("/login"))
        .catch(error => {
          console.error(error);
          this.isLoggingOut = false;
        });
    }
  }
};
</script>
<style>
</style>
