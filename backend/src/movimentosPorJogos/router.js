const routes = require('express').Router();

const { getMovimentosPorJogos } = require('./controller');

routes.get('/', getMovimentosPorJogos);

module.exports = routes; 