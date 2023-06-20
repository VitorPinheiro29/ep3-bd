import React, { useEffect, useState } from "react";

import { Container, NavOption, NavOptionContainer, Title } from "./styles";

export default function NavBar() {
  return (
    <Container>
      <Title>Sampa Chess</Title>
      <NavOptionContainer>
        <NavOption>Campeonatos</NavOption>
        <NavOption>Jogadores</NavOption>
        <NavOption>Hotéis</NavOption>
        <NavOption>Árbitros</NavOption>
      </NavOptionContainer>
    </Container>
  );
}
