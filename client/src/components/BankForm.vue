<template>
  <v-dialog v-model="dialog" max-width="700" persistent>
    <v-card>
      <v-card-title class="display-1 mb-n2">{{ operationTitle }} banca</v-card-title>
      <v-form ref="form">
        <v-card-text>
          <v-text-field
            label="Nome banca"
            v-model="bank.name"
            required
            class="font-weight-bold ml-2 mr-2"
            :rules="rules"
          ></v-text-field>
          <v-text-field label="IBAN" v-model="bank.iban" required :rules="rules" class="ml-2 mr-2"></v-text-field>
          <v-text-field
            label="Indirizzo"
            v-model="bank.address"
            required
            :rules="rules"
            class="ml-2 mr-2"
          ></v-text-field>
          <v-text-field label="Città" v-model="bank.city" required :rules="rules" class="ml-2 mr-2"></v-text-field>
          <v-text-field
            label="SWIFT"
            v-model="bank.swift"
            required
            :rules="rules"
            class="ml-2 mr-2"
          ></v-text-field>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="onCancel">Annulla</v-btn>
          <v-btn color="success" text @click="onCancel" class="ml-2 mr-2">{{ operationText }}</v-btn>
        </v-card-actions>
      </v-form>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    dialog: {
      type: Boolean,
      default: false
    },
    bank: Object
  },
  data() {
    return {
      rules: [
        value => !!value || "Richiesto.",
        value => (value && value.length >= 4) || "Minimo 4 caratteri."
      ]
    };
  },
  methods: {
    onCancel() {
      this.$emit("on-close");
    }
  },
  computed: {
    operationTitle() {
      return this.bank.new ? "Aggiungi" : "Modifica";
    },
    operationText() {
      return this.bank.new ? "Aggiungi" : "Salva";
    }
  }
};
</script>

<style>
</style>