const connect = require("../../utils/db");

async function getJogosArbitro(req, res) {
  const client = await connect();

  let nomeArbitro = req.query.nomeArbitro; // Valor dinâmico para o parâmetro $1

  if (nomeArbitro) {
    if (nomeArbitro.includes("%20")) {
      nomeArbitro = nomeArbitro.replace(/%20/g, " ");
    }
  }

  const query = `SELECT DISTINCT j.idJogo, j.idsalao, j.ingressos, j.datajogo FROM jogo j INNER JOIN participantes pa ON pa.numassociado = j.numarbitro WHERE pa.nome = $1 ORDER BY datajogo`;

  const queryReplaced = query.replace("$1", `'${nomeArbitro}'`);

  const result = await client.query(queryReplaced);

  res.send(result.rows);
}

module.exports = { getJogosArbitro };
