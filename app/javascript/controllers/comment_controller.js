import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment"
export default class extends Controller {
    static targets = ["display", "form"];

    edit() {
      this.displayTarget.style.display = "none";
      this.formTarget.style.display = "block";
    }

    cancel() {
      this.displayTarget.style.display = "block";
      this.formTarget.style.display = "none";
    }
  }