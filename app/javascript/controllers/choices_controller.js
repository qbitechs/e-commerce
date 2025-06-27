import { Controller } from "@hotwired/stimulus";
import "choices";

export default class extends Controller {
  connect() {
    document.querySelectorAll("select").forEach((select) => {
      const dataAttributes = select.dataset;
      if (dataAttributes.initializeChoices) {
        try {
          new Choices(select, {
            addChoices: dataAttributes.addChoice || false,
          });
        } catch (err) {
          console.log(err);
        }
      }
    });
  }
}
