import { createGlobalStyle } from "styled-components";

const GlobalStyle = createGlobalStyle`
  body {
    font-family: 'Quicksand', sans-serif;
    margin: 0;
  }

  a:-webkit-any-link {
      color: black;
      cursor: pointer;
      text-decoration: none;
  }
`;

export default GlobalStyle;
