<template>
  <v-dialog v-model="dialog" max-width="1100" persistent>
    <v-card :loading="loading" :disabled="loading">
      <v-card-title class="display-1 mb-n2">{{ operationTitle }} {{ objectTypeText }}</v-card-title>
      <v-form ref="form">
        <v-card-text>
          <v-text-field class="mx-2" label="Nome" v-model="object.name"></v-text-field>
          <v-textarea
            class="mx-2"
            v-if="objectType == 'account'"
            label="Descrizione"
            v-model="object.description"
          ></v-textarea>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="$emit('on-cancel')" color="red">Annulla</v-btn>
          <v-btn color="success" text @click="operation" class="mr-2">{{ operationText }}</v-btn>
        </v-card-actions>
      </v-form>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapActions } from "vuex";

export default {
  props: {
    dialog: {
      type: Boolean,
      default: false
    },
    object: Object,
    objectType: String
  },
  data: () => ({
    loading: false
  }),
  methods: {
    ...mapActions(["addCausal", "updateCausal", "addAccount", "updateAccount"]),
    async operation() {
      this.loading = true;
      if (this.object.new) {
        if (this.objectType == "causal") await this.addCausal(this.object);
        else await this.addAccount(this.object);
      } else {
        if (this.objectType == "causal") await this.updateCausal(this.object);
        else await this.updateAccount(this.object);
      }
      this.loading = false;
      this.$emit("on-confirm");
    }
  },
  computed: {
    operationTitle() {
      return this.object.new ? "Aggiungi" : "Modifica";
    },
    operationText() {
      return this.object.new ? "Aggiungi" : "Salva";
    },
    objectTypeText() {
      return this.objectType == "causal" ? "causale" : "conto";
    }
  }
};
</script>

<style>
</style>