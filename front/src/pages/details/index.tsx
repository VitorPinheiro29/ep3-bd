import React, { useEffect, useState } from "react";
import Banner from "../../components/banner";
import NavBar from "../../components/navbar";

import api from "../../api";
import { Container, InfosContainer } from "../details/styles";
import GameCardComponent from "../../components/gameCard";

export default function DetailsPage() {
  const [data, setData] = React.useState<any>([]);

  useEffect(() => {
    const url = window.location.pathname;
    const queryParams = window.location.search;

    const getData = async () => {
      const data = await api.get(url + queryParams);
      setData(data.data);
    };

    getData().catch((err) => console.log(err));
  }, []);

  return (
    <Container>
      <NavBar></NavBar>
      <Banner></Banner>
      <InfosContainer>
        {data.map((resp: any) => (
          <div>
            <h2>Jogo {resp.idjogo}</h2>
            <h2>Ingressos {resp.ingressos}</h2>
            <h2>Data {resp.datajogo}</h2>
          </div>
        ))}
      </InfosContainer>
    </Container>
  );
}
