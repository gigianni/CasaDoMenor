<template>
  <v-dialog v-model="dialog" max-width="500" persistent>
    <v-card :loading="loading" :disabled="loading">
      <v-card-title class="headline">Eliminare la donazione?</v-card-title>
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
    donation: Object
  },
  data: () => ({
    loading: false
  }),
  methods: {
    ...mapActions(["deleteDonation", "getDonations"]),
    cancel() {
      this.$emit("on-cancel");
    },
    async remove() {
      let tableName =
        this.donation.type == "person"
          ? "private_donations_persons"
          : "private_donations_groups";
      this.loading = true;
      await this.deleteDonation({
        tableName: tableName,
        id: this.donation.id
      });
      console.log(this.donation);
      this.loading = false;
      await this.getDonations({ tableName: tableName });
      this.$emit("on-confirm");
    }
  }
};
</script>

<style>
</style>