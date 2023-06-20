import styled from "styled-components";

export const Container = styled.nav`
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;

  width: 100%;
  height: 15vh;
  background-color: #000;
`;

export const Title = styled.h2`
  font: 500 30px Roboto, sans-serif;
  color: #fff;

  margin-left: 40px;
`;

export const NavOptionContainer = styled.div`
    display: flex;
    flex-irection: row;
    justify-content: space-between;

    width: 50%;
    margin-right: 40px;
`;


export const NavOption = styled.h3`
    font: 500 20px Roboto, sans-serif;
    color: #fff;

    cursor: pointer;
`;


