<template>
  <v-container>
    <v-card>
      <v-card-title v-if="!loading">
        <span class="display-1 pt-3">Progetti</span>
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
        :items="allProjects"
        :search="search"
        item-key="id"
        :loading="loading"
        loading-text="Caricamento dati in corso..."
      >
        <template v-slot:item.start_date="{item}">{{new Date(item.start_date).toLocaleDateString()}}</template>
        <template v-slot:item.view="{item}">
          <v-btn class="d-block mx-auto" color="success" small dark @click="showForm(item)" icon>
            <v-icon>mdi-eye</v-icon>
          </v-btn>
        </template>
        <template v-slot:item.edit="{item}">
          <v-btn class="d-block mx-auto" color="orange" small dark @click="showForm(item)" icon>
            <v-icon>mdi-pencil</v-icon>
          </v-btn>
        </template>
        <template v-slot:item.delete="{item}">
          <v-btn class="d-block mx-auto" color="red" small dark @click="console.log(item)" icon>
            <v-icon>mdi-delete</v-icon>
          </v-btn>
        </template>
      </v-data-table>
    </v-card>
    <!-- <StockForm :dialog="dialog" :obj="obj" @on-cancel="dialog = false" /> -->
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

// import StockForm from "../components/stock/StockForm";

export default {
  components: {
    // StockForm
  },
  async mounted() {
    this.loading = true;
    await this.getProjects();
    this.loading = false;
    this.headers = [
      {
        text: "Titolo",
        value: "title",
        sortable: false
      },
      {
        text: "Data inizio",
        value: "start_date",
        sortable: false
      },
      {
        text: "Stato",
        value: "status",
        sortable: false
      },
      {
        text: "",
        value: "view",
        sortable: false
      },
      {
        text: "",
        value: "edit",
        sortable: false
      },
      {
        text: "",
        value: "delete",
        sortable: false
      }
    ];
  },
  computed: {
    ...mapGetters(["allProjects"])
  },
  data() {
    return {
      search: "",
      loading: false,
      headers: [],
      dialog: false,
      obj: {}
    };
  },
  methods: {
    ...mapActions(["getProjects"]),
    showForm(item) {
      console.log(item);
      /*if (item == "new") {
        this.obj = {
          category: "",
          name: "",
          description: "",
          qt: 0,
          qtCuneo: 0,
          qtRoracco: 0,
          new: true
        };
      } else {
        this.obj = {
          ...item,
          new: false
        };
      }
      this.dialog = true;*/
    }
  }
};
</script>

<style>
</style>