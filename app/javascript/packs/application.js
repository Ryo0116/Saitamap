import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap";
import "../stylesheets/application.scss";

Rails.start()
Turbolinks.start()
ActiveStorage.start()
require("@rails/activestorage").start();
require("channels").
require("@rails/ujs").start()

window.Noty = require("noty")