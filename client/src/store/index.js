import Vue from "vue";
import Vuex from "vuex";

import axios from 'axios';

Vue.use(Vuex);

const URL = window.location.href.includes('localhost') ? "https://93.71.57.206:11333" : "";

export default new Vuex.Store({
  state: {
    privates: [],
    groups: [],

    filterDonation: null,
    privatesDonations: [],
    totalDonations: "",

    banks: [],
    donors: [],
    houses: [],
    projects: [],

    stock: [],
    stock_groups: [],

    peopleNames: [],
    groupsNames: [],
    causals: [],
    accounts: []
  },
  getters: {
    //#region Private
    allPrivates: state => state.privates,
    allGroups: state => state.groups,
    allPrivatesDonations: state => state.privatesDonations,
    donationsTotal: state => state.totalDonations,
    allCausals: state => state.causals,
    allAccounts: state => state.accounts,
    //#endregion

    allBanks: state => state.banks,
    allDonors: state => state.donors,
    allHouses: state => state.houses,
    allProjects: state => state.projects,

    //#region Stock
    allItems: state => state.stock,
    allStockGroups: state => state.stock_groups,
    //#endregion

    //#region Other
    allPeopleNames: state => state.peopleNames,
    allGroupsNames: state => state.groupsNames,
    //#endregion
  },
  actions: {
    //#region Privates
    async getPrivates({ commit }, params) {
      this.state.privates = [];
      const data = await axios.get(URL + "/api/private_persons", {
        params: params
      });
      commit('setPrivates', data.data);
    },
    async addPrivate({ commit }, params) {
      await axios.post(URL + "/api/private_persons", params);
      commit('ignore');
    },
    async updatePrivate({ commit }, params) {
      await axios.patch(URL + "/api/private_persons", params);
      commit('ignore');
    },
    async deletePrivate({ commit }, params) {
      await axios.delete(URL + "/api/private_persons?id=" + params);
      commit('ignore');
    },
    //#endregion

    //#region Groups
    async getGroups({ commit }, params) {
      this.state.groups = [];
      const data = await axios.get(URL + "/api/private_groups", {
        params: params
      });
      commit('setGroups', data.data);
    },
    async addGroup({ commit }, params) {
      await axios.post(URL + "/api/private_groups", params);
      commit('ignore');
    },
    async updateGroup({ commit }, params) {
      await axios.patch(URL + "/api/private_groups", params);
      commit('ignore');
    },
    async deleteGroup({ commit }, params) {
      await axios.delete(URL + "/api/private_groups?id=" + params);
      commit('ignore');
    },
    //#endregion

    //#region Donations
    async getDonations({ commit }, params) {
      this.state.privatesDonations = [];
      this.state.totalDonations = "";
      if (params.params != undefined) {
        this.state.filterDonation = params.params
      }
      else if (this.state.filterDonation == null) return;
      const data = await axios.get(URL + "/api/" + params.tableName, {
        params: this.state.filterDonation
      });
      let json = {
        rows: data.data.rows,
        sum: data.data.sum,
        type: params.tableName == 'private_donations_persons' ? 'person' : 'group'
      }
      commit('setDonations', json);
    },
    async addDonation({ commit }, params) {
      await axios.post(URL + '/api/' + params.tableName, params.donation);
      commit('ignore');
    },
    async updateDonation({ commit }, params) {
      await axios.patch(URL + '/api/' + params.tableName, params.donation);
      commit('ignore');
    },
    async deleteDonation({ commit }, params) {
      await axios.delete(URL + '/api/' + params.tableName + '?id=' + params.id);
      commit('ignore');
    },
    //#endregion

    //#region Manage
    async getCausals({ commit }) {
      this.state.causals = [];
      const data = await axios.get(URL + "/table/private_causals");
      commit('setCausals', data.data.rows);
    },
    async addCausal({ commit }, params) {
      await axios.post(URL + '/api/private_causals', params);
      commit('ignore');
    },
    async updateCausal({ commit }, params) {
      await axios.patch(URL + '/api/private_causals', params);
      commit('ignore');
    },
    async deleteCausal({ commit }, params) {
      await axios.delete(URL + '/api/private_causals?id=' + params);
      commit('ignore');
    },

    async getAccounts({ commit }) {
      this.state.accounts = [];
      const data = await axios.get(URL + "/table/private_accounts");
      commit('setAccounts', data.data.rows);
    },
    async addAccount({ commit }, params) {
      await axios.post(URL + '/api/private_accounts', params);
      commit('ignore');
    },
    async updateAccount({ commit }, params) {
      await axios.patch(URL + '/api/private_accounts', params);
      commit('ignore');
    },
    async deleteAccount({ commit }, params) {
      await axios.delete(URL + '/api/private_accounts?id=' + params);
      commit('ignore');
    },

    //#endregion


    async getBanks({ commit }) {
      this.state.banks = [];
      const data = await axios.get(URL + "/table/banks");
      commit('setBanks', data.data.rows);
    },

    async getDonors({ commit }) {
      this.state.donors = [];
      const data = await axios.get(URL + "/table/cdm_donors");
      commit('setDonors', data.data.rows);
    },

    async getHouses({ commit }) {
      this.state.houses = [];
      const data = await axios.get(URL + "/table/cdm_houses");
      commit('setHouses', data.data.rows);
    },

    async getProjects({ commit }) {
      this.state.projects = [];
      const data = await axios.get(URL + "/table/cdm_projects");
      commit('setProjects', data.data.rows);
    },

    //#region Stock
    async getStock({ commit }) {
      this.state.stock = [];
      const data = await axios.get(URL + "/api/private_mg_items");
      commit('setStock', data.data);
    },
    async addItem({ commit }, params) {
      await axios.post(URL + "/api/private_mg_items", params);
      commit('ignore');
    },
    async updateItem({ commit }, params) {
      await axios.patch(URL + "/api/private_mg_items", params);
      commit('ignore');
    },
    async deleteItem({ commit }, params) {
      await axios.delete(URL + "/api/private_mg_items?id=" + params);
      commit('ignore');
    },

    async getStockGroups({ commit }) {
      this.state.stock_groups = [];
      const data = await axios.get(URL + "/table/private_mg_groups");
      commit('setStockGroups', data.data.rows);
    },
    //#endregion

    //#region Other
    async getPeopleNames({
      commit
    }, value) {
      const data = await axios.get(URL + "/api/private_persons/" + value);
      commit('setPeopleNames', data.data);
    },
    async getGroupsNames({
      commit
    }) {
      this.state.groupsName = [];
      const data = await axios.get(URL + "/table/private_groups");
      commit('setGroupsNames', data.data.rows);
    }
    //#endregion
  },
  mutations: {
    ignore: () => { },
    setPrivates(state, privates) {
      for (let p of privates) {
        state.privates.push({
          ...p,
          edit: "",
          delete: ""
        });
      }
    },
    setGroups(state, groups) {
      for (let g of groups) {
        state.groups.push({
          ...g,
          edit: "",
          delete: ""
        });
      }
    },
    setDonations(state, data) {
      for (let donation of data.rows) {
        donation.date_payment = donation.date_payment.split('T')[0];
        donation.date_registration = donation.date_registration.split('T')[0];
        donation.edit = "";
        donation.delete = "";
        donation.type = data.type;
      }
      state.privatesDonations = data.rows;
      state.totalDonations = data.sum;
    },
    setCausals: (state, causals) => {
      for (let c of causals) {
        state.causals.push({
          ...c,
          edit: "",
          delete: ""
        });
      }
    },
    setAccounts: (state, accounts) => {
      for (let a of accounts) {
        state.accounts.push({
          ...a,
          edit: "",
          delete: ""
        });
      }
    },
    setBanks(state, banks) {
      for (let bank of banks) {
        state.banks.push({
          ...bank,
          edit: ""
        });
      }
    },
    setDonors: (state, donors) => state.donors = donors,
    setHouses(state, houses) {
      for (let house of houses) {
        state.houses.push({
          ...house,
          edit: ""
        });
      }
    },
    setProjects(state, projects) {
      for (let p of projects) {
        p.start_date = p.start_date.split('T')[0];
        state.projects.push({
          ...p,
          viewDetails: "",
          edit: "",
          delete: ""
        });
      }
      console.log(state.projects);
    },

    setStock(state, stock) {
      for (let a of stock) {
        state.stock.push({
          ...a,
          editQt: "",
          edit: "" /*, delete: ""*/
        });
      }
    },
    setStockGroups: (state, stock_groups) => state.stock_groups = stock_groups,

    //#region Other
    setPeopleNames: (state, people) => {
      state.peopleNames = [];
      for (let person of people) {
        state.peopleNames.push({
          id: person.id,
          text: `${person.surname} ${person.name} (${person.cfc || "CFC"}) | ${person.address}`
        });
      }
    },
    setGroupsNames(state, groups) {
      state.groupsNames.push({
        id: 0,
        text: "Tutti"
      });
      for (let group of groups) {
        let json = {
          id: group.id,
          text: group.name
        };
        if (group.reference != "" && group.reference != " ")
          json.text += ` (${group.reference})`;
        state.groupsNames.push(json);
      }
    }
    //#endregion
  },
  modules: {}
});