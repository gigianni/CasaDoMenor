<template>
  <v-container>
    <v-card>
      <v-card-title>
        <span class="display-1 pt-3">Filtri</span>
      </v-card-title>
      <v-card-text>
        <v-row>
          <v-col cols="12" md="6">
            <v-text-field label="Identificazione" v-model="name" clearable></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field label="Referenza" v-model="reference" clearable></v-text-field>
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
        <span class="display-1 pt-3">Gruppi</span>
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
        :items="allGroups"
        :search="search"
        item-key="id"
        loading-text="Caricamento dati in corso..."
      >
        <template v-slot:item.giornalino="{item}">
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
    <GroupForm :dialog="dialog" :group="group" @on-cancel="dialog = false" @on-confirm="confirm" />
    <GroupRemove :dialog="alert" :group="group" @on-confirm="confirm" @on-cancel="alert = false" />
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

import GroupForm from "../../components/groups/GroupForm";
import GroupRemove from "../../components/groups/GroupRemove";

export default {
  components: {
    GroupForm,
    GroupRemove
  },
  computed: {
    ...mapGetters(["allGroups"])
  },
  data: () => ({
    name: "",
    reference: "",
    headers: [
      { text: "Identificazione", value: "name", sortable: false },
      { text: "Referenza", value: "reference", sortable: false },
      { text: "Via", value: "address", sortable: false },
      { text: "N", value: "n_civ", sortable: false },
      { text: "Località", value: "loc", sortable: false },
      { text: "ZIP", value: "zip", sortable: false },
      { text: "Città", value: "city", sortable: false },
      { text: "Prov", value: "province_code", sortable: false },
      { text: "Stato", value: "country", sortable: false },
      { text: "Telefono", value: "telephone", sortable: false },
      { text: "Email", value: "email", sortable: false },
      { text: "Giornalino", value: "giornalino", sortable: false },
      { text: "", value: "edit", sortable: false },
      { text: "", value: "delete", sortable: false }
    ],
    search: "",
    loading: false,
    dialog: false,
    alert: false,
    group: {}
  }),
  methods: {
    ...mapActions(["getGroups"]),
    async getData() {
      let params = {
        name: this.name,
        reference: this.reference
      };
      this.loading = true;
      await this.getGroups(params);
      this.loading = false;
    },
    showForm(item) {
      if (item == "new") {
        this.group = {
          name: "",
          reference: "",
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
        this.group = {
          ...item,
          new: false
        };
      }
      this.dialog = true;
    },
    showAlert(group) {
      this.group = group;
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