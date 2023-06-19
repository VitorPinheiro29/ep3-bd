const connect = require('../../utils/db');

async function getHotel(req, res) {
  const client = await connect();
  const result = await client.query('SELECT nomehotel FROM hotel');
  res.send(result.rows);
}

module.exports = { getHotel };