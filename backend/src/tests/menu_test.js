const express = require("express");
const router = express.Router();
const { menuData } = require("../models/menu");
const { db } = require("../config/database");

router.post("/create_menu", async (req, res) => {
  const { title, image, price } = req.body;

  try {
    if (!title || !image || !price) {
      return res.status(400).json({ error: "กรุณากรอกข้อมูลทั้งหมด" });
    }

    const checkMenuQuery = "SELECT * FROM menus WHERE title = ?";
    const [existingMenus] = await db.promise().query(checkMenuQuery, [title]);

    if (existingMenus.length > 0) {
      return res.status(400).json({ error: "Menu นี้มีอยู่ในระบบแล้ว" });
    }

    const insertQuery =
      "INSERT INTO menus (title, image, price) VALUES (?, ?, ?)";
    await db.promise().execute(insertQuery, [title, image, price]);

    res.json({ message: "ลงทะเบียนเมนูอาหารสำเร็จ" });
  } catch (err) {
    console.error("เกิดข้อมผิดพลาดในการลงทะเบียนเมนูอาหาร: " + err);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการลงทะเบียนเมนูอาหาร" });
  }
});

router.get("/menu", async (req, res) => {
  try {
    const sql = `
    SELECT
      M.menu_id,
      M.menu_title,
      M.menu_image,
      M.menu_price,
      FC.category_id,
      FC.category_title,
      FO.option_id,
      FO.option_title,
      FO.option_price
    FROM menu AS M
    INNER JOIN food_category AS FC ON M.food_category_id = FC.category_id
    INNER JOIN food_option AS FO ON FC.food_option_id = FO.option_id
  `;
    db.query(sql, (error, results, fields) => {
      if (error) {
        console.error("Error fetching data:", error);
      } else {
        // ทำอะไรกับข้อมูลที่ได้รับตรงนี้
        console.log(results);
      }
    });
  } catch (err) {
    console.error("error" + err);
    res.status(500).json({ error: "error" });
  }
});

module.exports = router;
