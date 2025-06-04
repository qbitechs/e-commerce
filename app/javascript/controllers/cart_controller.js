import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
  }

  increment() {
    const countElement = document.getElementById("count");
    const count = Number(countElement.textContent) || 0;
    countElement.textContent = count + 1;
  }
}
