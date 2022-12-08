<template>
  <v-dialog v-model="dialog" max-width="1100" persistent>
    <v-card :loading="loading" :disabled="loading">
      <v-card-title class="display-1 mb-n2">{{ operationTitle }} donazione</v-card-title>
      <v-form ref="form">
        <v-card-text>
          <v-radio-group class="mb-n2 mx-2" v-model="donation.type" v-if="donation.new">
            <v-row>
              <v-col cols="12" sm="3">
                <v-radio label="Privato" value="person"></v-radio>
              </v-col>
              <v-col cols="12" sm="3">
                <v-radio label="Gruppo" value="group"></v-radio>
              </v-col>
            </v-row>
          </v-radio-group>
          <v-row v-if="donation.type == 'person'">
            <v-col cols="12" md="2">
              <v-checkbox class="mx-2" v-model="anonimo" label="Anonimo"></v-checkbox>
            </v-col>
            <v-col cols="12" md="10">
              <v-autocomplete
                :disabled="anonimo"
                label="Donatore"
                :items="allPeopleNames"
                item-value="id"
                item-text="text"
                v-model="donation.idP"
                @keyup="getFiltersNames($event.target.value)"
              ></v-autocomplete>
            </v-col>
          </v-row>
          <v-row v-else>
            <v-col cols="12">
              <v-autocomplete
                class="mx-2"
                :disabled="anonimo"
                label="Gruppo"
                :items="allGroupsNames"
                item-value="id"
                item-text="text"
                v-model="donation.idG"
              ></v-autocomplete>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12" md="6">
              <v-autocomplete
                class="mx-2"
                label="Causale"
                :items="allCausals"
                item-value="id"
                item-text="name"
                v-model="donation.idC"
              ></v-autocomplete>
            </v-col>
            <v-col cols="12" md="6">
              <v-autocomplete
                class="mx-2"
                label="Conto"
                :items="allAccounts"
                item-value="id"
                item-text="name"
                v-model="donation.idA"
              ></v-autocomplete>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12" md="6">
              <v-menu
                ref="menu"
                v-model="menu"
                :close-on-content-click="false"
                :return-value.sync="donation.date_payment"
                transition="scale-transition"
                offset-y
                min-width="290px"
              >
                <template v-slot:activator="{ on }">
                  <v-text-field
                    v-model="showDate"
                    label="Data versamento"
                    class="mx-2"
                    prepend-icon="mdi-calendar"
                    readonly
                    v-on="on"
                  ></v-text-field>
                </template>
                <v-date-picker v-model="donation.date_payment" no-title scrollable>
                  <v-spacer></v-spacer>
                  <v-btn text color="primary" @click="menu = false">Cancel</v-btn>
                  <v-btn text color="primary" @click="$refs.menu.save(donation.date_payment)">OK</v-btn>
                </v-date-picker>
              </v-menu>
            </v-col>
            <v-col cols="12" md="6">
              <v-text-field
                class="mx-2"
                label="Euro"
                type="number"
                min="0"
                v-model="donation.value"
              ></v-text-field>
            </v-col>
          </v-row>

          <v-row></v-row>
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
import { mapGetters, mapActions } from "vuex";
export default {
  props: {
    dialog: {
      type: Boolean,
      default: false
    },
    donation: Object
  },
  mounted() {
    this.getGroupsNames();
    this.getCausals();
    this.getAccounts();
    if (this.donation.idP != "") {
      this.getPeopleNames(this.donation.surname);
    }
  },
  data: () => ({
    anonimo: false,
    loading: false,
    menu: false
  }),
  methods: {
    ...mapActions([
      "getCausals",
      "getPeopleNames",
      "getGroupsNames",
      "getDonations",
      "getAccounts",
      "addDonation",
      "updateDonation"
    ]),
    getFiltersNames(value) {
      if (value.length > 2) {
        this.getPeopleNames(value);
      }
    },
    onCancel() {
      this.$emit("on-cancel");
    },
    async operation() {
      let tableName =
        this.donation.type == "person"
          ? "private_donations_persons"
          : "private_donations_groups";
      let donationP = {
        id_causal: this.donation.idC,
        id_account: this.donation.idA,
        date_payment: this.donation.date_payment,
        value: this.donation.value
      };
      if (this.donation.type == "person") {
        donationP.id_person = this.anonimo ? 4309 : this.donation.idP;
      } else {
        donationP.id_group = this.donation.idG;
      }
      let params = {
        tableName: tableName,
        donation: donationP
      };
      this.loading = true;
      if (this.donation.new) await this.addDonation(params);
      else {
        donationP.id = this.donation.id;
        donationP.date_registration = this.donation.date_registration;
        await this.updateDonation(params);
      }
      this.loading = false;
      this.getDonations({ tableName: tableName });
      this.$emit("on-confirm");
    }
  },
  computed: {
    ...mapGetters([
      "allCausals",
      "allPeopleNames",
      "allGroupsNames",
      "allAccounts"
    ]),
    showDate() {
      let [year, month, day] = this.donation.date_payment.split("-");
      if (year == "") return "";
      return `${day}/${month}/${year}`;
    },
    operationTitle() {
      return this.donation.new ? "Aggiungi" : "Modifica";
    },
    operationText() {
      return this.donation.new ? "Aggiungi" : "Salva";
    }
  }
};
</script>

<style>
</style>