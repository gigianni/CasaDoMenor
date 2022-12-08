<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-btn block color="primary" @click="manage = true">Gestisci causali e conti</v-btn>
      </v-col>
    </v-row>

    <ManageCausalsAccounts :dialog="manage" @on-close="manage = false" />

    <DonationFilters @on-search="changeHeaders" />

    <v-card class="mt-5">
      <v-card-title>
        <span class="d-block display-1 pt-3">Donazioni privati</span>
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
      <v-card-text>Totale: €{{ donationsTotal }}</v-card-text>
      <v-data-table
        :headers="headers"
        :items="allPrivatesDonations"
        :search="search"
        item-key="id"
        loading-text="Caricamento dati in corso..."
      >
        <template
          v-slot:item.date_payment="{item}"
        >{{new Date(item.date_payment).toLocaleDateString()}}</template>
        <template
          v-slot:item.date_registration="{item}"
        >{{new Date(item.date_registration).toLocaleDateString()}}</template>
        <template v-slot:item.value="{item}">€{{ item.value }}</template>
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
    <DonationForm
      v-if="dialog"
      :dialog="dialog"
      :donation="donation"
      @on-confirm="dialog = false"
      @on-cancel="dialog = false"
    />
    <DonationRemove
      :dialog="alert"
      :donation="donation"
      @on-cancel="alert = false"
      @on-confirm="alert = false"
    />
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";

import ManageCausalsAccounts from "../../components/donations/ManageCausalsAccounts";

import DonationFilters from "../../components/donations/DonationFilters";
import DonationForm from "../../components/donations/DonationForm";
import DonationRemove from "../../components/donations/DonationRemove";

export default {
  components: {
    ManageCausalsAccounts,
    DonationFilters,
    DonationForm,
    DonationRemove
  },
  mounted() {},
  computed: {
    ...mapGetters(["allPrivatesDonations", "donationsTotal"])
  },
  data: () => ({
    headers: [],
    search: "",
    manage: false,
    dialog: false,
    alert: false,
    donation: {}
  }),
  methods: {
    changeHeaders(headers) {
      this.headers = headers;
    },
    showForm(item) {
      if (item == "new") {
        this.donation = {
          surname: "",
          name: "",
          identification: "",
          references: "",
          date_payment: "",
          idC: "",
          idA: "",
          idP: "",
          idG: "",
          value: "",
          new: true,
          type: "person"
        };
      } else {
        this.donation = item;
        this.new = false;
      }
      this.dialog = true;
    },
    showAlert(donation) {
      this.donation = donation;
      this.alert = true;
    }
  }
};
</script>

<style>
</style>