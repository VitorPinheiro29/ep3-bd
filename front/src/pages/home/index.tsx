import React, { useState } from "react";

import bestPlace from "../../images/best_place.svg";

import api from "../../api";

import {
  Container,
  NavBar,
  Banner,
  BannerApresentation,
  ApresentationTitle,
  ApresentationDescription,
  BannerImage,
  GamesContainer,
  GamesCardContainer,
  GamesCard,
  InfoContainer,
  InfoList,
} from "./styles";
import PlayerTopic from "../../components/playerTopic";
import axios from "axios";

export default function Home() {
  // const data = api.get('/getHotel');

  // data.then((resp) => console.log("uhul", resp.data))

  axios.get("http://localhost:3333/hotel").then((response) => {
    console.log(response.data);
  });

  return (
    <Container>
      <NavBar>
        <h1>Sampa Chess</h1>
      </NavBar>
      <Banner>
        <BannerApresentation>
          <ApresentationTitle>Sampa Chess</ApresentationTitle>
          <ApresentationDescription>
            Confira a programação e os detalhes do maior campeonato
            internacional de xadrez do Brasil
          </ApresentationDescription>
        </BannerApresentation>
        <BannerImage>
          <img src={bestPlace} />
        </BannerImage>
      </Banner>
      <GamesContainer>
        <h1>Jogos</h1>
        <h2>Conheça todos os jogos do campeonato</h2>
        <GamesCardContainer>
          <GamesCard>
            <h1>Jogo 1</h1>
            <h3>♕ Jogadores:</h3>
            <h3>♕ Árbitros:</h3>
            <h3>♕ Lugar:</h3>
            <h3>♕ Horário:</h3>
          </GamesCard>
          <GamesCard>
            <h1>Jogo 2</h1>
            <h3>♕ Jogadores:</h3>
            <h3>♕ Árbitros:</h3>
            <h3>♕ Lugar:</h3>
            <h3>♕ Horário:</h3>
          </GamesCard>
          <GamesCard>
            <h1>Jogo 1</h1>
            <h3>♕ Jogadores:</h3>
            <h3>♕ Árbitros:</h3>
            <h3>♕ Lugar:</h3>
            <h3>♕ Horário:</h3>
          </GamesCard>
          <GamesCard>
            <h1>Jogo 1</h1>
            <h3>♕ Jogadores:</h3>
            <h3>♕ Árbitros:</h3>
            <h3>♕ Lugar:</h3>
            <h3>♕ Horário:</h3>
          </GamesCard>
        </GamesCardContainer>
      </GamesContainer>
      <InfoContainer>
        <h1>Jogadores</h1>
        <h2>Clique em um jogador para ver seus jogos programados</h2>
        <InfoList>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
        </InfoList>
      </InfoContainer>

      <InfoContainer>
        <h1>Hotéis</h1>
        <h2>Clique em um hotel para ver seus jogos programados</h2>
        <InfoList>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
        </InfoList>
      </InfoContainer>

      <InfoContainer>
        <h1>Árbitros</h1>
        <h2>Clique em um árbitro para ver seus jogos programados</h2>
        <InfoList>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
          <PlayerTopic>Armando</PlayerTopic>
        </InfoList>
      </InfoContainer>
    </Container>
  );
}
