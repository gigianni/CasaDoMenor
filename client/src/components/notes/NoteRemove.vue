<template>
  <v-dialog v-model="dialog" max-width="500" persistent>
    <v-card :loading="loading" :disabled="disabled">
      <v-card-title class="headline">Eliminare la nota "{{ note.title }}"?</v-card-title>
      <v-card-text>Attenzione. l'operazione è irreversibile.</v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn text @click="cancel">Annulla</v-btn>
        <v-btn color="red" text @click="remove">Elimina</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    dialog: {
      type: Boolean,
      default: false
    },
    note: Object,
    loading: {
      type: Boolean,
      default: false
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    cancel() {
      this.$emit("on-cancel");
    },
    remove() {
      this.$emit("on-confirm", this.note);
    }
  }
};
</script>

<style>
</style>