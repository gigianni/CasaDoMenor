<template>
  <v-dialog v-model="dialog" max-width="1000" persistent>
    <v-card :loading="loading" :disabled="loading">
      <v-card-title class="display-1 mb-n2">Modifica quantità articolo</v-card-title>
      <v-form ref="form">
        <v-card-text>
          <v-radio-group class="my-n1 px-2" v-model="type">
            <v-row>
              <v-col cols="12" sm="3">
                <v-radio label="Aggiungi" value="add"></v-radio>
              </v-col>
              <v-col cols="12" sm="3">
                <v-radio label="Rimuovi" value="remove"></v-radio>
              </v-col>
            </v-row>
          </v-radio-group>
          <v-row>
            <v-col cols="12" md="6" class="px-5">
              <!-- <v-text-field v-model="qtCuneo" class="mx-2" type="number" label="Cuneo"></v-text-field> -->
              <p class="text-h5 mb-10">Cuneo</p>
              <v-slider
                v-model="qtCuneo"
                class="align-center"
                thumb-label="always"
                v-if="type == 'add'"
              ></v-slider>
              <v-slider
                v-model="qtCuneo"
                class="align-center"
                thumb-label="always"
                :max="obj.amountCuneo"
                v-else
              ></v-slider>
            </v-col>
            <v-col cols="12" md="6" class="px-5">
              <p class="text-h5 mb-10">Roracco</p>
              <v-slider
                v-model="qtRoracco"
                class="align-center"
                thumb-label="always"
                v-if="type == 'add'"
              ></v-slider>
              <v-slider
                v-model="qtRoracco"
                class="align-center"
                thumb-label="always"
                :max="obj.amountRoracco"
                v-else
              ></v-slider>
              <!-- <v-text-field v-model="qtRoracco" class="mx-2" type="number" label="Roracco"></v-text-field> -->
            </v-col>
          </v-row>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn text @click="$emit('on-cancel')">Annulla</v-btn>
          <v-btn color="success" text @click="operation" class="ml-2 mr-2">Salva</v-btn>
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
    obj: Object
  },
  data: () => ({
    loading: false,
    type: "add",
    qtCuneo: 0,
    qtRoracco: 0
  }),
  methods: {
    ...mapActions(["updateItem"]),
    async operation() {
      this.loading = true;
      if (this.type == "add") {
        this.obj.amountCuneo += this.qtCuneo;
        this.obj.amountRoracco += this.qtRoracco;
      } else {
        this.obj.amountCuneo -= this.qtCuneo;
        this.obj.amountRoracco -= this.qtRoracco;
      }
      await this.updateItem(this.obj);
      this.loading = false;
      this.qtCuneo = this.qtRoracco = 0;
      this.$emit("on-confirm");
    }
  }
};
</script>

<style>
</style>