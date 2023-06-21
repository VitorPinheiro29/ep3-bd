const connect = require("../../utils/db");

async function getJogosHotel(req, res) {
  const client = await connect();

  let nomeHotel = req.query.nomeHotel; // Valor dinâmico para o parâmetro $1

  if (nomeHotel) {
    if (nomeHotel.includes("%20")) {
      nomehotel = nomeHotel.replace(/%20/g, " ");
    }
  }

  const query = `SELECT DISTINCT j.idjogo, j.numarbitro, j.idsalao, j.ingressos, j.datajogo FROM jogo j INNER JOIN salao s ON j.idSalao = s.idsalao WHERE s.nomeHotel = $1`;

  const queryReplaced = query.replace("$1", `'${nomeHotel}'`);

  const result = await client.query(queryReplaced);

  res.send(result.rows);
}

module.exports = { getJogosHotel };
