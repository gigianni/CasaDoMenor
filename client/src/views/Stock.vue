<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-btn block color="primary" @click="manage = true">Gestisci categorie</v-btn>
      </v-col>
    </v-row>
    <ManageCategories :dialog="manage" @on-close="manage = false" />
    <v-card>
      <v-card-title v-if="!loading">
        <span class="display-1 pt-3">Magazzino</span>
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
        :items="allItems"
        :search="search"
        single-expand
        item-key="id"
        :show-expand="!loading"
        :loading="loading"
        loading-text="Caricamento dati in corso..."
      >
        <template v-slot:item.editQt="{item}">
          <v-btn class="d-block mx-auto" color="success" small dark icon @click="showEdit(item)">
            <v-icon>mdi-plus-minus-variant</v-icon>
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
        <template v-slot:expanded-item="{ headers, item }">
          <td :colspan="headers.length">{{ item.description }}</td>
        </template>
      </v-data-table>
    </v-card>
    <StockForm :dialog="form" :obj="obj" @on-cancel="form = false" @on-confirm="getData" />
    <StockEditQt :dialog="editQt" :obj="obj" @on-cancel="editQt = false" @on-confirm="getData" />
    <StockRemove :dialog="alert" :obj="obj" @on-cancel="alert = false" @on-confirm="getData" />
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

import ManageCategories from "../components/stock/ManageCategories";
import StockForm from "../components/stock/StockForm";
import StockEditQt from "../components/stock/StockEditQt";
import StockRemove from "../components/stock/StockRemove";

export default {
  components: {
    ManageCategories,
    StockForm,
    StockEditQt,
    StockRemove
  },
  mounted() {
    this.getData();
  },
  computed: {
    ...mapGetters(["allItems"])
  },
  data() {
    return {
      manage: false,
      search: "",
      loading: false,
      headers: [],
      form: false,
      editQt: false,
      alert: false,
      obj: {}
    };
  },
  methods: {
    ...mapActions(["getStock"]),
    showForm(item) {
      if (item == "new") {
        this.obj = {
          id_group: "",
          code: "",
          nameItem: "",
          description: "",
          amountCuneo: 0,
          amountRoracco: 0,
          new: true
        };
      } else {
        this.obj = {
          ...item,
          new: false
        };
      }
      this.form = true;
    },
    showEdit(item) {
      this.obj = item;
      this.editQt = true;
    },
    showAlert(item) {
      this.obj = item;
      this.alert = true;
    },
    async getData() {
      this.form = false;
      this.editQt = false;
      this.loading = true;
      await this.getStock();
      this.loading = false;
      this.headers = [
        {
          text: "Codice",
          value: "code",
          sortable: false
        },
        {
          text: "Nome",
          value: "nameItem",
          sortable: false
        },
        {
          text: "Categoria",
          value: "nameGroup",
          sortable: false
        },
        {
          text: "Qt Cuneo",
          value: "amountCuneo",
          sortable: false
        },
        {
          text: "Qt Roracco",
          value: "amountRoracco",
          sortable: false
        },
        {
          text: "",
          value: "editQt",
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
    }
  }
};
</script>

<style>
</style>