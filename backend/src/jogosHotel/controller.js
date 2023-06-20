const connect = require('../../utils/db');

async function getJogosHotel(req, res) {
  const client = await connect();

  const query = 'SELECT DISTINCT j.idjogo, j.numarbitro, j.idsalao, j.ingressos, j.datajogo FROM jogo j INNER JOIN salao s ON j.idSalao = s.idsalao';
  const nomeHotel = 'Hilton'; // Valor dinâmico para o parâmetro $1
  
  const result = await client.query(query);
  
  res.send(result.rows);
}

module.exports = { getJogosHotel };