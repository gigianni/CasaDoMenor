<template>
  <v-main id="container">
    <v-container class="fill-height">
      <v-row align="center" justify="center">
        <v-col cols="12" sm="8" md="4">
          <router-view />
        </v-col>
      </v-row>
    </v-container>
  </v-main>
</template>

<script>
export default {
  name: "Login",
  components: {}
};
</script>
<style>
#container {
  background: url(https://semplicecome.it/wp-content/uploads/2019/05/onlus-cosa-sono.jpg);
  background-size: cover;
  height: 100%;
}
</style>