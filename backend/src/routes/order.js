const express = require("express");
const router = express.Router();
const orderCreation = require("../controllers/orderCreation");
const orderRetrieval = require("../controllers/orderRetrieval");
const databaseUtils = require("../utils/databaseUtils");
const { verifyToken } = require("../middlewares/authToken");
const { db } = require("../config/database");

router.post("/create", verifyToken, (req, res) => {
  const orderData = req.body.orderData;
  const cartData = req.body.cartData;
  databaseUtils.getLastId("order", (error, lastOrderId) => {
    if (error) {
      return res.status(500).send("เกิดข้อผิดพลาดในการดึงค่า OrderId ล่าสุด");
    }

    orderCreation.insertOrder(
      orderData,
      lastOrderId,
      req.uid,
      (error, lastOrderId) => {
        if (error) {
          return res.status(500).send("เกิดข้อผิดพลาดในการแทรกข้อมูลออเดอร์");
        }

        orderCreation.insertCart(cartData, lastOrderId, (error) => {
          if (error) {
            return res.status(500).send("เกิดข้อผิดพลาดในการแทรกข้อมูลตระกร้า");
          }

          res.status(200).send("ออเดอร์ถูกสร้างเรียบร้อยแล้ว");
        });
      }
    );
  });
});

router.get("/get", verifyToken, async (req, res) => {
  try {
    const allOrder = await orderRetrieval.retrieveOrder(req.uid);
    res.status(200).json(allOrder);
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

router.get("/getlastId", async (req, res) => {
  try {
    databaseUtils.getLastId("order", (error, lastOrderId) => {
      if (error) {
        return res.status(500).send("เกิดข้อผิดพลาดในการดึงค่า OrderId ล่าสุด");
      }
      res.status(200).json(lastOrderId - 1);
    });
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

router.patch("/completed", (req, res) => {
  const order_id = req.body.order_id;
  const query = `UPDATE \`order\` SET isCompleted = ? WHERE order_id = ${order_id}`;

  databaseUtils.updateColumn(query, true, (error) => {
    if (error) {
      return res.status(500).send("เกิดข้อผิดพลาดในการอัปเดตข้อมูล");
    } else {
      res.status(200).send("ข้อมูลถูกอัปเดตเรียบร้อยแล้ว");
    }
  });
});

router.patch("/recieved", verifyToken, (req, res) => {
  const order_id = req.body.order_id;
  const query = `UPDATE \`order\` SET isRecieved = ? WHERE uid = ${req.uid} && isCompleted = 1 && order_id = ${order_id}`;

  databaseUtils.updateColumn(query, true, (error) => {
    if (error) {
      return res.status(500).send("เกิดข้อผิดพลาดในการอัปเดตข้อมูล");
    } else {
      res.status(200).send("ข้อมูลถูกอัปเดตเรียบร้อยแล้ว");
    }
  });
});

router.get("/queue", async (req, res) => {
  try {
    const queue = await databaseUtils.getDataFromDB(
      `SELECT order_id FROM \`order\` WHERE isCompleted = 0`
    );
    res.status(200).json(queue);
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

router.get("/notification", verifyToken, async (req, res) => {
  try {
    const noti = await databaseUtils.getDataFromDB(
      `SELECT order_id, isRecieved, isReaded, uid FROM \`order\` WHERE isCompleted = 1 && uid = ${req.uid} && isRecieved = 0`
    );
    res.status(200).json(noti);
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

router.patch("/readed", verifyToken, async (req, res) => {
  const order_id = req.body.order_id;
  const query = `UPDATE \`order\` SET isReaded = ? WHERE uid = ${req.uid} && isCompleted = 1 && order_id = ${order_id}`;

  databaseUtils.updateColumn(query, true, (error) => {
    if (error) {
      return res.status(500).send("เกิดข้อผิดพลาดในการอัปเดตข้อมูล");
    } else {
      res.status(200).send("ข้อมูลถูกอัปเดตเรียบร้อยแล้ว");
    }
  });
});

router.get("/allorder", async (req, res) => {
  try {
    const allOrder = await orderRetrieval.retrieveOrderRestaurant(0);
    res.status(200).json(allOrder);
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

router.get("/transaction", async (req, res) => {
  try {
    const allOrder = await orderRetrieval.retrieveOrderRestaurant(1);
    res.status(200).json(allOrder);
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

router.get("/transaction/week", async (req, res) => {
  try {
    const allOrder = await orderRetrieval.retrieveOrderRestaurantThisWeek();
    res.status(200).json(allOrder);
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

router.get("/transaction/day", async (req, res) => {
  try {
    const allOrder = await orderRetrieval.retrieveOrderRestaurantThisDay();
    res.status(200).json(allOrder);
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

router.get("/transaction/month", async (req, res) => {
  try {
    const allOrder = await orderRetrieval.retrieveOrderRestaurantThisMonth();
    res.status(200).json(allOrder);
  } catch (error) {
    console.error("เกิดข้อผิดพลาดในการดึงข้อมูล:", error);
    res.status(500).json({ error: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

module.exports = router;
