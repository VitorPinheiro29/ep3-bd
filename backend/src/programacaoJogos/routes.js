const routes = require('express').Router();

const { getProgramJogos } = require('./controller');

routes.get('/', getProgramJogos);

module.exports = routes; 