const routes = require('express').Router();

const { getArbitro } = require('./controller');

routes.get('/', getArbitro);

module.exports = routes; 