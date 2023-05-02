//= require jquery3
//= require popper
//= require bootstrap-sprockets
import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
