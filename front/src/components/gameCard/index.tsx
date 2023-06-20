import React, { useEffect, useState } from "react";

import {
  GamesCard,
  TopCardDivisor,
  CardContent,
  ItemsContainer,
  Items,
} from "./styles";

export default function GameCardComponent(props: any) {
  const dataObjeto = new Date(props.value.datajogo);
  const dia = dataObjeto.getUTCDate().toString().padStart(2, "0");
  const mes = (dataObjeto.getUTCMonth() + 1).toString().padStart(2, "0");
  const ano = dataObjeto.getUTCFullYear().toString();
  const dataFormatada = `${dia}/${mes}/${ano}`;

  return (
    <GamesCard>
      <TopCardDivisor>
        <h1>Jogo {props.value.idjogo}</h1>
      </TopCardDivisor>
      <CardContent>
        <ItemsContainer>
          ♕ Jogadores
          {props.value.jogador.map((player: any) => <Items>♗ {player}</Items>)}
        </ItemsContainer>
        <ItemsContainer>
          ♕ Árbitros
          {props.value.arbitro.map((referee: any) => <Items>♗ {referee}</Items>)}
        </ItemsContainer>
        <ItemsContainer>
          ♕ Lugar
          <Items>♗ {props.value.nomehotel}</Items>
        </ItemsContainer>
        <ItemsContainer>
          ♕ Data
          <Items>♗ {dataFormatada}</Items>
        </ItemsContainer>
      </CardContent>
    </GamesCard>
  );
}
