const databaseUtils = require("../utils/databaseUtils");

async function retrieveUserProfile(uid) {
  const user = [];

  try {
    const userQuery = `SELECT image, username, firstname, lastname, phonenumber, birthday FROM users WHERE uid = ${uid}`;
    const userResult = await databaseUtils.getDataFromDB(userQuery);

    if (userResult.length > 0) {
      user.push(userResult[0]);
    }
    return user;
  } catch (error) {
    throw error;
  }
}

module.exports = { retrieveUserProfile };
