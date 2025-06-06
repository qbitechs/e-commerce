import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "details"]

  toggle() {
    this.detailsTarget.classList.toggle("hidden")
  }
} 