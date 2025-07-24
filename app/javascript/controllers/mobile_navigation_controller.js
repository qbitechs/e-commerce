// app/javascript/controllers/mobile_navigation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon"]

  toggle() {
    document.getElementById("mobile-menu").classList.toggle("hidden");
    this.iconTarget.classList.toggle('fa-bars')
    this.iconTarget.classList.toggle('fa-times')  
  }
}
