import React from 'react';
import Routes from './routes';
import GlobalStyle from './globalStyles';
import { BrowserRouter as Router } from 'react-router-dom';


function App() {
  return (
    <Router>
      <GlobalStyle />
      <Routes />
    </Router>
  );
}

export default App;
