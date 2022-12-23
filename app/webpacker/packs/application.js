/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'bootstrap/dist/js/bootstrap';
// Expose $ to our local script tags
import $ from "expose-loader?exposes=$,jQuery!jquery";
require('bootstrap-datepicker/dist/js/bootstrap-datepicker.js')
require('bootstrap-datepicker/dist/locales/bootstrap-datepicker.fr.min.js')

import Rails from "@rails/ujs"
import Turbolinks from 'turbolinks';

import 'afs';
import 'hardwares';
import 'i18n-for-js/index.js.erb';

Rails.start();
Turbolinks.start();
