const routes = require('express').Router();

const { getJogadoresPorPais } = require('./controller');

routes.get('/', getJogadoresPorPais);

module.exports = routes; 