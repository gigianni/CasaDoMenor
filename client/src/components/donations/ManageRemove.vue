<template>
  <v-dialog v-model="dialog" max-width="500" persistent>
    <v-card :loading="loading" :disabled="loading">
      <v-card-title class="headline">Eliminare {{ objectTypeText }}?</v-card-title>
      <v-card-text>Attenzione, l'operazione è irreversibile.</v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn text @click="$emit('on-cancel')">Annulla</v-btn>
        <v-btn color="red" text @click="remove">Elimina</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapActions } from "vuex";

export default {
  props: {
    dialog: {
      type: Boolean,
      default: false
    },
    object: Object,
    objectType: String
  },
  data: () => ({
    loading: false
  }),
  methods: {
    ...mapActions(["deleteCausal", "deleteAccount"]),
    async remove() {
      this.loading = true;
      if (this.objectType == "causal") await this.deleteCausal(this.object.id);
      else await this.deleteAccount(this.object.id);
      this.loading = false;
      this.$emit("on-confirm");
    }
  },
  computed: {
    objectTypeText() {
      return this.objectType == "causal" ? "la causale" : "il conto";
    }
  }
};
</script>

<style>
</style>