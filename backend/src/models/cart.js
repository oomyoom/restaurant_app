const { menuData } = require("./menu");

const cartData = [
  {
    cart_item: menuData,
    option_item: "Normal",
    option_total: 3,
    cart_total: 3,
    cart_qty: 1,
  },
  {
    cart_item: menuData,
    option_item: "Special",
    option_total: 10,
    cart_total: 13,
    cart_qty: 1,
  },
];

module.exports = { cartData };
