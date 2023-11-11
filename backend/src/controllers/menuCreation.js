const { db } = require("../config/database");

function insertMenu(menuData, imageBuffer, lastMenuId, callback) {
  const insertQuery =
    "INSERT INTO menu (menu_title, menu_image, menu_price, available) VALUES (?, ?, ?, ?)";
  const values = [menuData.menu_title, imageBuffer, menuData.menu_price, 1];

  db.query(insertQuery, values, (error, results) => {
    if (error) {
      console.error("Error inserting data into menu:", error);
      callback(error);
    } else {
      console.log("Data inserted into menu:", results);
      callback(null, lastMenuId);
    }
  });
}

function insertCategory(categoryData, lastMenuId, lastCateId, callback) {
  const query = "INSERT INTO mcategory (category_title, menu_id) VALUES ?";
  const values = categoryData.map((category) => [
    category.category_title,
    lastMenuId,
  ]);

  db.query(query, [values], (error, results) => {
    if (error) {
      console.error("Error inserting data into mcategory:", error);
      callback(error);
    } else {
      console.log("Data inserted into mcategory:", results);
      callback(null, lastCateId);
    }
  });
}

function insertOption(categoryData, lastCateId, callback) {
  const query =
    "INSERT INTO moption (option_title, option_price, category_id) VALUES ?";
  const values = categoryData.reduce((optionValues, category) => {
    const categoryOptions = category.options.map((option) => [
      option.option_title,
      option.option_price,
      lastCateId,
    ]);
    lastCateId++;
    return optionValues.concat(categoryOptions);
  }, []);

  db.query(query, [values], (error, results) => {
    if (error) {
      console.error("Error inserting data into moption:", error);
      callback(error);
    } else {
      console.log("Data inserted into moption:", results);
      callback(null);
    }
  });
}

module.exports = {
  insertMenu,
  insertCategory,
  insertOption,
};
