import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menuItem", "toggleButton"];

  connect() {
    this.toggleButtonTargets.forEach((button) => {
      button.addEventListener("click", this.toggleState.bind(this));
    });
  }

  toggleState(event) {
    const button = event.currentTarget;
    const menuItem = button
      .closest(".menu_container")
      .querySelector(".menu_items");
    menuItem.classList.toggle("active");
  }
}
