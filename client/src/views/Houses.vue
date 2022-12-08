<template>
  <v-container>
    <Alerts
      :info="alert.added"
      info-text="Casa aggiunta con successo."
      :success="alert.edited"
      successText="Casa aggiornata con successo."
      :error="alert.removed"
      errorText="Casa eliminata."
      class="ml-n3"
    />
    <v-row>
      <v-col cols="12">
        <v-card>
          <v-card-title v-if="!loading">
            <span class="display-1 pt-3">Case</span>
            <v-spacer></v-spacer>
            <v-text-field
              v-model="search"
              append-icon="mdi-magnify"
              label="Cerca"
              single-line
              hide-details
            ></v-text-field>
            <v-btn color="primary" class="ml-5 mt-3">Aggiungi</v-btn>
          </v-card-title>
          <v-data-table
            loading-text="Caricamento dati in corso..."
            :loading="loading"
            :headers="headers"
            :items="allHouses"
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
  </v-container>
</template>

<script>
import Alerts from "../components/Alerts";
import { mapActions, mapGetters } from "vuex";

export default {
  components: {
    Alerts
  },
  computed: {
    ...mapGetters(["allHouses"])
  },
  async mounted() {
    this.loading = true;
    await this.getHouses();
    this.headers = [
      //{ text: "ID", align: "start", sortable: false, value: "id" },
      { text: "Nome", value: "name", sortable: false },
      { text: "Indirizzo", value: "address", sortable: false },
      { text: "Città", value: "city", sortable: false },
      { text: "", value: "edit", sortable: false }
    ];
    this.loading = false;
  },
  data() {
    return {
      loading: false,
      headers: [],
      houses: [],
      search: "",
      footerProps: {
        showFirstLastPage: true,
        firstIcon: "mdi-arrow-left",
        lastIcon: "mdi-arrow-right"
      },
      alert: {
        added: false,
        edited: false,
        removed: false
      }
    };
  },
  methods: {
    ...mapActions(["getHouses"]),
    showDialog(item) {
      console.log(item);
    }
  }
};
</script>

<style>
</style>