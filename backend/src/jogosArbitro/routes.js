const routes = require('express').Router();

const { getJogosArbitro } = require('./controller');

routes.get('/', getJogosArbitro);

module.exports = routes; 