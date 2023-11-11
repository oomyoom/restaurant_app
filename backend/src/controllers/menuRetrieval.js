const databaseUtils = require("../utils/databaseUtils");

async function retrieveMenu() {
  const allMenu = [];

  try {
    const menuQuery = `SELECT * FROM menu`;
    const menuResults = await databaseUtils.getDataFromDB(menuQuery);

    if (menuResults.length > 0) {
      for (let i = 0; i < menuResults.length; i++) {
        const categoryIdQuery = `SELECT category_id, category_title FROM mcategory WHERE menu_id = ${menuResults[i].menu_id}`;
        const categoryResults = await databaseUtils.getDataFromDB(
          categoryIdQuery
        );

        if (categoryResults.length > 0) {
          for (let j = 0; j < categoryResults.length; j++) {
            const optionQuery = `SELECT option_title, option_price FROM moption WHERE category_id = ${categoryResults[j].category_id}`;
            const optionResults = await databaseUtils.getDataFromDB(
              optionQuery
            );

            if (optionResults.length > 0) {
              categoryResults[j].options = optionResults;
            }
          }

          menuResults[i].categories = categoryResults;
          allMenu.push(menuResults[i]);
        }
      }
    }

    return allMenu;
  } catch (error) {
    throw error;
  }
}

async function retrieveMenuUser() {
  const allMenu = [];

  try {
    const menuQuery = `SELECT * FROM menu WHERE available = 1`;
    const menuResults = await databaseUtils.getDataFromDB(menuQuery);

    if (menuResults.length > 0) {
      for (let i = 0; i < menuResults.length; i++) {
        const categoryIdQuery = `SELECT category_id, category_title FROM mcategory WHERE menu_id = ${menuResults[i].menu_id}`;
        const categoryResults = await databaseUtils.getDataFromDB(
          categoryIdQuery
        );

        if (categoryResults.length > 0) {
          for (let j = 0; j < categoryResults.length; j++) {
            const optionQuery = `SELECT option_title, option_price FROM moption WHERE category_id = ${categoryResults[j].category_id}`;
            const optionResults = await databaseUtils.getDataFromDB(
              optionQuery
            );

            if (optionResults.length > 0) {
              categoryResults[j].options = optionResults;
            }
          }

          menuResults[i].categories = categoryResults;
          allMenu.push(menuResults[i]);
        }
      }
    }

    return allMenu;
  } catch (error) {
    throw error;
  }
}

module.exports = { retrieveMenu, retrieveMenuUser };
