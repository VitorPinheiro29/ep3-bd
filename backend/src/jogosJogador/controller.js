const connect = require("../../utils/db");

async function getJogosJogador(req, res) {
  const client = await connect();

  let nomeJogador = req.query.nomeJogador; // Valor dinâmico para o parâmetro $1

  if (nomeJogador) {
    if (nomeJogador.includes("%20")) {
      nomeJogador = nomeJogador.replace(/%20/g, " ");
    }
  }

  const query = `SELECT DISTINCT j.idJogo, j.numarbitro, j.idsalao, j.ingressos, j.datajogo FROM jogo j INNER JOIN salao s ON j.idsalao = s.idsalao INNER JOIN jogam jo ON j.idJogo = jo.idJogo INNER JOIN participantes pa ON pa.numassociado = jo.numjogador WHERE pa.nome = $x ORDER BY datajogo`;

  const queryReplaced = query.replace("$x", `'${nomeJogador}'`);

  const result = await client.query(queryReplaced);

  res.send(result.rows);
}

module.exports = { getJogosJogador };
