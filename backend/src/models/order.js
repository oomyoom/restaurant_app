const { DateTime } = require("luxon");

const orderData = {
  order_total: 16,
  createDateTime: DateTime.now().toFormat("yyyy-MM-dd HH:mm:ss"),
  deliveryOption: "Take-Away",
  isCompleted: false,
  isRecieved: false,
};

module.exports = { orderData };
