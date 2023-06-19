const connect = require('../../utils/db');

async function getProgramJogos(req, res) {
  const client = await connect();
  const result = await client.query(`SELECT P2.nome, P1.nome, J.datajogo FROM jogo J
  INNER JOIN salao S ON S.idsalao = J.idsalao
  INNER JOIN jogam JM ON JM.idjogo = J.idjogo
  INNER JOIN participantes P1 ON P1.numassociado = J.numarbitro
  INNER JOIN participantes P2 On P2.numassociado = JM.numjogador`);
  res.send(result.rows);
}

module.exports = { getProgramJogos };