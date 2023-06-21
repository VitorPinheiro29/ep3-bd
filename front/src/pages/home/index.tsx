import React, { useEffect, useState } from "react";

import api from "../../api";

import {
  Container,
  GamesContainer,
  GamesCardContainer,
  InfoContainer,
  InfoList,
  GraficosContainer,
} from "./styles";

import PlayerTopic from "../../components/playerTopic";
import Grafico from "../../components/grafico";
import NavBar from "../../components/navbar";
import Banner from "../../components/banner";
import GameCardComponent from "../../components/gameCard";

import { Link, useNavigate } from "react-router-dom";

export default function Home() {
  const [championships, setChampionships] = React.useState<any>([]);
  const [players, setPlayers] = React.useState<any>([]);
  const [hotel, setHotels] = React.useState<any>([]);
  const [referee, setReferees] = React.useState<any>([]);

  useEffect(() => {
    const getChampionships = async () => {
      const data = await api.get("/programacaoJogos");

      const grupos: any[] = [];
      const idsJogos: number[] = [];

      for (const jogo of data.data) {
        if (!idsJogos.includes(jogo.idjogo)) {
          idsJogos.push(jogo.idjogo);
          grupos.push({
            ...jogo,
            jogador: [jogo.jogador],
            arbitro: [jogo.arbitro],
          });
        } else {
          const index = grupos.findIndex((item) => item.idjogo === jogo.idjogo);
          if (!grupos[index].jogador.includes(jogo.jogador)) {
            grupos[index].jogador.push(jogo.jogador);
          }
          if (!grupos[index].arbitro.includes(jogo.arbitro)) {
            grupos[index].arbitro.push(jogo.arbitro);
          }
        }
      }

      setChampionships(grupos);
    };

    const getPlayers = async () => {
      const data = await api.get("/jogador");
      setPlayers(data.data);
    };

    const getHotels = async () => {
      const data = await api.get("/hotel");
      setHotels(data.data);
    };

    const getReferees = async () => {
      const data = await api.get("/arbitro");
      setReferees(data.data);
    };

    getChampionships().catch((err) => console.log(err));
    getPlayers().catch((err) => console.log(err));
    getHotels().catch((err) => console.log(err));
    getReferees().catch((err) => console.log(err));
  }, []);

  return (
    <Container>
      <NavBar></NavBar>
      <Banner></Banner>
      <GamesContainer>
        <h1>Campeonatos</h1>
        <h2>Conheça todos os jogos do campeonato</h2>
        <GamesCardContainer>
          {championships.map((championship: any) => (
            <GameCardComponent
              key={championship.idjogo}
              value={championship}
            ></GameCardComponent>
          ))}
        </GamesCardContainer>
      </GamesContainer>
      <InfoContainer>
        <h1>Jogadores</h1>
        <h2>Clique em um jogador para ver seus jogos programados</h2>
        <InfoList>
          {players.map((resp: any) => (
            <PlayerTopic key={resp.nome}>
              <Link to={`/jogosJogador?nomeJogador=${resp.nome}`}>
                {resp.nome}
              </Link>
            </PlayerTopic>
          ))}
        </InfoList>
      </InfoContainer>

      <InfoContainer>
        <h1>Hotéis</h1>
        <h2>Clique em um hotel para ver seus jogos programados</h2>
        <InfoList>
          {hotel.map((resp: any) => (
            <PlayerTopic key={resp.nomehotel}>
              <Link to={`/jogosHotel?nomeHotel=${resp.nomehotel}`}>
                {resp.nomehotel}
              </Link>
            </PlayerTopic>
          ))}
        </InfoList>
      </InfoContainer>

      <InfoContainer>
        <h1>Árbitros</h1>
        <h2>Clique em um árbitro para ver seus jogos programados</h2>
        <InfoList>
          {referee.map((resp: any) => (
            <PlayerTopic key={resp.nome}>
              <Link to={`/jogosArbitro?nomeArbitro=${resp.nome}`}>
                {resp.nome}
              </Link>
            </PlayerTopic>
          ))}
        </InfoList>
      </InfoContainer>

      <GraficosContainer>
        <Grafico value={"movement"}></Grafico>
        <Grafico value={"players"}></Grafico>
      </GraficosContainer>
    </Container>
  );
}
