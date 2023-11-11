const mysql = require("mysql2");

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  database: "food_app",
});

db.connect((err) => {
  if (err) {
    console.error("เกิดข้อผิดพลาดในการเชื่อมต่อกับ MySQL2: " + err);
    throw err; // สามารถเลือกจะ throw ข้อผิดพลาดหรือทำการจัดการอื่น ๆ ตามที่คุณต้องการ
  } else {
    console.log("เชื่อมต่อกับ MySQL2 สำเร็จ");
  }
});

// ตรวจสอบการขาดการเชื่อมต่อกับฐานข้อมูลและเชื่อมต่ออีกครั้งหากจำเป็น
db.on("error", (err) => {
  console.error("เกิดข้อผิดพลาดในการเชื่อมต่อกับ MySQL2: " + err);
  if (err.code === "PROTOCOL_CONNECTION_LOST") {
    // หากการเชื่อมต่อกับ MySQL หลุดออก ลองเชื่อมต่ออีกครั้ง
    db.connect((reconnectErr) => {
      if (reconnectErr) {
        console.error(
          "เกิดข้อผิดพลาดในการเชื่อมต่อกับ MySQL2 อีกครั้ง: " + reconnectErr
        );
        throw reconnectErr;
      } else {
        console.log("เชื่อมต่อกับ MySQL2 อีกครั้งสำเร็จ");
      }
    });
  } else {
    throw err;
  }
});

module.exports = {
  db,
};
