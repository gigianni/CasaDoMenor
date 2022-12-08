<template>
  <v-dialog v-model="dialog" max-width="1000" persistent>
    <v-card :loading="loading" :disabled="loading">
      <v-card-title class="display-1 mb-n2">{{ operationTitle }} gruppo</v-card-title>
      <v-form ref="form">
        <v-card-text>
          <v-row>
            <v-col cols="12" md="6">
              <v-text-field label="Identificazione" class="mx-2" v-model="group.name"></v-text-field>
            </v-col>
            <v-col cols="12" md="6">
              <v-text-field label="Referenza" class="mx-2" v-model="group.reference"></v-text-field>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="9" md="6">
              <v-text-field label="Indirizzo" class="mx-2" v-model="group.address"></v-text-field>
            </v-col>
            <v-col cols="3" md="2">
              <v-text-field label="Civico" class="mx-2" v-model="group.n_civ"></v-text-field>
            </v-col>
            <v-col cols="12" md="4">
              <v-text-field label="Località" class="mx-2" v-model="group.loc"></v-text-field>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="6" md="3">
              <v-text-field label="ZIPCODE" class="mx-2" v-model="group.zip"></v-text-field>
            </v-col>
            <v-col cols="6" md="3">
              <v-text-field label="Provincia" class="mx-2" v-model="group.province_code"></v-text-field>
            </v-col>
            <v-col cols="6" md="3">
              <v-text-field label="Città" class="mx-2" v-model="group.city"></v-text-field>
            </v-col>
            <v-col cols="6" md="3">
              <v-text-field label="Stato" class="mx-2" v-model="group.country"></v-text-field>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="7">
              <v-text-field label="Email" class="mx-2" v-model="group.email"></v-text-field>
            </v-col>
            <v-col cols="3">
              <v-text-field label="Telefono" class="mx-2" v-model="group.telephone"></v-text-field>
            </v-col>
            <v-col cols="2">
              <v-switch v-model="group.magazine" label="Giornalino"></v-switch>
            </v-col>
          </v-row>
        </v-card-text>
        <v-card-actions class="mt-n5">
          <v-spacer></v-spacer>
          <v-btn text @click="onCancel" color="red">Annulla</v-btn>
          <v-btn color="success" text @click="operation" class="mr-2">{{ operationText }}</v-btn>
        </v-card-actions>
      </v-form>
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
    group: Object,
    disabled: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    loading: false
  }),
  methods: {
    ...mapActions(["addGroup", "updateGroup"]),
    onCancel() {
      this.$emit("on-cancel");
    },
    async operation() {
      this.loading = true;
      this.group.magazine = this.group.magazine ? 1 : 0;
      if (this.group.new) await this.addGroup(this.group);
      else await this.updateGroup(this.group);
      this.loading = false;
      this.$emit("on-confirm");
    }
  },
  computed: {
    operationTitle() {
      return this.group.new ? "Aggiungi" : "Modifica";
    },
    operationText() {
      return this.group.new ? "Aggiungi" : "Salva";
    }
  }
};
</script>

<style>
</style>