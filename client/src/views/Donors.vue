<template>
  <v-container>
    <v-row>
      <v-col size="12">
        <v-card>
          <v-card-title v-if="!loading">
            <span class="display-1 pt-3">Finanziatori</span>
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
            :headers="headers"
            :items="allDonors"
            :search="search"
            single-expand
            item-key="id"
            :show-expand="!loading"
            :loading="loading"
            loading-text="Caricamento dati in corso..."
          >
            <template v-slot:item.edit="{item}">
              <v-btn color="orange" small dark @click="console.log(item)" icon>
                <v-icon>mdi-pencil</v-icon>
              </v-btn>
            </template>
            <template v-slot:item.trash="{item}">
              <v-btn color="red" small dark @click="console.log(item)" icon>
                <v-icon>mdi-delete</v-icon>
              </v-btn>
            </template>
            <template v-slot:expanded-item="{ headers, item }">
              <td :colspan="headers.length">{{ item.notes }}</td>
            </template>
          </v-data-table>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
export default {
  async mounted() {
    this.loading = true;
    await this.getDonors();
    this.loading = false;
    this.headers = [
      {
        text: "Codice",
        sortable: false,
        value: "code"
      },
      { text: "Nome", value: "name", sortable: false },
      { text: "Stato", value: "country_code", sortable: false },
      { text: "Contatti", value: "contacts", sortable: false },
      { text: "", value: "edit", sortable: false },
      { text: "", value: "trash", sortable: false },
      {
        text: "",
        value: "data-table-expanded",
        sortable: false
      }
    ];
  },
  computed: {
    ...mapGetters(["allDonors"])
  },
  data() {
    return {
      loading: false,
      search: "",
      headers: []
    };
  },
  methods: {
    ...mapActions(["getDonors"])
  }
};
</script>

<style>
</style>