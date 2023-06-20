import styled from "styled-components";

export const GamesCard = styled.div`
  display: flex;
  flex-direction: column;

  width: 25%;
  height: 100%;
  margin-bottom: 40px;
  margin-left: 6%;

  border-radius: 10px;
  border: 1px solid black;
`;

export const TopCardDivisor = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;

  background-color: #000;
  color: #fff;
  border-radius: 8px 8px 20px 20px;
`;

export const CardContent = styled.div`
  display: flex;
  flex-direction: column;
  padding: 10px 20px 20px 20px;
`;

export const ItemsContainer = styled.div`
  display: flex;
  flex-direction: column;

  font-weight: 700;
  font-size: 20px;

  margin-top: 10px;
`;

export const Items = styled.li`
  display: flex;
  flex-direction: column;

  font-weight: 400;
  font-size: 16px;
  line-height: 1.5rem;

  margin-left: 20px;
`;
