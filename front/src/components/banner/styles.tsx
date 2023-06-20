import styled from "styled-components";

export const BannerContainer = styled.section`
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
