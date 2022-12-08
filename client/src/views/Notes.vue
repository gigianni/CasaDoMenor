<template>
  <v-container>
    <Alerts
      :info="alert.added"
      info-text="Nota aggiunta con successo."
      :success="alert.edited"
      successText="Nota aggiornata con successo."
      :error="alert.removed"
      errorText="Nota eliminata."
      class="ml-n3"
    />
    <v-row>
      <v-col cols="12" md="5">
        <v-card>
          <v-card-title class="display-1 mb-n2">Filtri</v-card-title>
          <v-card-text>
            <DatePicker :date="month" @on-date-selected="changeMonth" />
            <v-row>
              <v-col size="4" md="4">
                <p class="title black--text">Paesi:</p>
                <v-checkbox label="Italia" v-model="filters.italy" class="mb-n8"></v-checkbox>
                <v-checkbox label="Brasile" v-model="filters.brazil"></v-checkbox>
              </v-col>
              <v-col size="8" md="8">
                <p class="title black--text">Progetti:</p>
                <v-select
                  outlined
                  solo
                  label="Progetto"
                  :items="filters.projects"
                  v-model="filters.projectSelected"
                  clearable
                ></v-select>
              </v-col>
            </v-row>
          </v-card-text>
          <div style="overflow: auto">
            <v-btn color="primary" text class="float-right mb-2 mr-1">Applica filtri</v-btn>
            <v-btn color="error" text class="float-right">Rimuovi filtri</v-btn>
          </div>
        </v-card>
      </v-col>
      <v-col cols="12" md="1"></v-col>
      <v-col cols="12" md="6" class="pr-9">
        <v-btn color="primary" block class="mb-5" @click="showForm('new')">Aggiungi nota</v-btn>
        <NoteCard
          v-for="n in notes"
          :key="n.id"
          :note="n"
          @on-edit="showForm"
          @on-delete="showRemove"
        />
      </v-col>
    </v-row>

    <NoteRemove
      :dialog="dialog.remove"
      :note="noteCopy"
      :loading="dialog.loading"
      :disabled="dialog.disabled"
      @on-cancel="dialog.remove = false"
      @on-confirm="removeNote"
    />
    <NoteForm
      :dialog="dialog.form"
      :note="noteCopy"
      :loading="dialog.loading"
      :disabled="dialog.disabled"
      @on-cancel="dialog.form = false"
      @on-save="save"
      @on-add="add"
    />
  </v-container>
</template>

<script>
import Alerts from "../components/Alerts";
import DatePicker from "../components/DatePicker";
import NoteCard from "../components/notes/NoteCard";
import NoteRemove from "../components/notes/NoteRemove";
import NoteForm from "../components/notes/NoteForm";

export default {
  components: {
    Alerts,
    DatePicker,
    NoteCard,
    NoteRemove,
    NoteForm
  },
  data() {
    return {
      filters: {
        date: "",
        italy: true,
        brazil: true,
        projects: ["Progetto 1", "Progetto 2"],
        projectsSelected: null
      },
      dialog: {
        picker: true,
        remove: false,
        form: false,
        loading: false,
        disabled: false
      },
      alert: {
        added: false,
        edited: false,
        removed: false
      },
      month: new Date().toISOString().substr(0, 7),
      lastId: 2,
      notes: [
        {
          id: 1,
          title: "Nota",
          chips: ["Italia", "Brasile"],
          description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " +
            "In nulla urna, auctor et arcu nec, pretium faucibus tellus. " +
            "Suspendisse dui odio, aliquam vitae massa eu, hendrerit pulvinar metus. " +
            "Nunc ut ipsum quis felis feugiat aliquet at vitae ipsum. " +
            "Suspendisse id metus vel nulla hendrerit ullamcorper ac blandit nibh. " +
            "Sed ligula ligula, facilisis at luctus at, varius fringilla diam. " +
            "Vestibulum dictum purus et velit ultricies vestibulum."
        },
        {
          id: 2,
          title: "Nota",
          chips: ["Italia", "Brasile"],
          description:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " +
            "In nulla urna, auctor et arcu nec, pretium faucibus tellus. " +
            "Suspendisse dui odio, aliquam vitae massa eu, hendrerit pulvinar metus. " +
            "Nunc ut ipsum quis felis feugiat aliquet at vitae ipsum. " +
            "Suspendisse id metus vel nulla hendrerit ullamcorper ac blandit nibh. " +
            "Sed ligula ligula, facilisis at luctus at, varius fringilla diam. " +
            "Vestibulum dictum purus et velit ultricies vestibulum."
        }
      ],
      noteCopy: {},
      note: {}
    };
  },
  methods: {
    changeMonth(date) {
      this.month = date;
    },

    //#region NoteForm
    showForm(item) {
      if (item === "new")
        this.noteCopy = {
          id: ++this.lastId,
          title: "",
          description: "",
          chips: [],
          new: true
        };
      else
        this.noteCopy = {
          ...item,
          chips: [...item.chips],
          new: false
        };
      this.dialog.form = true;
    },
    save(item) {
      console.log(item);
      this.dialog.loading = true;
      this.dialog.disabled = true;

      //emula la richiesta della modifica della nota
      //o eventualmente della singola nota
      setTimeout(() => {
        this.dialog.loading = false;
        this.dialog.disabled = false;

        this.dialog.form = false;
        this.alert.edited = true;

        setTimeout(() => {
          this.alert.edited = false;
        }, 5000);
      }, 2000);
    },
    add(item) {
      console.log(item);

      this.dialog.loading = true;
      this.dialog.disabled = true;

      //emula la richiesta dell'aggiunta della nota
      setTimeout(() => {
        item.new = false;

        this.dialog.loading = false;
        this.dialog.disabled = false;

        this.dialog.form = false;
        this.alert.added = true;
        setTimeout(() => {
          this.alert.added = false;
        }, 5000);
      }, 2000);
    },
    //#endregion

    //#region NoteRemove
    showRemove(item) {
      this.note = item;
      this.dialog.remove = true;
    },
    removeNote(item) {
      console.log(item);

      this.dialog.loading = true;
      this.dialog.disabled = true;

      setTimeout(() => {
        this.dialog.loading = false;
        this.dialog.disabled = false;

        this.dialog.remove = false;
        this.alert.removed = true;
        setTimeout(() => {
          this.alert.removed = false;
        }, 5000);
      }, 2000);
    }
    //#endregion
  }
};
</script>

<style>
</style>