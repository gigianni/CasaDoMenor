import Vue from "vue";
import VueRouter from "vue-router";
import Home from "../views/Home.vue";

import Login from "../views/Login.vue";
import LoginForm from "../components/login/LoginForm.vue";
import ResetPasswordRequest from "../components/login/ResetPasswordRequest.vue";

import Dashboard from '../views/Dashboard.vue';
import People from '../views/privates/People.vue';
import Groups from '../views/privates/Groups.vue';
import DonationsPrivates from '../views/privates/DonationsPrivates.vue';
import Houses from '../views/Houses.vue'
import Banks from '../views/Banks.vue';
import Donors from '../views/Donors.vue';
import Projects from '../views/Projects.vue';
import Notes from '../views/Notes.vue';
import Stock from '../views/Stock.vue';

import UserSettings from '../views/UserSettings.vue';

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home,
    children: [
      {
        path: '',
        component: Dashboard,
        name: 'Dashboard'
      },
      {
        path: '/people',
        component: People,
        name: 'People'
      },
      {
        path: '/groups',
        component: Groups,
        name: 'Groups'
      },
      {
        path: '/donationsPrivates',
        component: DonationsPrivates,
        name: 'DonationsPrivates'
      },
      {
        path: '/houses',
        component: Houses,
        name: 'Houses'
      },
      {
        path: '/banks',
        component: Banks,
        name: 'Banks',
      },
      {
        path: '/donors',
        component: Donors,
        name: 'Donors'
      },
      {
        path: '/projects',
        component: Projects,
        name: 'Projects'
      },
      {
        path: '/notes',
        component: Notes,
        name: 'Notes'
      },
      {
        path: '/stock',
        component: Stock,
        name: 'Stock'
      },
      {
        path: '/userSettings',
        component: UserSettings,
        name: 'UserSettings'
      }
    ]
  },
  {
    path: "/login",
    name: "Login",
    component: Login,
    children: [
      {
        path: '/',
        component: LoginForm,
        name: 'gna'
      },
      {
        path: 'reset',
        component: ResetPasswordRequest,
        name: 'gnu'
      }
    ]
  }
];

const router = new VueRouter({
  routes
});

export default router;
