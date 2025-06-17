const express = require('express');
const dotenv = require('dotenv');
const path = require('path');
const routes = require('./routes');

dotenv.config();
const app = express();
const port = process.env.PORT || 3000;

app.use(express.static(path.join(__dirname, '../public')));

app.use('/', routes);

app.listen(port, '0.0.0.0', () => {
  console.log(`Server is running on port ${port}`);
});



