import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "details"]

  toggle(event) {
    const orderId = event.currentTarget.dataset.orderId
    const detailsEl = this.detailsTargets.find(el =>
      el.dataset.orderId === orderId
    )
    if (detailsEl) {
      detailsEl.classList.toggle("hidden")
    }
  }
}
