const express = require("express");
const router = express.Router();
const databaseUtils = require("../utils/databaseUtils");

router.get("/get", async (req, res) => {
  try {
    const restaurant = await databaseUtils.getDataFromDB(
      `SELECT available FROM \`restaurant\``
    );
    res.status(200).json(restaurant);
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

router.patch("/isClose", (req, res) => {
  const available = req.body.available;
  const query = `UPDATE \`restaurant\` SET available = ?`;

  databaseUtils.updateColumn(query, available, (error) => {
    if (error) {
      return res.status(500).send("เกิดข้อผิดพลาดในการอัปเดตข้อมูล");
    } else {
      res.status(200).send("ข้อมูลถูกอัปเดตเรียบร้อยแล้ว");
    }
  });
});

module.exports = router;
