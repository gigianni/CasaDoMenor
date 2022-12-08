<template>
  <v-container>
    <Alerts
      :info="alert.added"
      info-text="Banca aggiunta con successo."
      :success="alert.edited"
      successText="Banca aggiornata con successo."
      :error="alert.removed"
      errorText="Banca eliminata."
      class="ml-n3"
    />
    <v-row>
      <v-col cols="12">
        <v-card>
          <v-card-title v-if="!loading">
            <span class="display-1 pt-3">Banche</span>
            <v-spacer></v-spacer>
            <v-text-field
              v-model="search"
              append-icon="mdi-magnify"
              label="Cerca"
              single-line
              hide-details
            ></v-text-field>
            <v-btn color="primary" class="ml-5 mt-3" @click="showDialog('new')">Aggiungi</v-btn>
          </v-card-title>
          <v-data-table
            loading-text="Caricamento dati in corso..."
            :loading="loading"
            :headers="headers"
            :items="allBanks"
            :search="search"
            :footer-props="footerProps"
          >
            <template v-slot:item.edit="{ item }">
              <v-btn color="orange" small dark @click="showDialog(item)" icon>
                <v-icon>mdi-pencil</v-icon>
              </v-btn>
            </template>
          </v-data-table>
        </v-card>
      </v-col>
    </v-row>
    <BankForm :dialog="dialog" :bank="bank" @on-close="close" />
  </v-container>
</template>

<script>
import Alerts from "../components/Alerts";
import BankForm from "../components/BankForm";

import { mapGetters, mapActions } from "vuex";

export default {
  components: {
    Alerts,
    BankForm
  },
  computed: {
    ...mapGetters(["allBanks"])
  },
  async mounted() {
    this.loading = true;
    await this.getBanks();
    this.loading = false;
    this.headers = [
      { text: "Nome", align: "start", sortable: false, value: "name" },
      { text: "IBAN", value: "iban", sortable: false },
      { text: "Indirizzo", value: "address", sortable: false },
      { text: "Città", value: "city", sortable: false },
      { text: "SWIFT", value: "swift", sortable: false },
      { text: "", value: "edit", sortable: false }
    ];
  },
  data() {
    return {
      search: "",
      headers: [],
      loading: true,
      footerProps: {
        showFirstLastPage: true,
        firstIcon: "mdi-arrow-left",
        lastIcon: "mdi-arrow-right"
      },
      dialog: false,
      bank: {},
      alert: {
        added: false,
        edited: false,
        removed: false
      }
    };
  },
  methods: {
    ...mapActions(["getBanks"]),
    showDialog(item) {
      if (item == "new") {
        this.bank = {
          name: "",
          iban: "",
          address: "",
          city: "",
          swift: "",
          new: true
        };
      } else
        this.bank = {
          ...item,
          new: false
        };
      this.dialog = true;
    },
    close() {
      this.dialog = false;
    }
  }
};
</script>

<style>
</style>