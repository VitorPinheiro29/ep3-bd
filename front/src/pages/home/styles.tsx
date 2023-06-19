import styled from "styled-components";

<style>
  @import url('https://fonts.googleapis.com/css2?family=Crimson+Text:wght@400;700&display=swap');
</style>

export const Container = styled.main`
  display: flex;
  flex-direction: column;
  width: 100%;
  margin: 0px;
`;

export const NavBar = styled.nav`
  display: flex;
  flex-direction: row;
  width: 100%;
  height: 15vh;
  background-color: #000;
`;

export const Banner = styled.section`
  display: flex;
  flex-direction: row;
  justify-content: space-between;

  margin-top: 30px;
  width: 100%;
  height: 60vh;
`;

export const BannerApresentation = styled.section`
  display: flex;
  flex-direction: column;
  width: 50%;
  height: 60vh;

  margin-left: 40px;
`;

export const ApresentationTitle = styled.h1`
  font: 500 40px Crimson Text, serif;
  margin-bottom: 80px;

  color: #333333;
`;

export const ApresentationDescription = styled.h2`
  display: flex;
  flex-direction: column;
  width: 80%;
  height: 60vh;

  font: 500 25px Roboto, sans-serif;
  line-height: 2.5rem;
  text-align: justify;

  color: #006400;
`;

export const BannerImage = styled.section`
  display: flex;
  width: 50%;
  margin-right: 40px;
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
  justify-content: space-between;

  width: 100%;

  border-radius: 10px;
`;

export const GamesCard = styled.div`
  display: flex;
  flex-direction: column;

  width: 25%;
  height: 100%;
  padding: 20px;
  margin-bottom: 20px;

  border-radius: 10px;
  border: 1px solid black;
`;

export const HotelsContainer = styled.section`
  display: flex;
`;

export const InfoContainer = styled.section`
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
`;

export const InfoList = styled.div`
  display: flex;
  flex-wrap: wrap;
  flex-direction: row;

  width: 100%;
  padding-left: 200px;

  border: 1px solid purple;
`;
