const express = require('express');
const morgan = require('morgan');
const cors = require('cors');

const bodyParser = require('body-parser');
const app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use(morgan('dev'));
app.use(express.json());
app.use(cors());

app.use('/hotel', require('./hotel/routes'));
app.use('/jogosHotel', require('./jogosHotel/routes'));

app.use('/jogador', require('./jogador/routes'));
app.use('/jogosJogador', require('./jogosJogador/routes'));

app.use('/arbitro', require('./arbitro/routes'));
app.use('/jogosArbitro', require('./jogosArbitro/routes'));

app.use('/programacaoJogos', require('./programacaoJogos/routes'));

app.use('/movimentosJogos', require('./movimentosPorJogos/router'));

app.use('/jogadoresPais', require('./jogadoresPorPais/router'));

app.get('/', (req, res) => {
  res.send({
    message: 'Hello World'
  });
})

app.listen(3333, () => {
  console.log('Server on port 3333');
});