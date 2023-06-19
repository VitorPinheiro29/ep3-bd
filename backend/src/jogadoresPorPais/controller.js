const connect = require('../../utils/db');

async function getJogadoresPorPais(req, res) {
  const client = await connect();
  const result = await client.query(`SELECT nomepais, COUNT(*) as totalDeJogadores
  FROM pais NATURAL JOIN participantes
  GROUP BY idpais`);
  res.send(result.rows);
}

module.exports = { getJogadoresPorPais };