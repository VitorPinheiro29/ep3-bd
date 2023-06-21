import styled from "styled-components";

<style>
  @import
  url('https://fonts.googleapis.com/css2?family=Crimson+Text:wght@400;700&display=swap');
</style>;

export const Container = styled.main`
  display: flex;
  flex-direction: column;
  width: 100%;
  margin: 0px;
`;

export const GamesContainer = styled.section`
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  margin: 40px;
`;

export const GamesCardContainer = styled.div`
  display: flex;
  flex-wrap: wrap;
  flex-direction: row;
  justify-content: space-around;

  width: 100%;

  border-radius: 10px;
`;


export const HotelsContainer = styled.section`
  display: flex;
`;

export const InfoContainer = styled.section`
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;

  margin-top: 20px;
  margin-left: 40px;
  margin-right: 40px;

  border-top: 1px solid black;
`;

export const InfoList = styled.div`
  display: flex;
  flex-wrap: wrap;
  flex-direction: row;

  width: 100%;
  padding-left: 200px;
  padding-top: 20px;
  padding-bottom: 10px;
`;

export const GraficosContainer = styled.section`
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  
  width: 80%;
  margin-bottom: 50px;
  padding-left: 15%;
  padding-top: 5%;
  margin-right: 15%;
  margin-left: 40px;

  border-top: 1px solid black;
`;
