<template>
  <v-navigation-drawer
    v-model="drawer"
    permanent
    color="#147513"
    dark
    app
    :mini-variant="small"
    :expand-on-hover="small"
  >
    <v-list nav>
      <v-list-item two-line class="px-0">
        <v-list-item-avatar>
          <v-img src="../assets/user.png"></v-img>
          <!-- <v-icon large>mdi-account</v-icon> -->
        </v-list-item-avatar>

        <v-list-item-content>
          <v-list-item-title>Utente</v-list-item-title>
          <v-list-item-subtitle>Tipo utente</v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>

      <v-divider></v-divider>

      <v-list-item-group class="my-3">
        <v-list-item
          dense
          v-for="page in pages"
          :disabled="page.disabled"
          :key="page.title"
          :to="page.path"
        >
          <v-list-item-icon>
            <v-icon>{{ page.icon }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>{{ page.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
    <template v-slot:append>
      <v-list nav>
        <v-list-item-group>
          <v-list-item to="/userSettings">
            <v-list-item-icon>
              <v-icon>mdi-cog</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>Gestione utenti</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </template>
  </v-navigation-drawer>
</template>

<script>
export default {
  props: {
    small: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      drawer: true,
      pages: [
        {
          title: "Daskboard",
          icon: "mdi-view-dashboard",
          path: "/",
          disabled: true
        },
        {
          title: "Privati",
          icon: "mdi-account",
          path: "/people",
          disabled: false
        },
        {
          title: "Gruppi",
          icon: "mdi-account-multiple",
          path: "/groups",
          disabled: false
        },
        {
          title: "Donazioni",
          icon: "mdi-cash",
          path: "/donationsPrivates",
          disabled: false
        },
        {
          title: "Case",
          icon: "mdi-home",
          path: "/houses",
          disabled: true
        },
        {
          title: "Banche",
          icon: "mdi-home-currency-usd ",
          path: "/banks",
          disabled: true
        },
        {
          title: "Finanziatori",
          icon: "mdi-finance",
          path: "/donors",
          disabled: true
        },
        {
          title: "Progetti",
          icon: "mdi-ballot",
          path: "/projects",
          disabled: true
        },
        {
          title: "Note",
          icon: "mdi-note",
          path: "/notes",
          disabled: true
        },
        {
          title: "Stock",
          icon: "mdi-box",
          path: "/stock",
          disabled: false
        }
      ]
    };
  },
  computed: {
    bg() {
      return this.background
        ? "https://cdn.vuetifyjs.com/images/backgrounds/bg-2.jpg"
        : undefined;
    }
  }
};
</script>