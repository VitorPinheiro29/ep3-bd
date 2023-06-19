const connect = require('../../utils/db');

async function getArbitro(req, res) {
  const client = await connect();
  const result = await client.query('SELECT  nome, participantes.numassociado, idpais FROM participantes inner join campeonato on campeonato.numassociado = participantes.numassociado where tipoparticipante = "árbitro"');
  res.send(result.rows);
}

module.exports = { getArbitro };