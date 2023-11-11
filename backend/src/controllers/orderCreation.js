const { db } = require("../config/database");
const { DateTime } = require("luxon");

function insertOrder(orderData, lastOrderId, uid, callback) {
  const query =
    "INSERT INTO `order` (order_total, createDateTime, deliveryOption, isCompleted, isRecieved, isReaded, uid) VALUES (?, ?, ?, ?, ?, ?, ?)";

  const createDateTime = DateTime.fromFormat(
    orderData.createDateTime,
    "yyyy-MM-dd HH:mm:ss"
  );

  const values = [
    orderData.order_total,
    createDateTime.toISO(),
    orderData.deliveryOption,
    orderData.isCompleted,
    orderData.isRecieved,
    orderData.isReaded,
    uid,
  ];

  db.query(query, values, (error, results) => {
    if (error) {
      console.error("Error inserting data into order", error);
      callback(error);
    } else {
      console.log("Data inserted into order ", results);
      callback(null, lastOrderId);
    }
  });
}

function getMenuIdByTitle(menuTitle, callback) {
  const query = "SELECT menu_id FROM menu WHERE menu_title = ?";

  db.query(query, [menuTitle], (error, results) => {
    if (error) {
      console.error("เกิดข้อผิดพลาดในการค้นหา menu_id:", error);
      callback(error, null);
    } else {
      if (results.length > 0) {
        const menuId = results[0].menu_id;
        callback(null, menuId);
      } else {
        callback("ไม่พบ menu_id สำหรับ menu_title ที่ระบุ", null);
      }
    }
  });
}

function insertCart(cartData, lastOrderId, callback) {
  const query =
    "INSERT INTO cart (option_item, option_total, cart_total, cart_qty,menu_id, order_id) VALUES ?";
  const promises = cartData.map((item) => {
    const menuTitle = item.cart_item;

    return new Promise((resolve, reject) => {
      getMenuIdByTitle(menuTitle, (error, menuId) => {
        if (error) {
          console.error("เกิดข้อผิดพลาด:", error);
          reject(error);
        } else {
          const values = [
            item.option_item,
            item.option_total,
            item.cart_total,
            item.cart_qty,
            menuId,
            lastOrderId,
          ];
          resolve(values);
        }
      });
    });
  });

  Promise.all(promises)
    .then((values) => {
      db.query(query, [values], (error, results) => {
        if (error) {
          console.error("Error inserting data into cart:", error);
          callback(error);
        } else {
          console.log("Data inserted into cart:", results);
          callback(null);
        }
      });
    })
    .catch((error) => {
      callback(error);
    });
}

module.exports = {
  insertOrder,
  insertCart,
};
