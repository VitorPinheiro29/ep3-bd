const connect = require('../../utils/db');

async function getJogador(req, res) {
  const client = await connect();
  const result = await client.query('SELECT  nome, jogador.numassociado, nivel, idpais FROM jogador inner join participantes on jogador.numassociado = participantes.numassociado');
  res.send(result.rows);
}

module.exports = { getJogador };