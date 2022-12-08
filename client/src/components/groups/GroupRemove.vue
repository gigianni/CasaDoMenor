<template>
  <v-dialog v-model="dialog" max-width="500" persistent>
    <v-card :loading="loading" :disabled="loading">
      <v-card-title class="headline">Eliminare il gruppo?</v-card-title>
      <v-card-text>Attenzione, l'operazione è irreversibile.</v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn text @click="cancel">Annulla</v-btn>
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
    group: Object
  },
  data: () => ({
    loading: false
  }),
  methods: {
    ...mapActions(["deleteGroup"]),
    cancel() {
      this.$emit("on-cancel");
    },
    async remove() {
      this.loading = true;
      await this.deleteGroup(this.group.id);
      this.loading = false;
      this.$emit("on-confirm");
    }
  }
};
</script>

<style>
</style>