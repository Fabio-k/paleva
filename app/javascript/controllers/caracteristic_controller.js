import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {}

  updateItems() {
    const caracteristics = document.querySelectorAll(
      'input[name="caracteristic"]'
    );
    const items = document.querySelectorAll(".item");

    const values = Array.from(caracteristics).map((ci) => ci.value);
    const selectedValues = Array.from(caracteristics)
      .filter((c) => c.checked)
      .map((ci) => ci.value);

    values.forEach((c) => {
      const label = document.querySelector(`#${c}label`);
      if (selectedValues.includes(c)) {
        label.classList.remove("bg-amber-500");
        label.classList.add("bg-amber-700");
      } else {
        label.classList.remove("bg-amber-700");
        label.classList.add("bg-amber-500");
      }
    });

    items.forEach((item) => {
      const caracteristicsList = JSON.parse(item.dataset.caracteristics);
      const isVisible = selectedValues.every((c) =>
        caracteristicsList.includes(c)
      );

      item.style.display = isVisible ? "block" : "none";
    });
  }
}
