<template>
  <v-dialog v-model="dialog" max-width="1000" persistent>
    <v-card :loading="loading" :disabled="loading">
      <v-card-title class="display-1 mb-n2">{{ operationTitle }} articolo</v-card-title>
      <v-form ref="form">
        <v-card-text>
          <v-autocomplete
            class="mx-2"
            v-model="obj.id_group"
            :items="allStockGroups"
            item-value="id"
            item-text="name"
            hide-no-data
            label="Categoria"
          ></v-autocomplete>
          <v-row>
            <v-col cols="12" md="6" class="py-0">
              <v-text-field class="mx-2" v-model="obj.code" label="Codice"></v-text-field>
            </v-col>
            <v-col cols="12" md="6" class="py-0">
              <v-text-field class="mx-2" v-model="obj.nameItem" label="Nome"></v-text-field>
            </v-col>
          </v-row>
          <v-textarea
            class="mx-2"
            v-model="obj.description"
            label="Descrizione"
            auto-grow
            hint="Inserire descrizione articolo"
          ></v-textarea>
          <v-row v-if="obj.new">
            <v-col cols="12" md="6">
              <v-text-field
                class="mx-2"
                type="number"
                v-model="obj.amountCuneo"
                label="Quantità cuneo"
              ></v-text-field>
            </v-col>
            <v-col cols="12" md="6">
              <v-text-field
                class="mx-2"
                type="number"
                v-model="obj.amountRoracco"
                label="Quantità Roracco"
              ></v-text-field>
            </v-col>
          </v-row>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="$emit('on-cancel')">Annulla</v-btn>
          <v-btn color="success" text @click="operation" class="ml-2 mr-2">{{ operationText }}</v-btn>
        </v-card-actions>
      </v-form>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapActions, mapGetters } from "vuex";

export default {
  props: {
    dialog: {
      type: Boolean,
      default: false
    },
    obj: Object
  },
  mounted() {
    this.getStockGroups();
  },
  data: () => ({
    loading: false
  }),
  methods: {
    ...mapActions(["getStockGroups", "addItem", "updateItem"]),
    async operation() {
      this.loading = true;
      if (this.obj.new) await this.addItem(this.obj);
      else await this.updateItem(this.obj);
      this.loading = false;
      this.$emit("on-confirm");
    }
  },
  computed: {
    ...mapGetters(["allStockGroups"]),
    operationTitle() {
      return this.obj.new ? "Aggiungi" : "Modifica";
    },
    operationText() {
      return this.obj.new ? "Aggiungi" : "Salva";
    }
  }
};
</script>

<style>
</style>