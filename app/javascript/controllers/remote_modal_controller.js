import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  show() {
    const modal = document.getElementById("remotemodal")
    if (modal) {
      modal.classList.remove("hidden")
      modal.classList.add("flex")
    }
  }
  
  close() {
    const modal = document.getElementById("remotemodal")
    if (modal) {
      modal.classList.add("hidden")
      modal.classList.remove("flex")
    }
  }
}
