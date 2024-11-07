import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.itemTypeSelect = document.getElementById("item_type_select");
    this.alcoholicField = document.getElementById("alcoholic_field");
    this.toggleAlcoholicField();
    this.itemTypeSelect.addEventListener(
      "change",
      this.toggleAlcoholicField.bind(this)
    );
  }

  toggleAlcoholicField() {
    if (this.itemTypeSelect.value === "Beverage") {
      this.alcoholicField.style.display = "block";
    } else {
      this.alcoholicField.style.display = "none";
    }
  }
}
