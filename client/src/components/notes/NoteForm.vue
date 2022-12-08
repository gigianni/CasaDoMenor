<template>
  <v-dialog v-model="dialog" max-width="700" persistent>
    <v-card :loading="loading" :disabled="disabled">
      <v-card-title class="display-1 mb-n2">{{ operationTitle }} nota</v-card-title>
      <v-form ref="form">
        <v-card-text>
          <v-text-field
            label="Nome nota"
            v-model="note.title"
            required
            :rules="rules"
            class="font-weight-bold ml-2 mr-2 mb-5"
          ></v-text-field>
          <v-textarea
            label="Inserire testo"
            v-model="note.description"
            hint="Inserire descrizione della nota."
            class="ml-2 mr-2 mb-5"
            counter="500"
            auto-grow
          ></v-textarea>
          <v-combobox
            v-model="note.chips"
            :items="items"
            chips
            clearable
            label="Seleziona le etichette"
            class="ml-2 mr-2"
            multiple
            single-line
          >
            <template v-slot:selection="{ attrs, item, select, actions }">
              <v-chip
                v-bind="actions"
                :input-value="item"
                close
                @click="select"
                @click:close="remove(item)"
                :color="item == 'Italia'? 'primary' : 'green'"
                light
                text-color="white"
              >{{ item }}</v-chip>
            </template>
          </v-combobox>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="onCancel" color="red">Annulla</v-btn>
          <v-btn color="success" text @click="operation" class="mr-2">{{ operationText }}</v-btn>
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
    note: Object,
    loading: {
      type: Boolean,
      default: false
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      rules: [
        value => !!value || "Richiesto.",
        value => (value && value.length >= 4) || "Minimo 4 caratteri."
      ],
      items: ["Italia", "Brasile"]
    };
  },
  methods: {
    onCancel() {
      this.$emit("on-cancel");
    },
    remove(item) {
      this.note.chips.splice(this.note.chips.indexOf(item), 1);
    },
    operation() {
      this.$emit(this.note.new ? "on-add" : "on-save", this.note);
    }
  },
  computed: {
    operationTitle() {
      return this.note.new ? "Aggiungi" : "Modifica";
    },
    operationText() {
      return this.note.new ? "Aggiungi" : "Salva";
    }
  }
};
</script>

<style>
</style>