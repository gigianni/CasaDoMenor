<template>
  <v-card :loading="loading" :disabled="loading">
    <v-toolbar color="success" dark flat>
      <v-toolbar-title>Casa do Menor - Login</v-toolbar-title>
    </v-toolbar>
    <v-card-text>
      <v-form>
        <v-text-field
          label="Username"
          name="username"
          prepend-icon="mdi-account"
          type="text"
          clearable
          v-model="username"
          :error="error"
          @click:clear="clear"
          @change="clear"
        />

        <v-text-field
          id="password"
          label="Password"
          name="password"
          prepend-icon="mdi-lock"
          type="password"
          clearable
          v-model="password"
          :error="error"
          @click:clear="clear"
          @change="clear"
        />
      </v-form>
      <div class="d-block text-center mt-3" full-width>
        <v-btn color="primary" @click="login" class="mb-3" min-width="200">Login</v-btn>
        <v-btn text block @click="passwordReset">Hai dimenticato la password?</v-btn>
      </div>
    </v-card-text>
  </v-card>
</template>

<script>
export default {
  data() {
    return {
      username: "serra",
      password: "serra",
      error: false,
      loading: false
    };
  },
  methods: {
    clear() {
      this.error = false;
    },
    login() {
      this.loading = true;
      this.$http("https://93.71.57.206:11333/login", {
        method: "post",
        data: {
          username: this.username,
          password: this.password
        }
        //credentials: "include"
      })
        .then(data => {
          console.log(data);
          this.$router.push("/");
        })
        .catch(err => {
          console.log(err.response);
          this.error = true;
        })
        .finally(() => (this.loading = false));
    },
    passwordReset() {
      this.$router.push("/login/reset");
    }
  }
};
</script>

<style>
</style>