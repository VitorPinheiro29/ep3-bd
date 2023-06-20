import React, { useEffect, useState } from "react";
import Banner from "../../components/banner";
import NavBar from "../../components/navbar";

import { Container } from "../home/styles";

export default function DetailsPage() {
  return (
    <Container>
      <NavBar></NavBar>
      <Banner></Banner>
    </Container>
  );
}
