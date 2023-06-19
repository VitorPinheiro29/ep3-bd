const routes = require('express').Router();

const { getHotel } = require('./controller');

routes.get('/', getHotel);

module.exports = routes; 