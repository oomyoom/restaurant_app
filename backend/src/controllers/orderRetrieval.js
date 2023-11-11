const databaseUtils = require("../utils/databaseUtils");

async function retrieveOrder(uid) {
  const allOrder = [];

  try {
    const orderQuery = `SELECT * FROM \`order\` WHERE uid = ${uid}`;
    const orderResults = await databaseUtils.getDataFromDB(orderQuery);

    if (orderResults.length > 0) {
      for (let i = 0; i < orderResults.length; i++) {
        const cartQuery = `SELECT * FROM cart WHERE order_id = ${orderResults[i].order_id}`;
        const cartResults = await databaseUtils.getDataFromDB(cartQuery);

        if (cartResults.length > 0) {
          for (let j = 0; j < cartResults.length; j++) {
            const menuQuery = `SELECT * FROM menu WHERE menu_id = ${cartResults[j].menu_id}`;
            const [menuResults] = await databaseUtils.getDataFromDB(menuQuery);

            delete cartResults[j].menu_id, delete cartResults[j].order_id;
            cartResults[j].menu = menuResults;
          }
        }
        orderResults[i].cart = cartResults;
        allOrder.push(orderResults[i]);
      }
    }
    return allOrder;
  } catch (error) {
    throw error;
  }
}

async function retrieveOrderRestaurant(isCompleted) {
  const allOrder = [];

  try {
    const orderQuery = `SELECT * FROM \`order\` WHERE isCompleted = ${isCompleted}`;
    const orderResults = await databaseUtils.getDataFromDB(orderQuery);

    if (orderResults.length > 0) {
      for (let i = 0; i < orderResults.length; i++) {
        const cartQuery = `SELECT * FROM cart WHERE order_id = ${orderResults[i].order_id}`;
        const cartResults = await databaseUtils.getDataFromDB(cartQuery);

        if (cartResults.length > 0) {
          for (let j = 0; j < cartResults.length; j++) {
            const menuQuery = `SELECT * FROM menu WHERE menu_id = ${cartResults[j].menu_id}`;
            const [menuResults] = await databaseUtils.getDataFromDB(menuQuery);

            delete cartResults[j].menu_id, delete cartResults[j].order_id;
            cartResults[j].menu = menuResults;
          }
        }
        const phonenumberQuery = `SELECT phonenumber FROM users WHERE uid = ${orderResults[i].uid}`;
        const phonenumberResults = await databaseUtils.getDataFromDB(
          phonenumberQuery
        );
        orderResults[i].cart = cartResults;
        orderResults[i].phonenumber = phonenumberResults[0].phonenumber;
        allOrder.push(orderResults[i]);
      }
    }
    return allOrder;
  } catch (error) {
    throw error;
  }
}

async function retrieveOrderRestaurantThisWeek() {
  const allOrder = [];

  try {
    const orderQuery = `SELECT * FROM \`order\` WHERE isCompleted = 1 && WEEK(createDateTime) = WEEK(CURDATE())`;
    const orderResults = await databaseUtils.getDataFromDB(orderQuery);

    if (orderResults.length > 0) {
      for (let i = 0; i < orderResults.length; i++) {
        const cartQuery = `SELECT * FROM cart WHERE order_id = ${orderResults[i].order_id}`;
        const cartResults = await databaseUtils.getDataFromDB(cartQuery);

        if (cartResults.length > 0) {
          for (let j = 0; j < cartResults.length; j++) {
            const menuQuery = `SELECT * FROM menu WHERE menu_id = ${cartResults[j].menu_id}`;
            const [menuResults] = await databaseUtils.getDataFromDB(menuQuery);

            delete cartResults[j].menu_id, delete cartResults[j].order_id;
            cartResults[j].menu = menuResults;
          }
        }
        const phonenumberQuery = `SELECT phonenumber FROM users WHERE uid = ${orderResults[i].uid}`;
        const phonenumberResults = await databaseUtils.getDataFromDB(
          phonenumberQuery
        );
        orderResults[i].cart = cartResults;
        orderResults[i].phonenumber = phonenumberResults[0].phonenumber;
        allOrder.push(orderResults[i]);
      }
    }
    return allOrder;
  } catch (error) {
    throw error;
  }
}

async function retrieveOrderRestaurantThisDay() {
  const allOrder = [];

  try {
    const orderQuery = `SELECT * FROM \`order\` WHERE isCompleted = 1 && DATE(createDateTime) = CURDATE()`;
    const orderResults = await databaseUtils.getDataFromDB(orderQuery);

    if (orderResults.length > 0) {
      for (let i = 0; i < orderResults.length; i++) {
        const cartQuery = `SELECT * FROM cart WHERE order_id = ${orderResults[i].order_id}`;
        const cartResults = await databaseUtils.getDataFromDB(cartQuery);

        if (cartResults.length > 0) {
          for (let j = 0; j < cartResults.length; j++) {
            const menuQuery = `SELECT * FROM menu WHERE menu_id = ${cartResults[j].menu_id}`;
            const [menuResults] = await databaseUtils.getDataFromDB(menuQuery);

            delete cartResults[j].menu_id, delete cartResults[j].order_id;
            cartResults[j].menu = menuResults;
          }
        }
        const phonenumberQuery = `SELECT phonenumber FROM users WHERE uid = ${orderResults[i].uid}`;
        const phonenumberResults = await databaseUtils.getDataFromDB(
          phonenumberQuery
        );
        orderResults[i].cart = cartResults;
        orderResults[i].phonenumber = phonenumberResults[0].phonenumber;
        allOrder.push(orderResults[i]);
      }
    }
    return allOrder;
  } catch (error) {
    throw error;
  }
}

async function retrieveOrderRestaurantThisMonth() {
  const allOrder = [];

  try {
    const orderQuery = `SELECT * FROM \`order\` WHERE isCompleted = 1 && createDateTime >= DATE_SUB(NOW(), INTERVAL 30 DAY) && createDateTime <= NOW()`;
    const orderResults = await databaseUtils.getDataFromDB(orderQuery);

    if (orderResults.length > 0) {
      for (let i = 0; i < orderResults.length; i++) {
        const cartQuery = `SELECT * FROM cart WHERE order_id = ${orderResults[i].order_id}`;
        const cartResults = await databaseUtils.getDataFromDB(cartQuery);

        if (cartResults.length > 0) {
          for (let j = 0; j < cartResults.length; j++) {
            const menuQuery = `SELECT * FROM menu WHERE menu_id = ${cartResults[j].menu_id}`;
            const [menuResults] = await databaseUtils.getDataFromDB(menuQuery);

            delete cartResults[j].menu_id, delete cartResults[j].order_id;
            cartResults[j].menu = menuResults;
          }
        }
        const phonenumberQuery = `SELECT phonenumber FROM users WHERE uid = ${orderResults[i].uid}`;
        const phonenumberResults = await databaseUtils.getDataFromDB(
          phonenumberQuery
        );
        orderResults[i].cart = cartResults;
        orderResults[i].phonenumber = phonenumberResults[0].phonenumber;
        allOrder.push(orderResults[i]);
      }
    }
    return allOrder;
  } catch (error) {
    throw error;
  }
}

module.exports = {
  retrieveOrder,
  retrieveOrderRestaurant,
  retrieveOrderRestaurantThisWeek,
  retrieveOrderRestaurantThisDay,
  retrieveOrderRestaurantThisMonth,
};
