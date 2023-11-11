const jwt = require("jsonwebtoken");
const { secretKey } = require("../config/config"); // คีย์ลับสำหรับ JWT

function verifyToken(req, res, next) {
  const token = req.headers.authorization.split(" ")[1];

  if (!token) {
    return res.status(403).json({ error: "ไม่มี Token ในการเข้าถึง" });
  }

  jwt.verify(token, secretKey, (err, decoded) => {
    if (err) {
      return res.status(401).json({ error: "Token ไม่ถูกต้อง" });
    }
    req.uid = decoded.uid;
    req.phonenumber = decoded.phonenumber;
    next();
  });
}

module.exports = {
  verifyToken,
};
