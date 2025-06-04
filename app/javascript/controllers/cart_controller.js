import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  increment(event) {
    event.target.disabled = true
    event.target.textContent = "Adding..."
        
    event.target.classList.add("opacity-50", "cursor-not-allowed")
    event.target.classList.remove("hover:from-indigo-700", "hover:to-purple-700")

    this.disableButton(event.currentTarget);
    
    const countElement = document.getElementById("count");
    const count = Number(countElement.textContent) || 0;
    countElement.textContent = count + 1;
  }
}
