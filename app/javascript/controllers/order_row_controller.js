import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row", "details"]

  toggle(event) {
    const orderId = event.currentTarget.dataset.orderId;
    // Find the details row with the same order id
    const detailsRow = Array.from(document.querySelectorAll('[data-order-row-target="details"]')).find(
      row => row.dataset.orderId === orderId
    );
    if (detailsRow) {
      detailsRow.classList.toggle("hidden");
    }
  }
} 