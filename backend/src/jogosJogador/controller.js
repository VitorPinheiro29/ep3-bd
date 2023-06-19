const connect = require('../../utils/db');

async function getJogosJogador(req, res) {
  const client = await connect();


  const nomeJogador = 'x'; // Nome selecionado no frontend

  const query = 'SELECT DISTINCT j.idJogo, j.numarbitro, j.idsalao, j.ingressos, j.datajogo FROM jogo j INNER JOIN salao s ON j.idsalao = s.idsalao INNER JOIN jogam jo ON j.idJogo = jo.idJogo INNER JOIN participantes pa ON pa.numassociado = jo.numjogador WHERE pa.nome = $1 ORDER BY datajogo';
  
  const result = await client.query(query, [nomeJogador]);
  
  res.send(result.rows);
}

module.exports = { getJogosJogador };