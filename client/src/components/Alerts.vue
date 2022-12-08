<template>
  <v-container>
    <v-alert type="success" v-model="success" transition="scale-transition">{{ successText }}</v-alert>

    <v-alert type="info" v-model="info" transition="scale-transition">{{ infoText }}</v-alert>

    <v-alert type="error" v-model="error" transition="scale-transition">{{ errorText }}</v-alert>
  </v-container>
</template>

<script>
export default {
  props: {
    success: {
      type: Boolean,
      default: false
    },
    successText: {
      type: String,
      default: "Success alert."
    },
    info: {
      type: Boolean,
      default: false
    },
    infoText: {
      type: String,
      default: "Info alert."
    },
    error: {
      type: Boolean,
      default: false
    },
    errorText: {
      type: String,
      default: "Error alert."
    }
  }
};
</script>

<style>
</style>