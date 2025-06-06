import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["count"]
  
  increment(e) {
    e.preventDefault();
    this.updateCount(1);
  }
  
  decrement(e) {
    e.preventDefault();
    this.updateCount(-1);
  }
  
  updateCount(delta) {
    if (!this.hasCountTarget) {
      console.error("Count target not found");
      return;
    }
    
    let count = parseInt(this.countTarget.value, 10) || 0;
    const newCount = Math.max(1, count + delta); // Prevent going below 1
    this.countTarget.value = newCount;
    
  }
}