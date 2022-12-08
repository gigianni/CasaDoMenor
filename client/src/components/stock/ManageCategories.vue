<template>
  <v-dialog
    v-model="dialog"
    fullscreen
    hide-overlay
    persistent
    transition="dialog-bottom-transition"
  >
    <v-card style="background-color: #eee">
      <v-toolbar dark color="#147513">
        <v-btn icon dark @click="$emit('on-close')">
          <v-icon>mdi-close</v-icon>
        </v-btn>
        <v-toolbar-title>Gestisci categorie</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-btn text dark @click="reload">
          <v-icon left>mdi-reload</v-icon>Ricarica
        </v-btn>
      </v-toolbar>
      <v-row>
        <v-col cols="12" md="8" offset-md="2">
          <v-card class="ma-5">
            <v-card-title class="display-1">Categorie</v-card-title>
            <v-card-text>
              <v-simple-table>
                <thead>
                  <th class="text-left pl-3">ID</th>
                  <th class="text-left pl-3">Nome</th>
                </thead>
                <tbody>
                  <tr v-for="group in allStockGroups" :key="group.id">
                    <td>{{ group.id }}</td>
                    <td>{{ group.name }}</td>
                    <td class="text-center">
                      <v-btn icon color="red">
                        <v-icon>mdi-close</v-icon>
                      </v-btn>
                    </td>
                  </tr>
                  <tr>
                    <td colspan="2">
                      <v-text-field></v-text-field>
                    </td>
                    <td class="text-center">
                      <v-btn color="primary">Aggiungi</v-btn>
                    </td>
                  </tr>
                </tbody>
              </v-simple-table>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapGetters } from "vuex";
export default {
  props: {
    dialog: Boolean
  },
  computed: {
    ...mapGetters(["allStockGroups"])
  },
  methods: {
    async reload() {}
  }
};
</script>

<style>
</style>