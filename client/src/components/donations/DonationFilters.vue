<template>
  <v-card>
    <v-card-title>
      <span class="display-1 pt-3">Filtri</span>
    </v-card-title>
    <v-card-text>
      <v-row>
        <v-col cols="12" md="6">
          <v-autocomplete
            class="mx-2"
            v-model="causal"
            item-text="name"
            item-value="id"
            :items="getCausalsItems"
            hide-no-data
            label="Causale"
          ></v-autocomplete>
        </v-col>
        <v-col cols="12" md="6">
          <v-autocomplete
            class="mx-2"
            v-model="account"
            item-text="name"
            item-value="id"
            :items="getAccountsItems"
            hide-no-data
            label="Conto"
          ></v-autocomplete>
        </v-col>
      </v-row>

      <v-radio-group class="my-n1 px-2" v-model="filterDate">
        <v-row>
          <v-col cols="12" sm="3">
            <v-radio label="Mese e Anno" value="mm-yyyy"></v-radio>
          </v-col>
          <v-col cols="12" sm="3">
            <v-radio label="Da - A" value="from-to"></v-radio>
          </v-col>
        </v-row>
      </v-radio-group>
      <v-row v-if="filterDate == 'mm-yyyy'">
        <v-col cols="12" md="6">
          <v-select
            class="mx-2"
            label="Anno"
            item-text="text"
            item-value="value"
            :items="years"
            v-model="year"
          ></v-select>
        </v-col>
        <v-col cols="12" md="6">
          <v-autocomplete
            :disabled="!year"
            class="mx-2"
            v-model="month"
            item-text="text"
            item-value="value"
            :items="months"
            hide-no-data
            label="Mese"
          ></v-autocomplete>
        </v-col>
      </v-row>
      <v-row v-else>
        <v-col cols="12" md="6">
          <DatePicker label="Da" :date="dateFrom" @on-date-selected="changeMonthFrom" />
        </v-col>
        <v-col cols="12" md="6">
          <DatePicker
            label="A"
            :date="dateTo"
            @on-date-selected="changeMonthTo"
            :disabled="dateFrom == ''"
          />
        </v-col>
      </v-row>

      <v-radio-group class="my-n1 px-2" v-model="personGroup">
        <v-row>
          <v-col cols="12" sm="3">
            <v-radio label="Privati" value="person"></v-radio>
          </v-col>
          <v-col cols="12" sm="3">
            <v-radio label="Gruppi" value="group"></v-radio>
          </v-col>
        </v-row>
      </v-radio-group>
      <v-row v-if="personGroup == 'person'">
        <v-col cols="12" md="6">
          <v-text-field class="mx-2" v-model="surname" label="Cognome"></v-text-field>
        </v-col>
        <v-col cols="12" md="6">
          <v-text-field class="mx-2" v-model="name" label="Nome"></v-text-field>
        </v-col>
      </v-row>
      <v-row v-else>
        <v-col cols="12">
          <v-autocomplete
            class="mx-2"
            v-model="identification"
            label="Identificazione"
            :items="allGroupsNames"
            item-value="id"
            item-text="text"
          ></v-autocomplete>
        </v-col>
      </v-row>
    </v-card-text>
    <v-card-actions>
      <v-spacer></v-spacer>
      <v-btn color="primary" :loading="loading" text class="mr-2 mb-2" @click="getData">Cerca</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script>
import DatePicker from "../DatePicker";
import { mapActions, mapGetters } from "vuex";

export default {
  components: {
    DatePicker
  },
  mounted() {
    this.getAccounts();
    this.getCausals();
    this.getGroupsNames();
    this.$emit("on-search", [
      ...this.headerPeople,
      {
        text: "Data versamento",
        value: "date_payment",
        sortable: false
      },
      {
        text: "Data registrazione",
        value: "date_registration",
        sortable: false
      },
      {
        text: "Causale",
        value: "nameC",
        sortable: false
      },
      {
        text: "Conto",
        value: "nameA",
        sortable: false
      },
      {
        text: "Valore",
        value: "value",
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
    ]);
  },
  computed: {
    ...mapGetters(["allAccounts", "allCausals", "allGroupsNames"]),
    getCausalsItems() {
      return [{ id: 0, name: "Tutti" }, ...this.allCausals];
    },
    getAccountsItems() {
      return [{ id: 0, name: "Tutti" }, ...this.allAccounts];
    }
  },
  data: () => ({
    causal: null,
    account: null,
    choice: "last100",
    filterDate: "mm-yyyy",
    personGroup: "person",
    years: [
      { text: "Tutti", value: 0 },
      { text: 2019, value: 2019 },
      { text: 2018, value: 2018 },
      { text: 2017, value: 2017 },
      { text: 2016, value: 2016 },
      { text: 2015, value: 2015 },
      { text: 2014, value: 2014 },
      { text: 2013, value: 2013 },
      { text: 2012, value: 2012 },
      { text: 2011, value: 2011 }
    ],
    months: [
      { text: "Tutti", value: 0 },
      { text: "Gennaio", value: 1 },
      { text: "Febbraio", value: 2 },
      { text: "Marzo", value: 3 },
      { text: "Aprile", value: 4 },
      { text: "Maggio", value: 5 },
      { text: "Giugno", value: 6 },
      { text: "Luglio", value: 7 },
      { text: "Agosto", value: 8 },
      { text: "Settembre", value: 9 },
      { text: "Ottobre", value: 10 },
      { text: "Novembre", value: 11 },
      { text: "Dicembre", value: 12 }
    ],
    year: null,
    month: null,
    dateFrom: "",
    dateTo: "",
    surname: "",
    name: "",
    identification: 0,
    loading: false,
    headerPeople: [
      {
        text: "Cognome",
        value: "surname",
        sortable: false
      },
      {
        text: "Nome",
        value: "nameP",
        sortable: false
      }
    ],
    headerGroups: [
      {
        text: "Identificativo",
        value: "name",
        sortable: false
      },
      {
        text: "Referenza",
        value: "reference",
        sortable: false
      }
    ]
  }),
  methods: {
    ...mapActions([
      "getAccounts",
      "getCausals",
      "getDonations",
      "getGroupsNames"
    ]),
    changeMonthFrom(date) {
      this.dateFrom = date;
    },
    changeMonthTo(date) {
      this.dateTo = date;
    },
    changeHeaders() {
      let header =
        this.personGroup == "person" ? this.headerPeople : this.headerGroups;
      this.$emit("on-search", [
        ...header,
        {
          text: "Data versamento",
          value: "date_payment",
          sortable: false
        },
        {
          text: "Data registrazione",
          value: "date_registration",
          sortable: false
        },
        {
          text: "Causale",
          value: "nameC",
          sortable: false
        },
        {
          text: "Conto",
          value: "nameA",
          sortable: false
        },
        {
          text: "Valore",
          value: "value",
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
      ]);
    },
    async getData() {
      let params = {};
      params.causal = this.causal || "";
      params.account = this.account || "";
      if (this.filterDate == "mm-yyyy") {
        params.month = this.month || "";
        params.year = this.year || "";
      } else {
        params.dateFrom = this.dateFrom
          .split("-")
          .reverse()
          .join("/");
        params.dateTo = this.dateTo
          .split("-")
          .reverse()
          .join("/");
      }
      let tableName;
      if (this.personGroup == "person") {
        params.surname =
          this.surname.toUpperCase() == "TUTTI" ? "" : this.surname;
        params.name = this.name.toUpperCase() == "TUTTI" ? "" : this.name;
        tableName = "private_donations_persons";
      } else {
        params.idGroup = this.identification || "";
        tableName = "private_donations_groups";
      }
      this.changeHeaders();
      this.loading = true;
      await this.getDonations({
        tableName: tableName,
        params: params
      });
      this.loading = false;
    }
  }
};
</script>

<style>
</style>