const connect = require('../../utils/db');

async function getHotel(req, res) {
  const client = await connect();
  const query = 'SELECT nomeHotel FROM hotel';

  const result = await client.query(query);

  res.send(result.rows);
}

module.exports = { getHotel };