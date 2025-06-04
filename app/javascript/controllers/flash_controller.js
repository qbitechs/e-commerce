import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["flash"]

  dismiss() {
    this.flashTarget.remove()
  }
}
