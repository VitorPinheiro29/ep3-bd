const connect = require('../../utils/db');

async function getJogosArbitro(req, res) {
  const client = await connect();


  const nomeArbitro = 'x'; // Nome selecionado no frontend

  const query = `SELECT DISTINCT j.idJogo, j.idsalao, j.ingressos, j.datajogo FROM jogo j INNER JOIN participantes pa ON pa.numassociado = j.numarbitro WHERE pa.nome = 'Samuel Melo Rodrigues' ORDER BY datajogo`;
  
  const result = await client.query(query);
  
  res.send(result.rows);
}

module.exports = { getJogosArbitro };