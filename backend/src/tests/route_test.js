const express = require('express');
const router = express.Router();

// เส้นทางหลัก
router.get('/', (req, res) => {
  res.send('ยินดีต้อนรับสู่แอปพลิเคชันของเรา');
});

// เส้นทางอื่นๆ
router.get('/about', (req, res) => {
  res.send('เกี่ยวกับเรา');
});

module.exports = router;
