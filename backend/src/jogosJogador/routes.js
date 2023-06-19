const routes = require('express').Router();

const { getJogosJogador } = require('./controller');

routes.get('/', getJogosJogador);

module.exports = routes; 