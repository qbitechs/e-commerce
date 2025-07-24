// app/javascript/controllers/mobile_navigation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["icon"]


  connect() {
    this.menuOpen = false
  }

  toggle() {
    document.getElementById("mobile-menu").classList.toggle("hidden");
    this.menuOpen = !this.menuOpen

    if (this.menuOpen) {
      this.iconTarget.classList.remove("fa-bars")
      this.iconTarget.classList.add("fa-times")
    } else {
      this.iconTarget.classList.remove("fa-times")
      this.iconTarget.classList.add("fa-bars")
    }
  }

}
