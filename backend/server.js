const express = require("express");
const cors = require("cors");
const { verifyToken } = require("./src/middlewares/authToken"); // นำเข้า middleware

const app = express();
const port = 3333;

app.use(express.json());
app.use(cors());

// นำเข้าและใช้งาน routers
const authRouter = require("./src/routes/auth");
app.use("/auth", authRouter);

app.get("/protected", verifyToken, (req, res) => {
  console.log(req.uid);
  res.json({ message: "คุณเข้าถึงเส้นทางที่คุ้มครองแล้ว" });
});

const menu = require("./src/routes/menu");
app.use("/menu", menu);

const order = require("./src/routes/order");
app.use("/order", order);

const user = require("./src/routes/user");
app.use("/user", user);

const restaurant = require("./src/routes/restaurant");
app.use("/restaurant", restaurant);

app.listen(port, () => {
  console.log(`เซิร์ฟเวอร์ทำงานที่พอร์ต ${port}`);
});
