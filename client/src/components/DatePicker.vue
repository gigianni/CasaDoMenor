<template>
  <v-menu
    ref="menu"
    v-model="menu"
    :close-on-content-click="false"
    transition="scale-transition"
    offset-y
    min-width="290px"
  >
    <template v-slot:activator="{ on }">
      <v-text-field
        :value="dateFormatter"
        :label="label"
        prepend-icon="mdi-calendar"
        readonly
        clearable
        @click:clear="clear"
        v-on="on"
        :disabled="disabled"
      ></v-text-field>
    </template>
    <v-date-picker v-model="dateCopy" type="month" no-title scrollable @input="close"></v-date-picker>
  </v-menu>
</template>

<script>
export default {
  props: {
    date: {
      type: String,
      default: new Date().toISOString().substr(0, 10)
    },
    label: {
      type: String,
      default: ""
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      menu: false,
      dateCopy: "" + this.date
    };
  },
  computed: {
    dateFormatter() {
      let date = this.date.split("-");
      return date.length == 2 ? `${date[1]}/${date[0]}` : "";
    }
  },
  methods: {
    clear() {
      this.menu = false;
      this.$emit("on-date-selected", "");
    },
    close() {
      this.menu = false;
      this.$emit("on-date-selected", this.dateCopy);
    }
  }
};
</script>

<style>
</style>