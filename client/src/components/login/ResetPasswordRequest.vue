<template>
  <v-card :loading="loading" :disabled="loading">
    <v-toolbar color="success" dark flat>
      <v-toolbar-title>Casa do Menor - Recupero password</v-toolbar-title>
    </v-toolbar>
    <v-card-text v-if="!ok">
      <p class="title">Inserire username</p>
      <v-form>
        <v-text-field
          label="Username"
          name="username"
          prepend-icon="mdi-account"
          type="text"
          clearable
          v-model="username"
          @click:clear="clear"
          @change="clear"
          :error-messages="error"
        />
      </v-form>
    </v-card-text>
    <v-card-text v-if="ok">
      <p class="display-1">Operazione completata con successo.</p>
    </v-card-text>
    <div style="overflow: auto">
      <v-btn color="primary" text class="float-right mb-2 mr-1" @click="send" v-if="!ok">Invia</v-btn>
      <v-btn color="error" text class="float-right" @click="toLogin" v-if="!ok">Annulla</v-btn>
      <v-btn
        color="primary"
        text
        class="float-right mb-2 mr-1"
        @click="toLogin"
        v-if="ok"
      >Torna al login</v-btn>
    </div>
  </v-card>
</template>

<script>
export default {
  data() {
    return {
      username: "",
      error: "",
      loading: false,
      ok: false
    };
  },
  methods: {
    clear() {
      this.error = "";
    },
    send() {
      this.loading = true;
      this.$http
        .post("https://93.71.57.206:11333/passwordReset", {
          username: this.username
        })
        .then(() => {
          this.loading = false;
          this.ok = true;
        })
        .catch(err => {
          if (err.response.status == 404) {
            this.error = "Username non trovato.";
          }
          this.loading = false;
        });
    },
    toLogin() {
      this.$router.push("/login");
    }
  }
};
</script>

<style>
</style>