// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//= require jquery
import "bootstrap"
//= require bootstrap-sprockets
//= require popper
global.$ = require("jquery")
require('jquery-ui');


import Rails from "@rails/ujs"

import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()

ActiveStorage.start()
//  import '../../assets/stylesheets/application.scss'
