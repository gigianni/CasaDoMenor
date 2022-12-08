<template>
  <v-dialog v-model="dialog" max-width="1000" persistent>
    <v-card :loading="loading" :disabled="loading">
      <v-card-title class="display-1 mb-n2">{{ operationTitle }} privato</v-card-title>
      <v-form ref="form">
        <v-card-text>
          <v-text-field label="Codice fiscale" class="mx-2" v-model="person.cfc"></v-text-field>
          <v-row>
            <v-col cols="12" md="6">
              <v-text-field label="Cognome" class="mx-2" v-model="person.surname"></v-text-field>
            </v-col>
            <v-col cols="12" md="6">
              <v-text-field label="Nome" class="mx-2" v-model="person.name"></v-text-field>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="9" md="6">
              <v-text-field label="Indirizzo" class="mx-2" v-model="person.address"></v-text-field>
            </v-col>
            <v-col cols="3" md="2">
              <v-text-field label="Civico" class="mx-2" v-model="person.n_civ"></v-text-field>
            </v-col>
            <v-col cols="12" md="4">
              <v-text-field label="Località" class="mx-2" v-model="person.loc"></v-text-field>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="6" md="3">
              <v-text-field label="ZIPCODE" class="mx-2" v-model="person.zip"></v-text-field>
            </v-col>
            <v-col cols="6" md="3">
              <v-text-field label="Provincia" class="mx-2" v-model="person.province_code"></v-text-field>
            </v-col>
            <v-col cols="6" md="3">
              <v-text-field label="Città" class="mx-2" v-model="person.city"></v-text-field>
            </v-col>
            <v-col cols="6" md="3">
              <v-text-field label="Stato" class="mx-2" v-model="person.country"></v-text-field>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="7">
              <v-text-field label="Email" class="mx-2" v-model="person.email"></v-text-field>
            </v-col>
            <v-col cols="3">
              <v-text-field label="Telefono" class="mx-2" v-model="person.telephone"></v-text-field>
            </v-col>
            <v-col cols="2">
              <v-switch v-model="person.magazine" label="Giornalino"></v-switch>
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
    person: Object,
    disabled: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    loading: false
  }),
  methods: {
    ...mapActions(["addPrivate", "updatePrivate"]),
    onCancel() {
      this.$emit("on-cancel");
    },
    async operation() {
      this.loading = true;
      this.person.magazine = this.person.magazine ? 1 : 0;
      if (this.person.new) {
        await this.addPrivate(this.person);
      } else {
        await this.updatePrivate(this.person);
      }
      this.loading = false;
      this.$emit("on-confirm");
    }
  },
  computed: {
    operationTitle() {
      return this.person.new ? "Aggiungi" : "Modifica";
    },
    operationText() {
      return this.person.new ? "Aggiungi" : "Salva";
    }
  }
};
</script>

<style>
</style>