const connect = require('../../utils/db');

async function getMovimentosPorJogos(req, res) {
  const client = await connect();
  const result = await client.query(`SELECT idJogo, COUNT(*) as totalDeMovimentos
  FROM jogo NATURAL JOIN movimentos
  GROUP BY idJogo`);
  res.send(result.rows);
}

module.exports = { getMovimentosPorJogos };