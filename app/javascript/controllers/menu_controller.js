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
    const menuId = button.dataset.menuId;

    let orders = this.getItems();

    const existingOrder = orders.find((order) => order.id == portionId);

    if (existingOrder) {
      existingOrder.quantity += 1;
    } else {
      orders.unshift({
        menuId: menuId,
        id: portionId,
        title: portionTitle,
        price: portionPrice,
        quantity: 1,
      });
    }

    localStorage.setItem("items", JSON.stringify(orders));
    this.updateOrderList();
  }

  removePortion(event) {
    const button = event.currentTarget;
    const portionId = button.dataset.portionId;

    let orders = this.getItems();

    orders = orders.filter((order) => order.id != portionId);

    localStorage.setItem("items", JSON.stringify(orders));

    this.updateOrderList();
  }

  updateOrderList() {
    const orders = this.getItems();
    const orderInputs = this.orderInputsTarget;
    const orderTotal = this.orderTotalTarget;

    orderInputs.innerHTML = "";
    orderInputs.classList =
      "bg-white flex flex-col border-2 border-gray-300 rounded gap-10 min-h-[30vh] max-h-[30vh] overflow-auto p-5 mb-10";
    orderTotal.innerHTML = "";
    let totalCost = 0;

    if (orders.length == 0) {
      const message = document.createElement("p");
      message.textContent = "Nenhuma porção foi adicionada";
      orderInputs.appendChild(message);
    }

    orders.forEach((order) => {
      totalCost += parseInt(order.price) * parseInt(order.quantity);
      const titleDiv = document.createElement("div");
      titleDiv.className = "flex gap-2";

      const div = document.createElement("div");
      const orderElement = document.createElement("p");
      orderElement.textContent = `${order.title}`;
      titleDiv.appendChild(orderElement);

      div.appendChild(titleDiv);

      const icon = document.createElement("img");
      icon.src = "/assets/trash.svg";
      icon.width = 20;
      const removeButton = document.createElement("button");
      removeButton.dataset.portionId = order.id;
      removeButton.addEventListener("click", this.removePortion.bind(this));
      removeButton.appendChild(icon);
      titleDiv.appendChild(removeButton);

      div.appendChild(this.createInput("hidden", "menu_id", order.menuId));
      div.appendChild(this.createInput("hidden", "portion_id", order.id));

      div.appendChild(this.priceAndQuantityDiv(order));

      const notesInput = document.createElement("input");
      notesInput.type = "text";
      notesInput.name = "order[order_portions][][note]";
      notesInput.placeholder = "observação";
      notesInput.classList = "input-secondary mt-5";
      div.appendChild(notesInput);

      orderInputs.appendChild(div);
    });

    const totalPriceText = document.createElement("p");
    totalPriceText.textContent = `Total: R$ ${this.formatPrice(totalCost)}`;
    orderTotal.appendChild(totalPriceText);
  }

  getItems() {
    return JSON.parse(localStorage.getItem("items")) || [];
  }

  formatPrice(price) {
    let priceString = price.toString();
    const indexToInsertAt = priceString.length - 2;
    let separator = ",";
    if (indexToInsertAt < 2) {
      separator = "0,";
    }
    if (indexToInsertAt < 0) {
      separator = "0,0";
    }

    const formattedPrice =
      priceString.slice(0, indexToInsertAt) +
      separator +
      priceString.slice(indexToInsertAt);

    return formattedPrice;
  }

  priceAndQuantityDiv(order) {
    const informationDiv = document.createElement("div");
    informationDiv.classList = "flex gap-10";

    const itemTotalPrice = order.quantity * order.price;
    const price = document.createElement("p");
    price.textContent = `R$ ${this.formatPrice(itemTotalPrice)}`;
    informationDiv.appendChild(price);

    const quantityDiv = document.createElement("div");
    quantityDiv.className = "flex gap-5";

    quantityDiv.appendChild(this.quantityButton(order, "-", -1));

    const quantityP = document.createElement("p");
    quantityP.textContent = order.quantity;
    quantityDiv.appendChild(quantityP);

    quantityDiv.appendChild(this.quantityButton(order, "+", 1));

    informationDiv.appendChild(
      this.createInput("hidden", "quantity", order.quantity)
    );
    informationDiv.appendChild(quantityDiv);

    return informationDiv;
  }

  quantityButton(order, text, value) {
    const Button = document.createElement("p");
    Button.textContent = text;
    Button.classList = "cursor-pointer";
    Button.dataset.id = order.id;
    Button.addEventListener("click", (event) =>
      this.changeQuantity(event, value)
    );

    return Button;
  }

  changeQuantity(event, value) {
    const button = event.currentTarget;
    const itemId = button.dataset.id;

    let items = this.getItems();
    const item = items.find((item) => item.id == itemId);
    if (item.quantity + value >= 1) {
      item.quantity += value;
    }
    localStorage.setItem("items", JSON.stringify(items));
    this.updateOrderList();
  }

  createInput(type, name, value) {
    const input = document.createElement("input");
    input.type = type;
    input.name = `order[order_portions][][${name}]`;
    input.value = value;

    return input;
  }
}
