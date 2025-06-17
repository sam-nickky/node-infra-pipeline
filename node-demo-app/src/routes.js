const express = require('express');
const router = express.Router();


router.get('/', (req, res) => {
  res.json({ message: 'Welcome! Use /health or /users' });
});


router.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

router.get('/users', (req, res) => {
  res.json([
    { id: 1, name: 'Alice' },
    { id: 2, name: 'Bob' }
  ]);
});

module.exports = router;

