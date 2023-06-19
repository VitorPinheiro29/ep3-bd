const connect = require('../../utils/db');

async function getJogosHotel(req, res) {
  const client = await connect();


  const hotelNome = 'Hilton'; // Valor selecionado no frontend

  const query = 'SELECT DISTINCT j.idJogo, j.numarbitro, j.idsalao, j.ingressos, j.datajogo FROM jogo j INNER JOIN salao s ON j.idsalao = s.idsalao WHERE s.nomehotel = $1 ORDER BY datajogo;';
  
  const result = await client.query(query, [hotelNome]);
  
  res.send(result.rows);
}

module.exports = { getJogosHotel };