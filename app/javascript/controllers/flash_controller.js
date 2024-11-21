import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["flashDiv", "flashText"];
  connect() {
    if (this.flashTextTarget.textContent.trim() != "") {
      this.flashDivTarget.classList.remove("hidden");
      this.flashDivTarget.classList.add("block");
    }
  }

  updateFlash() {
    this.flashDivTarget.classList = "block";
  }

  closeFlash() {
    this.flashDivTarget.classList = "hidden";
  }
}
