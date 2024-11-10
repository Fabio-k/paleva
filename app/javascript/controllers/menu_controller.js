import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "menuItem",
    "toggleButton",
    "portionButton",
    "orderList",
    "orderInputs",
    "orderTotal",
  ];

  connect() {
    this.toggleButtonTargets.forEach((button) => {
      button.addEventListener("click", this.toggleState.bind(this));
    });
    this.portionButtonTargets.forEach((button) => {
      button.addEventListener("click", this.togglePortion.bind(this));
    });
    this.updateOrderList();
  }

  toggleState(event) {
    const button = event.currentTarget;
    const menuItem = button
      .closest(".menu_container")
      .querySelector(".menu_items");
    menuItem.classList.toggle("active");
  }

  togglePortion(event) {
    const button = event.currentTarget;
    const portionId = button.dataset.portionId;
    const portionTitle = button.dataset.portionTitle;
    const portionPrice = button.dataset.portionPrice;

    let orders = JSON.parse(localStorage.getItem("orders")) || [];

    const existingOrder = orders.find((order) => order.id == portionId);

    if (existingOrder) {
      existingOrder.quantity += 1;
    } else {
      orders.push({
        id: portionId,
        title: portionTitle,
        price: portionPrice,
        quantity: 1,
      });
    }

    localStorage.setItem("orders", JSON.stringify(orders));
    this.updateOrderList();
  }

  removePortion(event) {
    const button = event.currentTarget;
    const portionId = button.dataset.portionId;

    let orders = JSON.parse(localStorage.getItem("orders"));

    orders = orders.filter((order) => order.id != portionId);

    localStorage.setItem("orders", JSON.stringify(orders));

    this.updateOrderList();
  }

  updateOrderList() {
    const orders = JSON.parse(localStorage.getItem("orders"));
    const orderInputs = this.orderInputsTarget;
    const orderTotal = this.orderTotalTarget;

    orderInputs.innerHTML = "";
    orderTotal.innerHTML = "";
    let totalCost = 0;
    orders.forEach((order) => {
      totalCost += parseInt(order.price);
      const titleDiv = document.createElement("div");
      titleDiv.className = "flex gap-2";

      const div = document.createElement("div");
      const orderElement = document.createElement("p");
      orderElement.textContent = `${order.title}`;
      titleDiv.appendChild(orderElement);

      div.appendChild(titleDiv);

      const removeButton = document.createElement("button");
      removeButton.textContent = "Remover";
      removeButton.dataset.portionId = order.id;
      removeButton.addEventListener("click", this.removePortion.bind(this));
      titleDiv.appendChild(removeButton);

      const input = document.createElement("input");
      input.type = "hidden";
      input.name = `order[order_portions][][portion_id]`;
      input.value = order.id;
      div.appendChild(input);

      const quantityInput = document.createElement("input");
      quantityInput.type = "hidden";
      quantityInput.name = `order[order_portions][][quantity]`;
      quantityInput.value = order.quantity;
      div.appendChild(quantityInput);

      const notesInput = document.createElement("input");
      notesInput.type = "text";
      notesInput.name = "order[order_portions][][note]";
      notesInput.placeholder = "observação";
      div.appendChild(notesInput);

      orderInputs.appendChild(div);
    });

    const totalPriceText = document.createElement("p");

    let totalCostString = totalCost.toString();
    const indexToInsertAt = totalCostString.length - 2;
    let separator = indexToInsertAt > 1 ? "," : "0,";
    const formattedPrice =
      totalCostString.slice(0, indexToInsertAt) +
      separator +
      totalCostString.slice(indexToInsertAt);
    formattedPrice.i;
    totalPriceText.textContent = `Total: R$ ${formattedPrice}`;
    orderTotal.appendChild(totalPriceText);
  }
}
