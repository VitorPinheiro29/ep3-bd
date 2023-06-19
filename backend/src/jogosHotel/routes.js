const routes = require('express').Router();

const { getJogosHotel } = require('./controller');

routes.get('/', getJogosHotel);

module.exports = routes; 