<template>
  <v-dialog
    v-model="dialog"
    fullscreen
    hide-overlay
    persistent
    transition="dialog-bottom-transition"
  >
    <v-card style="background-color: #eee;">
      <v-toolbar dark color="#147513">
        <v-btn icon dark @click="$emit('on-close')">
          <v-icon>mdi-close</v-icon>
        </v-btn>
        <v-toolbar-title>Gestisci causali e conti</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn text dark @click="reload">
          <v-icon left>mdi-reload</v-icon>Ricarica
        </v-btn>
      </v-toolbar>
      <v-row>
        <v-col cols="12" md="6">
          <v-card class="ma-5">
            <v-card-title>
              <span class="d-block display-1 pt-3">Causali</span>
              <v-spacer></v-spacer>
              <v-text-field
                v-model="searchCausal"
                append-icon="mdi-magnify"
                label="Cerca"
                single-line
                hide-details
              ></v-text-field>
              <v-btn
                color="primary"
                class="ml-5 mt-3"
                @click="objectType = 'causal'; showForm('new')"
              >Aggiungi</v-btn>
            </v-card-title>
            <v-card-text>
              <v-data-table
                :headers="headersCausals"
                :items="allCausals"
                :search="searchCausal"
                item-key="id"
                loading-text="Caricamento dati in corso..."
              >
                <template v-slot:item.edit="{item}">
                  <v-btn
                    class="d-block mx-auto"
                    color="orange"
                    small
                    dark
                    @click="objectType = 'causal'; showForm(item)"
                    icon
                  >
                    <v-icon>mdi-pencil</v-icon>
                  </v-btn>
                </template>
                <template v-slot:item.delete="{item}">
                  <v-btn
                    class="d-block mx-auto"
                    color="red"
                    small
                    dark
                    @click="objectType = 'causal'; showAlert(item)"
                    icon
                  >
                    <v-icon>mdi-delete</v-icon>
                  </v-btn>
                </template>
              </v-data-table>
            </v-card-text>
          </v-card>
        </v-col>
        <v-col cols="12" md="6">
          <v-card class="ma-5">
            <v-card-title>
              <span class="d-block display-1 pt-3">Conti</span>
              <v-spacer></v-spacer>
              <v-text-field
                v-model="searchAccount"
                append-icon="mdi-magnify"
                label="Cerca"
                single-line
                hide-details
              ></v-text-field>
              <v-btn
                color="primary"
                class="ml-5 mt-3"
                @click="objectType = 'account'; showForm('new')"
              >Aggiungi</v-btn>
            </v-card-title>
            <v-card-text>
              <v-data-table
                :headers="headersAccounts"
                :items="allAccounts"
                :search="searchAccount"
                item-key="id"
                loading-text="Caricamento dati in corso..."
              >
                <template v-slot:item.edit="{item}">
                  <v-btn
                    class="d-block mx-auto"
                    color="orange"
                    small
                    dark
                    @click="objectType = 'account'; showForm(item)"
                    icon
                  >
                    <v-icon>mdi-pencil</v-icon>
                  </v-btn>
                </template>
                <template v-slot:item.delete="{item}">
                  <v-btn
                    class="d-block mx-auto"
                    color="red"
                    small
                    dark
                    @click="objectType = 'account'; showAlert(item)"
                    icon
                  >
                    <v-icon>mdi-delete</v-icon>
                  </v-btn>
                </template>
              </v-data-table>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-card>
    <ManageForm
      :dialog="form"
      :object="object"
      :objectType="objectType"
      @on-cancel="form = false"
      @on-confirm="reload"
    />
    <ManageRemove
      :dialog="alert"
      :object="object"
      :objectType="objectType"
      @on-cancel="alert = false"
      @on-confirm="reload"
    />
  </v-dialog>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

import ManageForm from "./ManageForm";
import ManageRemove from "./ManageRemove";

export default {
  props: {
    dialog: Boolean
  },
  components: {
    ManageForm,
    ManageRemove
  },
  computed: {
    ...mapGetters(["allCausals", "allAccounts"])
  },
  data: () => ({
    loading: false,
    searchCausal: "",
    searchAccount: "",
    headersCausals: [
      {
        text: "ID",
        value: "id",
        sortable: false
      },
      {
        text: "Nome",
        value: "name",
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
    ],
    headersAccounts: [
      {
        text: "ID",
        value: "id",
        sortable: false
      },
      {
        text: "Nome",
        value: "name",
        sortable: false
      },
      {
        text: "Descrizione",
        value: "description",
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
    ],
    form: false,
    alert: false,
    object: {},
    objectType: ""
  }),
  methods: {
    ...mapActions(["getCausals", "getAccounts"]),
    showForm(item) {
      if (item == "new") {
        this.object = {
          name: "",
          description: "",
          new: true
        };
      } else {
        this.object = { ...item, new: false };
      }
      console.log(item);
      this.form = true;
    },
    showAlert(item) {
      this.object = item;
      this.alert = true;
    },
    async reload() {
      this.form = false;
      this.alert = false;
      this.getCausals();
      this.getAccounts();
    }
  }
};
</script>

<style scoped>
v-container > v-card {
  background-color: #eee;
}
</style>