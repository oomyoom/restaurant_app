//ของร้านอาหาร
const express = require("express");
const router = express.Router();
const { db } = require("../config/database");
const menuCreation = require("../controllers/menuCreation");
const menuRetrieval = require("../controllers/menuRetrieval");
const databaseUtils = require("../utils/databaseUtils");
const multer = require("multer");

const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

router.post("/create", upload.single("image"), async (req, res) => {
  const menuData = JSON.parse(req.body.menuData);
  const image = req.file.buffer;

  databaseUtils.getLastId("menu", (error, lastMenuId) => {
    if (error) {
      return res.status(500).send("เกิดข้อผิดพลาดในการดึงค่า MenuId ล่าสุด");
    }

    databaseUtils.getLastId("mcategory", async (error, lastCateId) => {
      if (error) {
        return res
          .status(500)
          .send("เกิดข้อผิดพลาดในการดึงค่า CategoryId ล่าสุด");
      }

      const checkMenuQuery = "SELECT * FROM menu WHERE menu_title = ?";
      const [existingMenu] = await db
        .promise()
        .query(checkMenuQuery, [menuData.menu_title]);

      if (existingMenu.length > 0) {
        return res.status(400).json({ error: "Menu นี้มีอยู่ในระบบแล้ว" });
      }

      menuCreation.insertMenu(
        menuData,
        image,
        lastMenuId,
        (error, lastMenuId) => {
          if (error) {
            return res.status(500).send("เกิดข้อผิดพลาดในการแทรกข้อมูลเมนู");
          }

          menuCreation.insertCategory(
            menuData.categories,
            lastMenuId,
            lastCateId,
            (error, lastCateId) => {
              if (error) {
                return res
                  .status(500)
                  .send("เกิดข้อผิดพลาดในการแทรกข้อมูลหมวดหมู่");
              }

              menuCreation.insertOption(
                menuData.categories,
                lastCateId,
                (error) => {
                  if (error) {
                    return res
                      .status(500)
                      .send("เกิดข้อผิดพลาดในการแทรกข้อมูลตัวเลือก");
                  }

                  res.status(200).send("เมนูถูกสร้างเรียบร้อยแล้ว");
                }
              );
            }
          );
        }
      );
    });
  });
});

router.get("/get", async (req, res) => {
  try {
    const allMenu = await menuRetrieval.retrieveMenu();
    res.status(200).json(allMenu);
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

router.get("/get/user", async (req, res) => {
  try {
    const allMenu = await menuRetrieval.retrieveMenuUser();
    res.status(200).json(allMenu);
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

router.patch("/available", (req, res) => {
  const menu_id = req.body.menu_id;
  const available = req.body.available;
  const query = `UPDATE \`menu\` SET available = ? WHERE menu_id = ${menu_id}`;

  databaseUtils.updateColumn(query, available, (error) => {
    if (error) {
      return res.status(500).send("เกิดข้อผิดพลาดในการอัปเดตข้อมูล");
    } else {
      res.status(200).send("ข้อมูลถูกอัปเดตเรียบร้อยแล้ว");
    }
  });
});

module.exports = router;
