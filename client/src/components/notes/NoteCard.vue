<template>
  <v-card class="mb-10">
    <v-card-text>
      <p class="display-1 text--primary">{{ note.title }}</p>
      <p>
        {{ new Date().toUTCString() }}
        <v-chip
          class="float-right ml-2"
          color="primary"
          small
          v-if="note.chips.includes('Italia')"
        >Italia</v-chip>
        <v-chip
          class="float-right ml-2"
          color="green"
          small
          text-color="white"
          v-if="note.chips.includes('Brasile')"
        >Brasile</v-chip>
      </p>

      <div>{{ note.description }}</div>
    </v-card-text>
    <v-card-actions>
      <v-btn color="orange" text @click="editNote">Modifica</v-btn>
      <v-btn color="red" text @click="deleteNote">Elimina</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  props: {
    note: Object
  },
  methods: {
    editNote() {
      this.$emit("on-edit", this.note);
    },
    deleteNote() {
      this.$emit("on-delete", this.note);
    }
  }
};
</script>

<style>
</style>