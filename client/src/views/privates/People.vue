<template>
  <v-container>
    <v-card>
      <v-card-title>
        <span class="display-1 pt-3">Filtri</span>
      </v-card-title>
      <v-card-text>
        <v-row>
          <v-col cols="12" md="4">
            <v-text-field label="Codice fiscale" v-model="cfc" clearable></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field label="Cognome" v-model="surname" clearable></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field label="Nome" v-model="name" clearable></v-text-field>
          </v-col>
        </v-row>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="primary" :loading="loading" text class="mr-2 mb-2" @click="getData">Cerca</v-btn>
      </v-card-actions>
    </v-card>

    <v-card class="mt-5">
      <v-card-title>
        <span class="display-1 pt-3">Privati</span>
        <v-spacer></v-spacer>
        <v-text-field
          v-model="search"
          append-icon="mdi-magnify"
          label="Cerca"
          single-line
          hide-details
        ></v-text-field>
        <v-btn color="primary" class="ml-5 mt-3" @click="showForm('new')">Aggiungi</v-btn>
      </v-card-title>
      <v-data-table
        :headers="headers"
        :items="allPrivates"
        :search="search"
        item-key="id"
        loading-text="Caricamento dati in corso..."
      >
        <template v-slot:item.magazine="{item}">
          <v-btn
            class="d-block mx-auto"
            :color="item.magazine ? 'success' : 'grey'"
            small
            dark
            icon
          >
            <v-icon>mdi-check</v-icon>
          </v-btn>
        </template>
        <template v-slot:item.edit="{item}">
          <v-btn class="d-block mx-auto" color="orange" small dark @click="showForm(item)" icon>
            <v-icon>mdi-pencil</v-icon>
          </v-btn>
        </template>
        <template v-slot:item.delete="{item}">
          <v-btn class="d-block mx-auto" color="red" small dark @click="showAlert(item)" icon>
            <v-icon>mdi-delete</v-icon>
          </v-btn>
        </template>
      </v-data-table>
    </v-card>
    <PrivateForm
      :dialog="dialog"
      :person="person"
      @on-cancel="dialog = false"
      @on-confirm="confirm"
    />
    <PrivateRemove
      :dialog="alert"
      :person="person"
      @on-confirm="confirm"
      @on-cancel="alert = false"
    />
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

import PrivateForm from "../../components/privates/PrivateForm";
import PrivateRemove from "../../components/privates/PrivateRemove";

export default {
  components: {
    PrivateForm,
    PrivateRemove
  },
  computed: {
    ...mapGetters(["allPrivates"])
  },
  data: () => ({
    cfc: "",
    surname: "",
    name: "",
    headers: [
      { text: "Codice fiscale", value: "cfc", sortable: false },
      { text: "Cognome", value: "surname", sortable: false },
      { text: "Nome", value: "name", sortable: false },
      { text: "Via", value: "address", sortable: false },
      { text: "N", value: "n_civ", sortable: false },
      { text: "Località", value: "loc", sortable: false },
      { text: "ZIP", value: "zip", sortable: false },
      { text: "Città", value: "city", sortable: false },
      { text: "Prov", value: "province_code", sortable: false },
      { text: "Stato", value: "country", sortable: false },
      { text: "Telefono", value: "telephone", sortable: false },
      { text: "Email", value: "email", sortable: false },
      { text: "Giornalino", value: "magazine", sortable: false },
      { text: "", value: "edit", sortable: false },
      { text: "", value: "delete", sortable: false }
    ],
    search: "",
    loading: false,
    dialog: false,
    alert: false,
    person: {}
  }),
  methods: {
    ...mapActions(["getPrivates"]),
    async getData() {
      let params = {
        cfc: this.cfc,
        surname: this.surname,
        name: this.name
      };
      this.loading = true;
      await this.getPrivates(params);
      this.loading = false;
    },
    showForm(item) {
      if (item == "new") {
        this.person = {
          cfc: "",
          surname: "",
          name: "",
          address: "",
          n_civ: "",
          loc: "",
          zip: "",
          city: "",
          province_code: "",
          country: "",
          telephone: "",
          email: "",
          magazine: 0,
          new: true
        };
      } else {
        this.person = {
          ...item,
          new: false
        };
      }
      this.dialog = true;
    },
    showAlert(person) {
      this.person = person;
      this.alert = true;
    },
    confirm() {
      this.dialog = false;
      this.alert = false;
      this.getData();
    }
  }
};
</script>

<style>
</style>