const connect = require("../../utils/db");

async function getArbitro(req, res) {
  const client = await connect();
  const result =
    await client.query(`SELECT nome, participantes.numassociado, idpais
    FROM participantes
    INNER JOIN campeonato ON campeonato.numassociado = participantes.numassociado
    WHERE tipoparticipante = 'árbitro'`);
  res.send(result.rows);
}

module.exports = { getArbitro };
