const routes = require('express').Router();

const { getJogador } = require('./controller');

routes.get('/', getJogador);

module.exports = routes; 